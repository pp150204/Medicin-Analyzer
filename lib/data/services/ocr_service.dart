import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

/// Thrown when OCR is not available (e.g. on Windows, Web, Linux, macOS).
class OcrUnsupportedException implements Exception {
  final String message;
  OcrUnsupportedException([this.message = 'Text recognition only works on Android and iOS. Please run the app on a phone or tablet.']);
}

class OcrService {
  static TextRecognizer? _textRecognizer;
  static TextRecognizer get _recognizer {
    _textRecognizer ??= TextRecognizer(
      script: TextRecognitionScript.latin,
    );
    return _textRecognizer!;
  }

  static final _imagePicker = ImagePicker();

  /// ML Kit text recognition only works on Android and iOS.
  static bool get isOcrSupported {
    if (kIsWeb) return false;
    return Platform.isAndroid || Platform.isIOS;
  }

  /// Camera picker only works properly on Android and iOS.
  static bool get isCameraSupported => isOcrSupported;

  static Future<File?> pickImageFromCamera() async {
    try {
      // On Windows/Web/Linux/macOS, camera opens gallery. Use gallery as fallback.
      final source = isCameraSupported ? ImageSource.camera : ImageSource.gallery;
      final XFile? image = await _imagePicker.pickImage(source: source);
      return image != null ? File(image.path) : null;
    } catch (e) {
      debugPrint('Error picking image from camera: $e');
      return null;
    }
  }

  static Future<File?> pickImageFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
      );
      return image != null ? File(image.path) : null;
    } catch (e) {
      debugPrint('Error picking image from gallery: $e');
      return null;
    }
  }

  static Future<String?> extractTextFromImage(File imageFile) async {
    if (!isOcrSupported) {
      throw OcrUnsupportedException();
    }
    try {
      final inputImage = InputImage.fromFile(imageFile);
      final recognizedText = await _recognizer.processImage(inputImage);

      String extractedText = '';
      for (TextBlock block in recognizedText.blocks) {
        for (TextLine line in block.lines) {
          extractedText += '${line.text}\n';
        }
      }

      return extractedText.trim().isNotEmpty ? extractedText.trim() : null;
    } on OcrUnsupportedException {
      rethrow;
    } catch (e) {
      if (e.toString().contains('MissingPluginException') ||
          e.toString().contains('vision#startTextRecognizer')) {
        throw OcrUnsupportedException(
          'Text recognition requires Android or iOS. Run the app on a phone or tablet.',
        );
      }
      debugPrint('Error extracting text from image: $e');
      return null;
    }
  }

  static Future<String?> extractMedicineNameFromImage(File imageFile) async {
    try {
      final text = await extractTextFromImage(imageFile);
      if (text == null || text.isEmpty) return null;

      final lines = text
          .split(RegExp(r'[\n\r]+'))
          .map((line) => line.trim())
          .where((line) => line.isNotEmpty)
          .toList();

      if (lines.isEmpty) return null;

      // Filter out junk: too short, pure numbers, single letters, dosage codes
      final medicineLines = lines.where((line) {
        final trimmed = line.trim();
        if (trimmed.length < 4) return false; // "000", "X" - too short
        if (trimmed.length > 80) return false; // Likely paragraph, not name
        if (RegExp(r'^[\d\s\.\-]+$').hasMatch(trimmed)) return false; // Pure numbers
        if (RegExp(r'^\d+\s*(mg|ml|mcg|g|IU|tablets?|caps?)\b', caseSensitive: false).hasMatch(trimmed)) return false; // "500mg", "10 tablets"
        if (RegExp(r'^[A-Za-z]$').hasMatch(trimmed)) return false; // Single letter
        if (trimmed.endsWith('.') || trimmed.endsWith('!') || trimmed.endsWith('?')) return false;
        return true;
      }).toList();

      if (medicineLines.isEmpty) return null;

      // Prefer lines that look like medicine names (4–40 chars, mostly letters)
      medicineLines.sort((a, b) {
        final aScore = _medicineNameScore(a);
        final bScore = _medicineNameScore(b);
        return bScore.compareTo(aScore); // Higher score first
      });

      return medicineLines.first.trim();
    } on OcrUnsupportedException {
      rethrow;
    } catch (e) {
      debugPrint('Error extracting medicine name: $e');
      return null;
    }
  }

  /// Scores a line by how likely it is to be a medicine name.
  /// Higher = more likely. Prefers 4–40 chars, mostly letters, no dosage patterns.
  static int _medicineNameScore(String line) {
    final trimmed = line.trim();
    int score = 0;
    if (trimmed.length >= 4 && trimmed.length <= 40) score += 20; // Good length
    if (trimmed.length >= 6 && trimmed.length <= 25) score += 10; // Typical medicine name length
    final letterCount = trimmed.replaceAll(RegExp(r'[^A-Za-z]'), '').length;
    if (letterCount >= trimmed.length * 0.5) score += 15; // Mostly letters
    if (!RegExp(r'\d').hasMatch(trimmed)) score += 5; // No numbers (many medicines have none)
    if (!RegExp(r'[^\w\s\-]').hasMatch(trimmed)) score += 5; // No special chars
    return score;
  }

  static Future<void> dispose() async {
    await _textRecognizer?.close();
    _textRecognizer = null;
  }
}
