import React, { useState } from 'react';
import { View, TextInput, TouchableOpacity, Text, StyleSheet } from 'react-native';

export default function AddTask({ onAdd }) {
  const [title, setTitle] = useState('');
  const [description, setDescription] = useState('');

  const submit = () => {
    if (!title.trim()) return;
    onAdd(title, description);
    setTitle('');
    setDescription('');
  };

  return (
    <View style={styles.wrap}>
      <TextInput
        placeholder="Task title"
        value={title}
        onChangeText={setTitle}
        style={styles.input}
      />
      <TextInput
        placeholder="Optional description"
        value={description}
        onChangeText={setDescription}
        style={[styles.input, { marginTop:8 }]}
      />
      <TouchableOpacity style={styles.btn} onPress={submit}>
        <Text style={styles.btnText}>Add Task</Text>
      </TouchableOpacity>
    </View>
  );
}

const styles = StyleSheet.create({
  wrap: { marginBottom:12 },
  input: { borderWidth:1, borderColor:'#ddd', padding:10, borderRadius:8 },
  btn: { marginTop:8, backgroundColor:'#1f6feb', padding:10, borderRadius:8, alignItems:'center' },
  btnText: { color:'#fff', fontWeight:'600' }
});
