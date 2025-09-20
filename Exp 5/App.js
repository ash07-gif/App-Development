
import React, { useState } from 'react';
import { View, Text, TextInput, Button, FlatList } from 'react-native';

export default function App() {
  const [task, setTask] = useState('');
  const [tasks, setTasks] = useState([]);

  const addTask = () => {
    setTasks([...tasks, { key: Math.random().toString(), value: task }]);
    setTask('');
  };

  const deleteTask = (key) => {
    setTasks(tasks.filter(item => item.key !== key));
  };

  return (
    <View style={{ padding: 40 }}>
      <TextInput
        placeholder="Enter task"
        value={task}
        onChangeText={setTask}
        style={{ borderBottomWidth: 1, marginBottom: 10 }}
      />
      <Button title="Add Task" onPress={addTask} />
      <FlatList
        data={tasks}
        renderItem={({ item }) => (
          <View style={{ flexDirection: 'row', justifyContent: 'space-between', margin: 5 }}>
            <Text>{item.value}</Text>
            <Button title="Delete" onPress={() => deleteTask(item.key)} />
          </View>
        )}
      />
    </View>
  );
}
