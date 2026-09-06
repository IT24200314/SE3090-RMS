# ADR-002: Flutter State Management & Native Hardware Device Integration

## Status
**Accepted**

## Context
The RMS Flutter Mobile Client targets prospective tenants and on-field maintenance contractors on Android and iOS. The app must interface directly with hardware sensors (Camera for KYC NIC/Passport capture, damage photo capture, and GPS Location Geotagging for contractor dispatch validation) while retaining a high-performance Material 3 dark-themed UX.

## Decision
We adopted **Flutter Material 3 with Stateful Widget Architecture, Flutter Secure Storage for JWT token persistence, Image Picker for Camera/Gallery capture, and Geolocator for native GPS coordinates**:
1. **Device Feature 1 (Component B - Nethmi)**: Camera & File Picker integration for document uploads (`TenantOnboardingScreen.dart`).
2. **Device Feature 2 (Component C - Hashini)**: Geolocation (`Geolocator.getCurrentPosition`) for live GPS tagging during maintenance issue reporting (`ReportIssueScreen.dart`).
3. **State Management**: Built-in `StatefulWidget` with structured controllers and asynchronous API service wrappers (`RMSApiService`).

## Consequences
### Positive:
- **Zero Bloat**: Native Dart lifecycle without third-party reactive framework lock-in.
- **Hardware Integration**: Full permission handling for Android/iOS Camera and GPS Geolocation.
- **Static Analysis Compliance**: `flutter analyze` passes with 0 warnings/errors.

### Negative / Trade-offs:
- Complex nested state across multiple screens requires explicit parameter passing or service injection.
