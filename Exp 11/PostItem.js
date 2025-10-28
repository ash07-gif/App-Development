import React from 'react';
import { View, Text, StyleSheet } from 'react-native';

export default function PostItem({ post }) {
  return (
    <View style={styles.container}>
      <Text style={styles.title}>{post.title}</Text>
      <Text style={styles.body} numberOfLines={3}>{post.body}</Text>
      <Text style={styles.meta}>Post ID: {post.id} • User: {post.userId}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    backgroundColor: '#ffffff',
    padding: 12,
    marginVertical: 6,
    marginHorizontal: 12,
    borderRadius: 10,
    elevation: 1
  },
  title: { fontWeight: '700', marginBottom: 6 },
  body: { color: '#333', marginBottom: 8 },
  meta: { fontSize: 12, color: '#666' }
});
