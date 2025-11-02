import React, {useEffect, useState} from 'react';
import { SafeAreaView, View, Text, TextInput, TouchableOpacity, FlatList, StyleSheet, Alert } from 'react-native';
import DB from './db';
import TaskItem from './components/TaskItem';

export default function App() {
  const [tasks, setTasks] = useState([]);
  const [text, setText] = useState('');

  useEffect(() => {
    DB.init();
    refresh();
    return () => {
      DB.close();
    }
  }, []);

  const refresh = () => {
    DB.getAllTasks().then(setTasks).catch(err => console.log(err));
  };

  const addTask = async () => {
    const t = text.trim();
    if (!t) return;
    await DB.addTask(t);
    setText('');
    refresh();
  };

  const toggleDone = async (id, done) => {
    await DB.updateTaskDone(id, done ? 0 : 1);
    refresh();
  };

  const deleteTask = async (id) => {
    await DB.deleteTask(id);
    refresh();
  };

  const clearCompleted = async () => {
    await DB.clearCompleted();
    refresh();
  };

  return (
    <SafeAreaView style={styles.container}>
      <Text style={styles.title}>To‑Do (SQLite)</Text>
      <View style={styles.inputRow}>
        <TextInput
          placeholder="New task..."
          value={text}
          onChangeText={setText}
          style={styles.input}
          onSubmitEditing={addTask}
          returnKeyType="done"
        />
        <TouchableOpacity style={styles.addBtn} onPress={addTask}>
          <Text style={{color:'#fff'}}>Add</Text>
        </TouchableOpacity>
      </View>

      <FlatList
        data={tasks}
        keyExtractor={item => String(item.id)}
        renderItem={({item}) => (
          <TaskItem
            item={item}
            onToggle={() => toggleDone(item.id, item.done)}
            onDelete={() => deleteTask(item.id)}
          />
        )}
        ListEmptyComponent={<Text style={{textAlign:'center', marginTop:20}}>No tasks yet</Text>}
        contentContainerStyle={{paddingBottom:100}}
      />

      <TouchableOpacity style={styles.clearBtn} onPress={()=>{
        Alert.alert('Clear completed', 'Delete all completed tasks?', [
          {text:'Cancel', style:'cancel'},
          {text:'OK', onPress: clearCompleted}
        ])
      }}>
        <Text style={{color:'#fff'}}>Clear Completed</Text>
      </TouchableOpacity>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container:{flex:1, padding:16, backgroundColor:'#f6f7fb'},
  title:{fontSize:24, fontWeight:'700', marginBottom:12},
  inputRow:{flexDirection:'row', marginBottom:12},
  input:{flex:1, backgroundColor:'#fff', padding:12, borderRadius:8, elevation:1},
  addBtn:{marginLeft:8, paddingHorizontal:16, backgroundColor:'#3b82f6', borderRadius:8, justifyContent:'center'},
  clearBtn:{position:'absolute', right:16, bottom:24, backgroundColor:'#ef4444', padding:12, borderRadius:24}
});