import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:math_expressions/math_expressions.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator Firestore',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const CalculatorHome(),
    );
  }
}

class CalculatorHome extends StatefulWidget {
  const CalculatorHome({super.key});
  @override
  State<CalculatorHome> createState() => _CalculatorHomeState();
}

class _CalculatorHomeState extends State<CalculatorHome> {
  String _expression = '';
  String _result = '';

  final CollectionReference calculations =
      FirebaseFirestore.instance.collection('calculations');

  void _numClick(String text) {
    setState(() {
      _expression += text;
    });
  }

  void _allClear() {
    setState(() {
      _expression = '';
      _result = '';
    });
  }

  void _delete() {
    setState(() {
      if (_expression.isNotEmpty) {
        _expression = _expression.substring(0, _expression.length - 1);
      }
    });
  }

  void _evaluate() {
    try {
      String parsed = _expression.replaceAll('×', '*').replaceAll('÷', '/').replaceAll('%', '/100');
      Parser p = Parser();
      Expression exp = p.parse(parsed);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      _result = eval.toString();
      calculations.add({
        'expression': _expression,
        'result': _result,
        'timestamp': FieldValue.serverTimestamp(),
      });
      setState(() {
        _expression = _result;
      });
    } catch (e) {
      setState(() {
        _result = 'Error';
      });
    }
  }

  Widget _buildButton(String txt,
      {Color? textColor, Color? bgColor, double textSize = 24}) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(6),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(18),
            backgroundColor: bgColor,
          ),
          onPressed: () {
            if (txt == 'C') {
              _allClear();
            } else if (txt == 'DEL') {
              _delete();
            } else if (txt == '=') {
              _evaluate();
            } else {
              _numClick(txt);
            }
          },
          child: Text(
            txt,
            style: TextStyle(fontSize: textSize, color: textColor),
          ),
        ),
      ),
    );
  }

  Widget _buttonsGrid() {
    return Column(
      children: [
        Row(children: [
          _buildButton('C', bgColor: Colors.grey[300], textColor: Colors.black),
          _buildButton('DEL', bgColor: Colors.grey[300], textColor: Colors.black),
          _buildButton('÷', bgColor: Colors.orange[700], textColor: Colors.white),
          _buildButton('×', bgColor: Colors.orange[700], textColor: Colors.white),
        ]),
        Row(children: [
          _buildButton('7'),
          _buildButton('8'),
          _buildButton('9'),
          _buildButton('-', bgColor: Colors.orange[700], textColor: Colors.white),
        ]),
        Row(children: [
          _buildButton('4'),
          _buildButton('5'),
          _buildButton('6'),
          _buildButton('+', bgColor: Colors.orange[700], textColor: Colors.white),
        ]),
        Row(children: [
          _buildButton('1'),
          _buildButton('2'),
          _buildButton('3'),
          _buildButton('=', bgColor: Colors.blue[700], textColor: Colors.white),
        ]),
        Row(children: [
          _buildButton('0', textSize: 20),
          _buildButton('.'),
          _buildButton('%', bgColor: Colors.orange[700], textColor: Colors.white),
          _buildButton('(', bgColor: Colors.grey[300], textColor: Colors.black),
        ]),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator ● Firestore'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
              alignment: Alignment.centerRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _expression,
                    style: const TextStyle(fontSize: 28),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _result,
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              flex: 2,
              child: _buttonsGrid(),
            ),
            const Divider(),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text('History (Firestore)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: calculations
                            .orderBy('timestamp', descending: true)
                            .limit(50)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return const Center(child: Text('Error loading history'));
                          }
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          final docs = snapshot.data!.docs;
                          if (docs.isEmpty) {
                            return const Center(child: Text('No history yet'));
                          }
                          return ListView.builder(
                            itemCount: docs.length,
                            itemBuilder: (context, index) {
                              final d = docs[index];
                              final expr = d['expression'] ?? '';
                              final res = d['result'] ?? '';
                              Timestamp? ts = d['timestamp'] as Timestamp?;
                              final timeStr = ts != null ? DateTime.fromMillisecondsSinceEpoch(ts.seconds * 1000).toLocal().toString() : '';
                              return ListTile(
                                title: Text('$expr = $res'),
                                subtitle: Text(timeStr),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete_outline),
                                  onPressed: () {
                                    d.reference.delete();
                                  },
                                ),
                                onTap: () {
                                  setState(() {
                                    _expression = res;
                                  });
                                },
                              );
                            },
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
