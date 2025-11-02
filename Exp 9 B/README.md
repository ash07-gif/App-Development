# React Native To-Do List (SQLite)

This is a minimal React Native (CLI) To-Do List app using `react-native-sqlite-storage` for local storage.

## Quick setup (React Native CLI)

1. Clone or unzip project.
2. Install dependencies:
   ```
   npm install
   ```
3. Install native dependency (linking / autolinking):
   ```
   npx pod-install ios   # on mac for iOS
   ```
4. Run Metro and the app:
   ```
   npx react-native run-android
   npx react-native run-ios
   ```

## Notes
- This project uses `react-native-sqlite-storage`. Follow its installation instructions for Android/iOS native setup:
  https://github.com/andpor/react-native-sqlite-storage
- For Expo managed workflow, consider `expo-sqlite` instead.