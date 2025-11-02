// Replace the config below with your Firebase project config from the Firebase console.
// For web apps (Expo), copy the Firebase SDK config object (apiKey, authDomain, projectId, ...)
import { initializeApp } from "firebase/app";
import { getFirestore } from "firebase/firestore";

const firebaseConfig = {
  apiKey: "YOUR_API_KEY",
  authDomain: "YOUR_AUTH_DOMAIN",
  projectId: "YOUR_PROJECT_ID",
  // storageBucket, messagingSenderId, appId optional
};

const app = initializeApp(firebaseConfig);
export const db = getFirestore(app);
