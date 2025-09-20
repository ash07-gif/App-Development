
import 'package:flutter/material.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Calculator(),
    );
  }
}

class Calculator extends StatefulWidget {
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  final TextEditingController num1Controller = TextEditingController();
  final TextEditingController num2Controller = TextEditingController();
  String result = "";

  void calculate(String op) {
    double num1 = double.parse(num1Controller.text);
    double num2 = double.parse(num2Controller.text);
    double res = 0;

    if (op == '+') res = num1 + num2;
    else if (op == '-') res = num1 - num2;
    else if (op == '*') res = num1 * num2;
    else if (op == '/') res = num1 / num2;

    setState(() {
      result = "Result: $res";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Calculator")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: num1Controller, decoration: InputDecoration(labelText: "Enter first number")),
            TextField(controller: num2Controller, decoration: InputDecoration(labelText: "Enter second number")),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: () => calculate('+'), child: Text("+")),
                ElevatedButton(onPressed: () => calculate('-'), child: Text("-")),
                ElevatedButton(onPressed: () => calculate('*'), child: Text("*")),
                ElevatedButton(onPressed: () => calculate('/'), child: Text("/")),
              ],
            ),
            Text(result, style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
