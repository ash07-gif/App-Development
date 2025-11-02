# Calculator Firestore (Preconfigured)

This archive contains the Dart source and `pubspec.yaml` for a **Flutter calculator app** that saves calculation history to **Firebase Firestore**.

## What is included
- `lib/main.dart` — full Flutter UI + Firestore integration
- `pubspec.yaml` — dependencies

## What you must do after extracting
1. Install Flutter (if not installed). See https://flutter.dev/docs/get-started/install
2. Open a terminal in the extracted folder and run:
   ```bash
   flutter create .
   ```
   This will generate the `android/`, `ios/` and other native platform folders required for a runnable app.

3. Add the Firebase Android app (in Firebase Console):
   - Register an Android app with package name `com.example.calculator_firestore`
     (You can change it later — if you do, update `applicationId` in `android/app/build.gradle`).
   - Download `google-services.json` and place it in `android/app/`.

4. Edit native Android Gradle files (two quick edits):
   - In `android/build.gradle` (project-level), ensure the Google services classpath is present:
     ```gradle
     buildscript {
         dependencies {
             // ...
             classpath 'com.google.gms:google-services:4.3.15'
         }
     }
     ```
   - In `android/app/build.gradle` (module-level), add at the bottom:
     ```gradle
     apply plugin: 'com.google.gms.google-services'
     ```
   - Ensure `minSdkVersion` in `android/app/build.gradle` is at least 21.

5. (Optional, recommended) Initialize FlutterFire for platform-specific options:
   - Install FlutterFire CLI: `dart pub global activate flutterfire_cli`
   - Run: `flutterfire configure` and follow prompts (this will generate `lib/firebase_options.dart`).
   - If you don't run it, `Firebase.initializeApp()` will still work when `google-services.json` is present.

6. Fetch packages and run:
   ```bash
   flutter pub get
   flutter run
   ```

## Notes & Security
- This project writes to a `calculations` collection in Firestore. For development, you can enable test mode; **do not** leave test mode for production.
- For per-user history, add `firebase_auth` and save `uid` with each document; query the collection with `where('uid', isEqualTo: currentUser.uid)`.

If you want, I can:
- Generate a full Flutter project ZIP (including `android/` files) instead of this preconfigured skeleton — say "full zip" and I'll produce it.
- Add firebase_auth (email/google) prewired so each user has private history.
