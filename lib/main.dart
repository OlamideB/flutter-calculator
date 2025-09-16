import 'package:flutter/material.dart';
import 'package:expressions/expressions.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Olamide Britto Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      home: const CalculatorScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _expression = '';
  String _result = '';
  bool _hasError = false;

  void _onButtonPressed(String value) {
    setState(() {
      _hasError = false;
      if (value == 'C') {
        _expression = '';
        _result = '';
      } else if (value == '=') {
        _evaluate();
      } else {
        if (_result.isNotEmpty && _expression.endsWith('=')) {
          // Start new expression after result
          _expression = '';
          _result = '';
        }
        _expression += value;
      }
    });
  }

  void _evaluate() {
    try {
      // Replace '×' and '÷' with '*' and '/' for evaluation
      String exp = _expression.replaceAll('×', '*').replaceAll('÷', '/');
      final expression = Expression.parse(exp);
      final evaluator = const ExpressionEvaluator();
      final context = <String, dynamic>{};
      final evalResult = evaluator.eval(expression, context);
      _result = evalResult.toString();
      _expression += ' = $_result';
    } catch (e) {
      _result = 'Error';
      _hasError = true;
      _expression += ' = Error';
    }
  }

  Widget _buildButton(String text, {Color? color, Color? textColor}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? Colors.grey[200],
            foregroundColor: textColor ?? Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 22),
            textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          onPressed: () => _onButtonPressed(text),
          child: Text(text),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Olamide Britto Calculator"),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: Colors.black87,
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _expression,
                  style: TextStyle(
                    fontSize: 28,
                    color: _hasError ? Colors.redAccent : Colors.white,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (_result.isNotEmpty && !_hasError)
                  Text(
                    _result,
                    style: const TextStyle(
                      fontSize: 36,
                      color: Colors.greenAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: Container(
              color: Colors.grey[100],
              child: Column(
                children: [
                  Row(
                    children: [
                      _buildButton('7'),
                      _buildButton('8'),
                      _buildButton('9'),
                      _buildButton('÷', color: Colors.blueGrey[200]),
                    ],
                  ),
                  Row(
                    children: [
                      _buildButton('4'),
                      _buildButton('5'),
                      _buildButton('6'),
                      _buildButton('×', color: Colors.blueGrey[200]),
                    ],
                  ),
                  Row(
                    children: [
                      _buildButton('1'),
                      _buildButton('2'),
                      _buildButton('3'),
                      _buildButton('-', color: Colors.blueGrey[200]),
                    ],
                  ),
                  Row(
                    children: [
                      _buildButton('0'),
                      _buildButton('C', color: Colors.red[200], textColor: Colors.red[900]),
                      _buildButton('=', color: Colors.green[200], textColor: Colors.green[900]),
                      _buildButton('+', color: Colors.blueGrey[200]),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
