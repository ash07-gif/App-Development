import React, { useEffect, useState } from 'react';
import { SafeAreaView, View, Text, FlatList, StyleSheet, TextInput, TouchableOpacity, KeyboardAvoidingView, Platform } from 'react-native';
import { db } from './firebaseConfig';
import { collection, addDoc, onSnapshot, query, orderBy, doc, updateDoc, deleteDoc } from 'firebase/firestore';
import { StatusBar } from 'expo-status-bar';
import TaskItem from './components/TaskItem';
import AddTask from './components/AddTask';

export default function App() {
  const [tasks, setTasks] = useState([]);

  useEffect(() => {
    const q = query(collection(db, 'tasks'), orderBy('createdAt', 'desc'));
    const unsubscribe = onSnapshot(q, (querySnapshot) => {
      const items = [];
      querySnapshot.forEach((doc) => {
        items.push({ id: doc.id, ...doc.data() });
      });
      setTasks(items);
    }, (error) => {
      console.error("Firestore onSnapshot error:", error);
    });

    return () => unsubscribe();
  }, []);

  const addTask = async (title, description) => {
    if (!title || title.trim() === '') return;
    try {
      await addDoc(collection(db, 'tasks'), {
        title: title.trim(),
        description: description ? description.trim() : '',
        done: false,
        createdAt: new Date()
      });
    } catch (e) {
      console.error("Error adding document: ", e);
    }
  };

  const toggleDone = async (id, current) => {
    const ref = doc(db, 'tasks', id);
    await updateDoc(ref, { done: !current });
  };

  const removeTask = async (id) => {
    const ref = doc(db, 'tasks', id);
    await deleteDoc(ref);
  };

  return (
    <SafeAreaView style={styles.container}>
      <StatusBar style="auto" />
      <Text style={styles.heading}>Firestore To-Do</Text>
      <AddTask onAdd={addTask} />
      <KeyboardAvoidingView behavior={Platform.OS === 'ios' ? 'padding' : 'height'} style={{flex:1}}>
        <FlatList
          data={tasks}
          keyExtractor={(item) => item.id}
          renderItem={({item}) => (
            <TaskItem
              task={item}
              onToggle={() => toggleDone(item.id, item.done)}
              onDelete={() => removeTask(item.id)}
            />
          )}
          ListEmptyComponent={() => <Text style={styles.empty}>No tasks yet</Text>}
          contentContainerStyle={{ paddingBottom: 40 }}
        />
      </KeyboardAvoidingView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: { flex:1, padding:16, backgroundColor:'#fff' },
  heading: { fontSize:24, fontWeight:'700', marginBottom:12, textAlign:'center' },
  empty: { textAlign:'center', color:'#666', marginTop:20 }
});
