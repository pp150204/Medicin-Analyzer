🧬 Medicine Insight App

A fully functional Flutter mobile application created to help users better understand medicines and health conditions in a simple, organized, and responsible manner.

The app prioritizes clarity, safety, and reliability, combining a modern user interface with AI-driven insights to make medical information more accessible — while never replacing professional healthcare advice.

✨ Purpose of the App

Medical information can often feel overwhelming or unclear.
Medicine Insight was developed to:

Present medicine details in a simple and structured format

Minimize confusion and misinformation

Promote safe and responsible usage

Deliver a calm and trustworthy user experience

⚠️ This application is intended for educational use only and is not a substitute for medical professionals.

🎯 Key Features

🔍 Flexible Input Options

Search medicines by name

Scan medicines using the device camera

Upload images from the gallery

Extract text via OCR with manual editing support

🧠 AI-Driven Analysis

Powered by Groq AI

Uses well-crafted prompts for accurate results

Generates structured JSON responses for consistent UI

Ensures neutral and non-prescriptive medical explanations

💊 Detailed Medicine Breakdown

Each medicine is explained in clear sections:

Purpose of the medicine

Recommended timing (before/after meals)

Usage method (tablet, syrup, etc.)

General dosage information (non-prescriptive)

Possible side effects (common and serious)

Precautions and who should avoid it

Alternative medicine options

Food and lifestyle suggestions

Missed dose instructions

Storage recommendations

All details are displayed using clean, glass-style cards for better readability.

🩺 Health Condition Support

Users can also enter a health condition and receive:

Suggested foods

Foods to avoid

Healthy daily habits

Advice on when to consult a doctor

🎨 Design Approach

Glassmorphism-inspired interface

Smooth gradients (blue, teal, purple tones)

Full Dark Mode support

Fluid animations and loading effects

Clean typography and calming visuals

The goal is to create a professional, user-friendly, and trustworthy experience.

🧱 Project Structure

Built using Clean Architecture for scalability and maintainability:

lib/
├── core/              # Constants, themes, utilities
├── data/              # APIs, models, repositories
├── domain/            # Business logic & interfaces
└── presentation/      # UI, state management, widgets

📦 State Management

Riverpod for efficient state handling

FutureProvider for async operations

StateProvider for local UI state

🛠️ Technology Stack

Flutter (3.9.2+)

Riverpod

Dio (API handling)

Groq AI

Google ML Kit (OCR)

SharedPreferences

flutter_dotenv

🚀 Setup Guide

Requirements

Flutter SDK (≥ 3.9.2)

Dart SDK

Groq API key

Installation Steps

1️⃣ Clone the project

git clone https://github.com/akshaypatra00/medicine-analyzer-flutter.git
cd medicine-analyzer-flutter

2️⃣ Install dependencies

flutter pub get

3️⃣ Generate required files

flutter pub run build_runner build

4️⃣ Configure environment variables
Create a .env file:

GROQ_API_KEY=your_api_key_here

5️⃣ Run the application

flutter run

📱 App Screens

Splash Screen

Home (Search & Scan)

Medicine Details

Condition Insights

Search History

Settings & Legal

🔐 Safety Guidelines

What the app does NOT do:

❌ Provide diagnoses

❌ Prescribe medicines

❌ Suggest exact dosages

What it DOES:

✅ Provide educational content

✅ Maintain neutral explanations

✅ Encourage professional consultation

Clear disclaimers are shown across the app.

🧪 Testing & Deployment

Run tests:

flutter test

Build for release:

flutter build apk     # Android
flutter build ipa     # iOS

🧠 AI Integration (Groq)

The app uses structured prompts to ensure:

Consistent JSON output

Neutral tone

Clear categorization

Safe and understandable explanations

Example queries:

Analyze this medicine: Paracetamol

What should I eat if I have this condition: Fever

👨‍💻 Developer

Developed by:
Prathmesh Pimpare

Flutter Developer focused on:

Clean Architecture

Real-world problem solving

Building safe and user-centric applications

📄 License

Licensed under the MIT License.

⚠️ Medical Disclaimer

This application is for informational purposes only.
It does not replace professional medical advice, diagnosis, or treatment.
Always consult a qualified healthcare provider before making any health-related decisions.