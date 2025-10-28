import React from 'react';
import { SafeAreaView, StatusBar } from 'react-native';
import PostListScreen from './src/screens/PostListScreen';

export default function App() {
  return (
    <SafeAreaView style={{ flex: 1 }}>
      <StatusBar barStyle="dark-content" />
      <PostListScreen />
    </SafeAreaView>
  );
}
