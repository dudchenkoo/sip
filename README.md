# MMDSmart: Call Center Connect

<div align="center">
  <img src="assets/images/logo.png" alt="Call Center Connect Logo" width="120" />
  
  **Zero-Hardware Virtual Call Center**
  
  [![Flutter](https://img.shields.io/badge/Flutter-3.38.5-02569B?logo=flutter)](https://flutter.dev)
  [![Dart](https://img.shields.io/badge/Dart-3.10.4-0175C2?logo=dart)](https://dart.dev)
  [![License](https://img.shields.io/badge/License-Proprietary-red)](LICENSE)
</div>

---

## Overview

Call Center Connect is a cloud-based, zero-hardware virtual call center mobile application. It allows businesses to run professional call centers using WebRTC technology, unchaining agents and supervisors from their desks.

### Primary User Personas

- **Agent**: High-reliability VoIP dialer, real-time CRM access, call history & balance management
- **Supervisor**: "Control tower" view with live call monitoring, AI sentiment alerts, and coaching actions (whisper/barge)

## Features

### 🎧 Omnichannel VoIP
Voice calling over internet (VoIP) with background call persistence

### 📱 Smart SMS Callback
Trigger outbound calls via SMS links sent to leads

### 🧠 AI Sentiment Intelligence
Real-time visual indicators of call "emotional health" based on live transcription
- 🟢 **Positive** - Conversation going well
- 🟡 **Neutral** - Standard interaction
- 🔴 **Needs Attention** - Supervisor action may be required

### 💳 Wallet & Billing
Integrated call credit management and top-up functionality

### 👀 Supervisor Actions
- **Listen** - Monitor calls silently
- **Whisper** - Coach agent without customer hearing
- **Barge** - Join conversation directly

## Tech Stack

| Component | Technology |
|-----------|------------|
| Framework | Flutter 3.38.5 |
| State Management | Riverpod |
| Navigation | Go Router |
| VoIP/WebRTC | flutter_webrtc, sip_ua |
| API | Dio + Retrofit |
| Push Notifications | Firebase Messaging |
| Local Storage | Hive, Shared Preferences |

## Project Structure

```
lib/
├── core/
│   ├── constants/      # Colors, spacing, strings
│   ├── theme/          # App theming
│   ├── router/         # Navigation
│   ├── widgets/        # Shared widgets
│   ├── services/       # Core services
│   └── utils/          # Utilities
├── features/
│   ├── auth/           # Authentication
│   ├── dialer/         # VoIP dialer
│   ├── calls/          # Call history
│   ├── supervisor/     # Live monitoring
│   ├── wallet/         # Billing & credits
│   └── settings/       # App settings
└── shared/
    ├── models/         # Shared data models
    └── widgets/        # Shared UI components
```

## Getting Started

### Prerequisites

- Flutter SDK 3.38.5+ (included in `./flutter/`)
- Xcode 14+ (for iOS development)
- Android Studio (optional, for Android)
- CocoaPods (for iOS plugins)

### Setup

1. **Add Flutter to PATH**
   ```bash
   export PATH="$PATH:$(pwd)/flutter/bin"
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Install CocoaPods (iOS)**
   ```bash
   sudo gem install cocoapods
   cd ios && pod install && cd ..
   ```

4. **Run code generation** (for Riverpod, Freezed, etc.)
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

### Running the App

```bash
# iOS Simulator
flutter run -d ios

# Android Emulator
flutter run -d android

# Chrome (for web testing)
flutter run -d chrome

# List available devices
flutter devices
```

## Design Language

| Element | Value |
|---------|-------|
| Primary Color | `#FF6B35` (Orange) |
| Text Primary | `#2D3436` (Dark Gray) |
| Background | `#F8F9FA` (Light Gray) |
| Surface | `#FFFFFF` (White) |
| Font Family | Outfit |

### Sentiment Colors
- Positive: `#00C853` (Green)
- Neutral: `#FFB300` (Yellow)
- Negative: `#FF3D00` (Red)

## Development

### Hot Reload
Press `r` in the terminal while the app is running

### Hot Restart
Press `R` in the terminal

### Analyze Code
```bash
flutter analyze lib/
```

### Run Tests
```bash
flutter test
```

## Backend Integration

The app expects a REST API backend with:
- WebRTC signaling server
- SIP-based call routing
- Push notification service (FCM)
- Real-time sentiment analysis API

## License

Proprietary - MMDSmart © 2024

---

<div align="center">
  Built with ❤️ by MMDSmart
</div>
