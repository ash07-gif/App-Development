import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator with SQLite',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  // ✅ using singleton instance
  final DBHelper dbHelper = DBHelper.instance;

  String expression = '';
  String result = '';
  List<Map<String, dynamic>> history = [];

  final Set<String> operators = {'+', '-', '×', '÷', '^', '%'};
  int openBrackets = 0;

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  void loadHistory() async {
    final data = await dbHelper.getHistory();
    setState(() {
      history = data;
    });
  }

  bool _isOperator(String s) => operators.contains(s);

  void onButtonPressed(String text) {
    setState(() {
      if (text == 'C') {
        expression = '';
        result = '';
        return;
      }

      if (text == '⌫') {
        if (expression.isNotEmpty) {
          if (expression.endsWith('(')) openBrackets--;
          if (expression.endsWith(')')) openBrackets++;
          expression = expression.substring(0, expression.length - 1);
        }
        return;
      }

      if (text == '=') {
        calculate();
        return;
      }

      if (text == '(') {
        openBrackets++;
      } else if (text == ')') {
        if (openBrackets <= 0) return; // prevent extra closing
        openBrackets--;
      }

      // Prevent consecutive operators
      if (expression.isNotEmpty &&
          _isOperator(expression[expression.length - 1]) &&
          _isOperator(text)) {
        expression =
            expression.substring(0, expression.length - 1) + text; // replace
      } else {
        expression += text;
      }
    });
  }

  void calculate() async {
    if (expression.isEmpty) return;
    try {
      String exp = expression
          .replaceAll('×', '*')
          .replaceAll('÷', '/')
          .replaceAll('π', '3.1415926535897932');

      // Close any unbalanced parentheses
      while (openBrackets > 0) {
        exp += ')';
        openBrackets--;
      }

      Parser p = Parser();
      Expression parsed = p.parse(exp);
      ContextModel cm = ContextModel();
      double eval = parsed.evaluate(EvaluationType.REAL, cm);

      if (eval.isInfinite || eval.isNaN) throw Exception('Invalid math');

      // Format result
      String formatted;
      if (eval == eval.roundToDouble()) {
        formatted = eval.toInt().toString();
      } else {
        formatted = eval.toStringAsFixed(6);
        formatted = formatted.replaceAll(RegExp(r'0+$'), '');
        formatted = formatted.replaceAll(RegExp(r'\.$'), '');
      }

      result = formatted;
      await dbHelper.insertHistory(expression, result);
      loadHistory();
      setState(() {});
    } catch (e) {
      setState(() {
        result = 'Error';
      });
    }
  }

  Widget buildButton(String text, {double height = 64}) {
    final bool isOperator =
        RegExp(r'[÷×\+\-\=\%\^]').hasMatch(text) || text == '=';
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: SizedBox(
          height: height,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor:
              isOperator ? Colors.deepPurpleAccent : Colors.deepPurple,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              padding: const EdgeInsets.all(6),
              elevation: 4,
            ),
            onPressed: () => onButtonPressed(text),
            // ✅ Text color set to white for better visibility
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.white, // <--- CHANGED HERE
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildButtonRow(List<String> texts) {
    return Row(children: texts.map((t) => buildButton(t)).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator with SQLite'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: () async {
              await dbHelper.clearHistory();
              loadHistory();
            },
            tooltip: 'Clear history',
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Display
            Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [Color(0xFF7C4DFF), Color(0xFF536DFE)]),
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black26, blurRadius: 10, offset: Offset(0, 4))
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(expression,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                          fontSize: 28, color: Colors.white70)),
                  const SizedBox(height: 12),
                  Text(result,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                          fontSize: 36,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            // Buttons
            Expanded(
              child: Column(
                children: [
                  buildButtonRow(['7', '8', '9', '÷']),
                  buildButtonRow(['4', '5', '6', '×']),
                  buildButtonRow(['1', '2', '3', '-']),
                  buildButtonRow(['0', '.', '⌫', '+']),
                  buildButtonRow(['(', ')', 'π', '=']),
                  const SizedBox(height: 6),
                ],
              ),
            ),
            const Divider(),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 6.0),
              child: Text('History',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            ),
            SizedBox(
              height: 180,
              child: ListView.builder(
                itemCount: history.length,
                itemBuilder: (context, index) {
                  final item = history[index];
                  return ListTile(
                    title: Text(item['expression'] ?? ''),
                    subtitle: Text('= ${item['result'] ?? ''}'),
                    dense: true,
                    onTap: () {
                      setState(() {
                        expression = item['expression'] ?? '';
                        result = item['result'] ?? '';
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
