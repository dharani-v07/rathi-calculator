# 🧮 Rathi Calculator

A professional, production-ready, feature-rich **Simple & Advanced (Scientific) Calculator** application built with Flutter. Designed with a custom **Royal Burgundy & Metallic Gold** theme inspired by traditional elegance and modern minimalism, Rathi Calculator offers a seamless, offline, and ad-free calculation experience.

---

## ✨ Key Features

### 🔢 Dual Calculator Modes
- **Simple Mode**: Clean arithmetic (`+`, `-`, `×`, `÷`), percentages (`%`), smart parentheses (`()`), backspace (`⌫`), and All Clear (`AC`).
- **Advanced (Scientific) Mode**:
  - **Trigonometry**: `sin`, `cos`, `tan`, `asin`, `acos`, `atan` (with **DEG / RAD** angle mode toggle).
  - **Logarithms & Exponents**: `log`, `ln`, `x^y`, `x²`, `√`, `∛`.
  - **Constants & Utilities**: `π`, `e`, `!`, factorial, absolute value (`abs`).
  - **Memory Operations**: `MC`, `MR`, `M+`, `M-` with persistent local storage.

### 📜 Offline Calculation History (No Login Required)
- Automatically saves calculation history locally using `shared_preferences`.
- **Compact View**: Displays expressions cleanly truncated to 2 lines with results.
- **Interactive Recall**: Tap any history item to paste its expression directly back into the calculator.
- **Granular Deletion**: Clear all history at once or delete individual history items one by one.

### 🎨 Elegant Theme Engine
- **Brand Palette**: Styled in rich Royal Burgundy (`#58000F`) and Luxurious Metallic Gold (`#D4AF37`).
- **3-Way Theme Switcher**: Choose between **System Default**, **Light Theme**, and **Dark Theme** with preference persistence.

### ⚡ Professional User Experience
- **Interactive Cursor Editing**: Tap anywhere in the expression display to place the cursor and edit at that exact position (with system software keyboard disabled for clean keypad entry).
- **Upward Multi-Line Flow**: Expression display automatically wraps and flows upwards as length grows.
- **Tap-to-Copy**: Long-press expression or result to copy to clipboard with custom floating dark notification.
- **Responsive Layout**: Optimized for both Portrait and Landscape orientations with no layout overflows.

---

## 📱 Screenshots

| Simple Mode | Advanced (Scientific) Mode | History Drawer |
| :---: | :---: | :---: |
| *Clean arithmetic layout* | *Scientific & memory keys* | *Saved history with delete* |

---

## 🛠️ Tech Stack & Dependencies

- **Framework**: [Flutter](https://flutter.dev) (Dart 3.x)
- **Math Engine**: [`math_expressions`](https://pub.dev/packages/math_expressions) for robust expression parsing and real-time evaluation.
- **State Management**: [`provider`](https://pub.dev/packages/provider) for clean reactive architecture.
- **Local Storage**: [`shared_preferences`](https://pub.dev/packages/shared_preferences) for offline history and theme persistence.
- **Formatting**: [`intl`](https://pub.dev/packages/intl) for timestamp formatting.

---

## 🚀 Getting Started & Installation

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) installed on your machine.
- Android Studio / VS Code with Flutter & Dart plugins.

### Clone & Run
```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/rathi-calculator.git

# Navigate to project directory
cd rathi-calculator/calculator

# Install dependencies
flutter pub get

# Run the app on connected device or emulator
flutter run
```

### Build Release APK
```bash
flutter build apk --release
```
The release APK will be generated at `build/app/outputs/flutter-apk/app-release.apk`.

---

## 📄 License

This project is open-source and available under the [MIT License](LICENSE).
