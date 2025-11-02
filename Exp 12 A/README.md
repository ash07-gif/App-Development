Flutter Firebase Auth App (Minimal UI)
======================================

What's included:
- Email / Password signup & login
- Google Sign-In
- Phone Authentication (OTP)
- Minimal single-screen login UI with buttons for Google & Phone
- Simple signup screen & home screen
- Auth helper service

Important steps BEFORE running:
1. Install Flutter & the FlutterFire CLI: https://firebase.flutter.dev/docs/cli
2. Run `flutterfire configure` in the project root to generate `lib/firebase_options.dart`
   and to link the app to your Firebase project.
3. Enable Email/Password, Google and Phone sign-in methods in Firebase Console -> Authentication.
4. Add Android/iOS app configs as required (google-services.json / GoogleService-Info.plist).
5. Run `flutter pub get` and then `flutter run`.

Files to check:
- lib/main.dart
- lib/login_screen.dart
- lib/signup_screen.dart
- lib/home_screen.dart
- lib/auth_service.dart

Note on Phone Auth:
- On Android, make sure SHA-256 is configured in Firebase and google-services.json is added.
- For development, you can add test phone numbers in Firebase Console to avoid real SMS charges.
