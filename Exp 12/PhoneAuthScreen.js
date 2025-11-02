import React, {useState} from 'react';
import { View, TextInput, Button, Text, StyleSheet } from 'react-native';
import auth from '@react-native-firebase/auth';

export default function PhoneAuthScreen() {
  const [phone, setPhone] = useState('');
  const [code, setCode] = useState('');
  const [confirm, setConfirm] = useState(null);

  const sendCode = async () => {
    try {
      const confirmation = await auth().signInWithPhoneNumber(phone);
      setConfirm(confirmation);
      alert('Code sent');
    } catch (e) {
      alert(e.message);
    }
  };

  const confirmCode = async () => {
    try {
      await confirm.confirm(code);
    } catch (e) {
      alert('Invalid code');
    }
  };

  return (
    <View style={styles.container}>
      {!confirm ? (
        <>
          <TextInput style={styles.input} placeholder="+91 9876543210" value={phone} onChangeText={setPhone} />
          <Button title="Send Code" onPress={sendCode} />
        </>
      ) : (
        <>
          <TextInput style={styles.input} placeholder="123456" value={code} onChangeText={setCode} keyboardType="number-pad" />
          <Button title="Confirm Code" onPress={confirmCode} />
        </>
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  container:{flex:1, padding:20, justifyContent:'center'},
  input:{borderWidth:1, borderColor:'#ddd', padding:12, borderRadius:8, marginBottom:10},
});
