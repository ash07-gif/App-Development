import React from 'react';
import { View, Text, TouchableOpacity, StyleSheet } from 'react-native';

export default function TaskItem({item, onToggle, onDelete}) {
  return (
    <View style={styles.row}>
      <TouchableOpacity onPress={onToggle} style={[styles.checkbox, item.done ? styles.checked : null]}>
        <Text>{item.done ? '✓' : ''}</Text>
      </TouchableOpacity>
      <View style={{flex:1}}>
        <Text style={[styles.title, item.done ? {textDecorationLine:'line-through', color:'#666'} : null]}>
          {item.title}
        </Text>
        <Text style={styles.sub}>{item.created_at}</Text>
      </View>
      <TouchableOpacity onPress={onDelete} style={styles.del}>
        <Text style={{color:'#ef4444'}}>Delete</Text>
      </TouchableOpacity>
    </View>
  );
}

const styles = StyleSheet.create({
  row:{flexDirection:'row', alignItems:'center', backgroundColor:'#fff', padding:12, marginBottom:8, borderRadius:8},
  checkbox:{width:28, height:28, borderWidth:1, borderRadius:6, alignItems:'center', justifyContent:'center', marginRight:12},
  checked:{backgroundColor:'#bbdefb'},
  title:{fontSize:16},
  sub:{fontSize:12, color:'#999'},
  del:{paddingHorizontal:8}
});