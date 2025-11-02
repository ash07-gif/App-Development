# ToDoFirebase (Expo + Firebase Firestore)

This is a minimal React Native (Expo) To-Do list app connected to Firebase Firestore.

## Setup

1. Install dependencies:
   ```
   npm install
   ```

2. Create a Firebase project in the Firebase console and enable Firestore (in test mode for development).

3. Replace the config object in `firebaseConfig.js` with your Firebase project's config (apiKey, authDomain, projectId, ...).

4. Run the app:
   ```
   npm start
   ```
   Use Expo Go (mobile) or run on Android/iOS simulators.

## Notes

- This project uses the modular Firebase Web SDK (`firebase` package).
- Replace `firebaseConfig.js` with your project's credentials.
- For production Firestore rules, secure your database appropriately.
