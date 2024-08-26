import 'package:flutter/material.dart';
import 'package:expressions/expressions.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RX',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: TextTheme(
          bodyMedium: TextStyle(fontFamily: 'SFProText'), // Custom Font
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.grey[800],
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _output = '0';
  String _currentValue = '';

  void _onButtonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'C') {
        _currentValue = '';
        _output = '0';
      } else if (buttonText == '=') {
        try {
          _output = _calculate(_currentValue).toString();
          _currentValue = '';
        } catch (e) {
          _output = 'Error';
        }
      } else {
        if (_currentValue == '0' && buttonText != '.') {
          _currentValue = buttonText;
        } else {
          _currentValue += buttonText;
        }
        _output = _currentValue;
      }
    });
  }

  double _calculate(String expression) {
    try {
      final expressionParsed = Expression.parse(
          expression.replaceAll('x', '*').replaceAll('÷', '/'));
      final evaluator = const ExpressionEvaluator();
      final result = evaluator.eval(expressionParsed, {});
      return result.toDouble();
    } catch (e) {
      throw Exception('Invalid Expression');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('RX'),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Display area with gradient
          Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black87, Colors.black],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Text(
              _output,
              style: TextStyle(
                fontSize: 80.0,
                color: Colors.white,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          Divider(height: 1.0, color: Colors.grey[800]),
          // Number pad with advanced design
          Expanded(
            child: Column(
              children: [
                _buildButtonRow([
                  'C',
                  '%',
                  'x',
                  '-'
                ], [
                  const Color.fromARGB(255, 231, 23, 68),
                  Colors.grey,
                  Colors.grey,
                  const Color.fromARGB(255, 5, 45, 156)
                ]),
                _buildButtonRow([
                  '7',
                  '8',
                  '9',
                  '+'
                ], [
                  const Color.fromARGB(255, 63, 62, 62),
                  const Color.fromARGB(255, 59, 58, 58),
                  const Color.fromARGB(255, 53, 52, 52),
                  const Color.fromARGB(255, 15, 5, 158)
                ]),
                _buildButtonRow([
                  '4',
                  '5',
                  '6',
                  '÷'
                ], [
                  const Color.fromARGB(255, 65, 64, 64),
                  const Color.fromARGB(255, 66, 66, 66),
                  const Color.fromARGB(255, 61, 61, 61),
                  const Color.fromARGB(255, 14, 5, 141)
                ]),
                _buildButtonRow([
                  '1',
                  '2',
                  '3',
                  '='
                ], [
                  const Color.fromARGB(255, 63, 62, 62),
                  const Color.fromARGB(255, 61, 60, 60),
                  const Color.fromARGB(255, 63, 61, 61),
                  Colors.blue
                ]),
                _buildButtonRow(['0', '.'], [Colors.grey, Colors.grey]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtonRow(List<String> buttonTexts, List<Color> colors) {
    return Expanded(
      child: Row(
        children: buttonTexts.asMap().entries.map((entry) {
          int index = entry.key;
          String text = entry.value;
          return _buildButton(text, color: colors[index]);
        }).toList(),
      ),
    );
  }

  Widget _buildButton(String text, {Color color = Colors.grey}) {
    return Expanded(
      child: AspectRatio(
        aspectRatio: 1.0,
        child: Container(
          margin: EdgeInsets.all(2.0), // Small margin for button spacing
          child: Material(
            color: color,
            borderRadius: BorderRadius.circular(50.0), // Rounded corners
            elevation: 5.0, // Shadow effect
            child: InkWell(
              onTap: () => _onButtonPressed(text),
              borderRadius: BorderRadius.circular(50.0), // Rounded corners
              splashColor: Colors.white24,
              child: Center(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 28.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
