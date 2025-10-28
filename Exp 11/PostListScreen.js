import React, { useEffect } from 'react';
import {
  View, Text, FlatList, ActivityIndicator, StyleSheet, TouchableOpacity, RefreshControl
} from 'react-native';
import { fetchPosts } from '../api/posts';
import { useFetch } from '../hooks/useFetch';
import PostItem from '../components/PostItem';

export default function PostListScreen() {
  const { execute, data, status, error, clearCache } = useFetch();

  useEffect(() => {
    execute(fetchPosts).catch(() => {});
  }, [execute]);

  const onRetry = async () => {
    try {
      await execute(fetchPosts, { force: true });
    } catch (_) {}
  };

  const onRefresh = async () => {
    try {
      await execute(fetchPosts, { force: true });
    } catch (_) {}
  };

  if (status === 'loading' && !data) {
    return (
      <View style={styles.center}>
        <ActivityIndicator size="large" />
        <Text style={styles.hint}>Loading posts...</Text>
      </View>
    );
  }

  if (status === 'error' && !data) {
    return (
      <View style={styles.center}>
        <Text style={styles.error}>Something went wrong.</Text>
        <Text style={styles.hint}>{error}</Text>
        <TouchableOpacity onPress={onRetry} style={styles.button}>
          <Text style={styles.buttonText}>Retry</Text>
        </TouchableOpacity>
      </View>
    );
  }

  const posts = data ?? [];

  if (status === 'success' && posts.length === 0) {
    return (
      <View style={styles.center}>
        <Text style={styles.hint}>No posts found.</Text>
        <TouchableOpacity onPress={() => execute(fetchPosts, { force: true })} style={styles.button}>
          <Text style={styles.buttonText}>Reload</Text>
        </TouchableOpacity>
      </View>
    );
  }

  return (
    <View style={{ flex: 1 }}>
      <FlatList
        data={posts}
        keyExtractor={(item) => item.id.toString()}
        renderItem={({ item }) => <PostItem post={item} />}
        contentContainerStyle={posts.length === 0 ? styles.center : undefined}
        refreshControl={<RefreshControl refreshing={status === 'loading'} onRefresh={onRefresh} />}
        ListHeaderComponent={
          <View style={styles.header}>
            <Text style={styles.headerText}>Public Posts</Text>
            <TouchableOpacity onPress={clearCache}>
              <Text style={styles.clear}>Clear Cache</Text>
            </TouchableOpacity>
          </View>
        }
      />
      {status === 'loading' && data && (
        <View style={styles.loadingOverlay}>
          <ActivityIndicator />
        </View>
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  center: { flex: 1, alignItems: 'center', justifyContent: 'center', padding: 16 },
  error: { color: '#b00020', fontWeight: '700', marginBottom: 8 },
  hint: { color: '#444', marginTop: 12, textAlign: 'center' },
  button: {
    marginTop: 14,
    backgroundColor: '#1976D2',
    paddingHorizontal: 16,
    paddingVertical: 10,
    borderRadius: 8
  },
  buttonText: { color: 'white', fontWeight: '700' },
  header: { padding: 12, flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center' },
  headerText: { fontSize: 20, fontWeight: '800' },
  clear: { color: '#1976D2' },
  loadingOverlay: {
    position: 'absolute',
    bottom: 12,
    left: 12,
    right: 12,
    alignItems: 'center'
  }
});
