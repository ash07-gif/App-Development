AuthAppKotlin - Android (Kotlin) Firebase Auth example

What is included:
- Email/password signup & login
- Phone auth (verification code)
- Placeholder for Google Sign-In (button present, requires SHA-1 + OAuth config)

Steps to run:
1. Open this folder in Android Studio.
2. Add Firebase Android app in Firebase Console with package name: com.example.authappkotlin
3. Add SHA-1 (debug) in Firebase project settings.
4. Download google-services.json and replace app/src/main/google-services.json
5. Build & Run on device or emulator.

Notes:
- Google Sign-In requires SHA-1 and OAuth client; implement full GoogleSignIn flow in LoginActivity if needed.
- For phone auth during development, add test phone numbers in Firebase Console Authentication -> Phone -> Phone numbers for testing to avoid SMS limits.
