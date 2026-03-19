🧬 Medicine Insight App

A fully functional Flutter mobile application designed to help users understand medicines and health conditions in a simple, structured, and responsible way.

The app focuses on clarity, safety, and reliability, combining a modern UI with AI-driven insights — while never replacing professional medical advice.

✨ Purpose of the App

Medical information can often feel confusing and overwhelming.
Medicine Insight is built to:

Present medicine details in a simple and structured format

Reduce confusion and misinformation

Promote safe and responsible usage

Provide a calm and trustworthy user experience

⚠️ Note: This application is for educational purposes only and is not a substitute for medical professionals.

🎯 Key Features
🔍 Flexible Input Options

Search medicines by name

Scan medicines using the device camera

Upload images from gallery

Extract text via OCR (with manual editing support)

🧠 AI-Driven Analysis

Powered by Groq AI

Uses well-designed prompts for accuracy

Generates structured JSON responses

Ensures neutral, non-prescriptive explanations

💊 Detailed Medicine Breakdown

Each medicine includes:

Purpose of the medicine

Recommended timing (before/after meals)

Usage method (tablet, syrup, etc.)

General dosage information (non-prescriptive)

Possible side effects (common & serious)

Precautions and restrictions

Alternative medicine options

Food and lifestyle suggestions

Missed dose instructions

Storage recommendations

All information is displayed using clean glass-style cards for better readability.

🩺 Health Condition Support

Users can also input a health condition and get:

Suggested foods

Foods to avoid

Healthy daily habits

Guidance on when to consult a doctor

🎨 Design Approach

Glassmorphism-inspired UI

Smooth gradients (blue, teal, purple)

Full Dark Mode support

Fluid animations and transitions

Clean typography and calming visuals

The design aims to provide a professional and trustworthy experience.

🧱 Project Structure

Built using Clean Architecture:

lib/
├── core/              # Constants, themes, utilities
├── data/              # APIs, models, repositories
├── domain/            # Business logic & interfaces
└── presentation/      # UI, state management, widgets
📦 State Management

Riverpod

FutureProvider → Async operations

StateProvider → UI state

🛠️ Technology Stack

Flutter (3.9.2+)

Dart

Riverpod

Dio (API handling)

Groq AI

Google ML Kit (OCR)

SharedPreferences

flutter_dotenv

🚀 Setup Guide
📋 Requirements

Flutter SDK ≥ 3.9.2

Dart SDK

Groq API Key

⚙️ Installation Steps
1️⃣ Clone the repository
git clone https://github.com/akshaypatra00/medicine-analyzer-flutter.git
cd medicine-analyzer-flutter
2️⃣ Install dependencies
flutter pub get
3️⃣ Generate required files
flutter pub run build_runner build
4️⃣ Configure environment variables

Create a .env file:

GROQ_API_KEY=your_api_key_here
5️⃣ Run the app
flutter run
📱 App Screens

Splash Screen

Home (Search & Scan)

Medicine Details

Condition Insights

Search History

Settings & Legal

🔐 Safety Guidelines
❌ What the app does NOT do:

Provide diagnoses

Prescribe medicines

Suggest exact dosages

✅ What it DOES:

Provide educational content

Maintain neutral explanations

Encourage consulting professionals

Clear disclaimers are shown throughout the app.

🧪 Testing & Deployment
Run tests
flutter test
Build for release
flutter build apk     # Android
flutter build ipa     # iOS
🧠 AI Integration

The app uses structured prompts to ensure:

Consistent JSON output

Clear categorization

Safe and understandable explanations

Example Queries:
Analyze this medicine: Paracetamol
What should I eat if I have this condition: Fever
👨‍💻 Developer

Prathmesh Pimpare

Flutter Developer focused on:

Clean Architecture

Real-world problem solving

Building safe and user-centric applications

📄 License

This project is licensed under the MIT License.

⚠️ Medical Disclaimer

This application is for informational purposes only.
It does not replace professional medical advice, diagnosis, or treatment.

Always consult a qualified healthcare provider before making any health-related decisions.
