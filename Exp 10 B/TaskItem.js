import React from 'react';
import { View, Text, StyleSheet, TouchableOpacity } from 'react-native';

export default function TaskItem({ task, onToggle, onDelete }) {
  return (
    <View style={[styles.container, task.done ? styles.done : null]}>
      <View style={{flex:1}}>
        <Text style={[styles.title, task.done ? styles.titleDone : null]}>{task.title}</Text>
        {task.description ? <Text style={styles.desc}>{task.description}</Text> : null}
      </View>
      <View style={styles.actions}>
        <TouchableOpacity onPress={onToggle} style={styles.actionBtn}>
          <Text>{task.done ? 'Undo' : 'Done'}</Text>
        </TouchableOpacity>
        <TouchableOpacity onPress={onDelete} style={styles.actionBtn}>
          <Text style={{color:'red'}}>Delete</Text>
        </TouchableOpacity>
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flexDirection:'row', padding:12, borderRadius:8, borderWidth:1, borderColor:'#eee', marginBottom:8, alignItems:'center' },
  done: { backgroundColor:'#f0f6ff' },
  title: { fontSize:16, fontWeight:'600' },
  titleDone: { textDecorationLine:'line-through', color:'#666' },
  desc: { color:'#444', marginTop:4 },
  actions: { marginLeft:12, alignItems:'flex-end' },
  actionBtn: { padding:6 }
});
