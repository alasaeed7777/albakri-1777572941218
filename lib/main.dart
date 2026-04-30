```dart
import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ø­Ø§Ø³Ø¨Ù',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
        brightness: Brightness.light,
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
  String _display = '0';
  String _expression = '';
  double _firstOperand = 0;
  String _operator = '';
  bool _waitingForSecondOperand = false;
  String _memoryValue = '';

  void _inputDigit(String digit) {
    if (_waitingForSecondOperand) {
      setState(() {
        _display = digit;
        _waitingForSecondOperand = false;
      });
    } else {
      setState(() {
        _display = _display == '0' ? digit : _display + digit;
      });
    }
  }

  void _inputDecimal() {
    if (_waitingForSecondOperand) {
      setState(() {
        _display = '0.';
        _waitingForSecondOperand = false;
      });
      return;
    }
    if (!_display.contains('.')) {
      setState(() {
        _display = '$_display.';
      });
    }
  }

  void _performOperation(String operator) {
    if (_operator.isNotEmpty && !_waitingForSecondOperand) {
      _calculate();
    }
    setState(() {
      _firstOperand = double.parse(_display);
      _operator = operator;
      _waitingForSecondOperand = true;
      _expression = '$_firstOperand $operator';
    });
  }

  void _calculate() {
    if (_operator.isEmpty) return;
    final double secondOperand = double.parse(_display);
    double result = 0;
    switch (_operator) {
      case '+':
        result = _firstOperand + secondOperand;
        break;
      case '-':
        result = _firstOperand - secondOperand;
        break;
      case 'Ã':
        result = _firstOperand * secondOperand;
        break;
      case 'Ã·':
        result = secondOperand != 0 ? _firstOperand / secondOperand : double.nan;
        break;
    }
    setState(() {
      if (result.isNaN || result.isInfinite) {
        _display = 'Error';
        _expression = '';
        _operator = '';
        _waitingForSecondOperand = false;
      } else {
        _display = result == result.floorToDouble() ? result.toInt().toString() : result.toStringAsFixed(2);
        _expression = '$_firstOperand $_operator $secondOperand =';
        _operator = '';
        _waitingForSecondOperand = true;
        _firstOperand = result;
      }
    });
  }

  void _clear() {
    setState(() {
      _display = '0';
      _expression = '';
      _firstOperand = 0;
      _operator = '';
      _waitingForSecondOperand = false;
    });
  }

  void _delete() {
    setState(() {
      if (_display.length > 1) {
        _display = _display.substring(0, _display.length - 1);
      } else {
        _display = '0';
      }
    });
  }

  void _toggleSign() {
    setState(() {
      if (_display.startsWith('-')) {
        _display = _display.substring(1);
      } else if (_display != '0') {
        _display = '-$_display';
      }
    });
  }

  void _percentage() {
    setState(() {
      final double value = double.parse(_display) / 100;
      _display = value.toString();
    });
  }

  void _squareRoot() {
    setState(() {
      final double value = double.parse(_display);
      if (value < 0) {
        _display = 'Error';
      } else {
        final double result = sqrt(value);
        _display = result == result.floorToDouble() ? result.toInt().toString() : result.toStringAsFixed(2);
      }
    });
  }

  void _memoryClear() {
    setState(() {
      _memoryValue = '';
    });
  }

  void _memoryRecall() {
    setState(() {
      if (_memoryValue.isNotEmpty) {
        _display = _memoryValue;
      }
    });
  }

  void _memoryAdd() {
    setState(() {
      if (_memoryValue.isEmpty) {
        _memoryValue = _display;
      } else {
        final double sum = double.parse(_memoryValue) + double.parse(_display);
        _memoryValue = sum.toString();
      }
    });
  }

  void _memorySubtract() {
    setState(() {
      if (_memoryValue.isEmpty) {
        _memoryValue = '-$_display';
      } else {
        final double diff = double.parse(_memoryValue) - double.parse(_display);
        _memoryValue = diff.toString();
      }
    });
  }

  Widget _buildButton(String text, {Color? color, double flex = 1}) {
    return Expanded(
      flex: flex ~/ 1,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: SizedBox(
          height: 60,
          child: ElevatedButton(
            onPressed: () {
              switch (text) {
                case 'C':
                  _clear();
                  break;
                case 'â«':
                  _delete();
                  break;
                case 'Â±':
                  _toggleSign();
                  break;
                case '%':
                  _percentage();
                  break;
                case 'â':
                  _squareRoot();
                  break;
                case 'MC':
                  _memoryClear();
                  break;
                case 'MR':
                  _memoryRecall();
                  break;
                case 'M+':
                  _memoryAdd();
                  break;
                case 'M-':
                  _memorySubtract();
                  break;
                case '+':
                case '-':
                case 'Ã':
                case 'Ã·':
                  _performOperation(text);
                  break;
                case '=':
                  _calculate();
                  break;
                case '.':
                  _inputDecimal();
                  break;
                default:
                  _inputDigit(text);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: color ?? Theme.of(context).colorScheme.surfaceContainerHighest,
              foregroundColor: color != null ? Colors.white : Theme.of(context).colorScheme.onSurface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: Text(
              text,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ø­Ø§Ø³Ø¨Ù'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Display area
          Container(
            padding: const EdgeInsets.all(20),
            alignment: Alignment.bottomRight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _expression,
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _display,
                  style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w300),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
          const Divider(),
          // Memory buttons
          Expanded(
            child: Column(
              children: [
                // Row 1: Memory functions
                Expanded(
                  child: Row(
                    children: [
                      _buildButton('MC'),
                      _buildButton('MR'),
                      _buildButton('M+'),
                      _buildButton('M-'),
                    ],
                  ),
                ),
                // Row 2: Clear, sign, percent, divide
                Expanded(
                  child: Row(
                    children: [
                      _buildButton('C', color: Colors.red.shade400),
                      _buildButton('â«'),
                      _buildButton('%'),
                      _buildButton('Ã·', color: Theme.of(context).colorScheme.primary),
                    ],
                  ),
                ),
                // Row 3: 7, 8, 9, multiply
                Expanded(
                  child: Row(
                    children: [
                      _buildButton('7'),
                      _buildButton('8'),
                      _buildButton('9'),
                      _buildButton('Ã', color: Theme.of(context).colorScheme.primary),
                    ],
                  ),
                ),
                // Row 4: 4, 5, 6, subtract
                Expanded(
                  child: Row(
                    children: [
                      _buildButton('4'),
                      _buildButton('5'),
                      _buildButton('6'),
                      _buildButton('-', color: Theme.of(context).colorScheme.primary),
                    ],
                  ),
                ),
                // Row 5: 1, 2, 3, add
                Expanded(
                  child: Row(
                    children: [
                      _buildButton('1'),
                      _buildButton('2'),
                      _buildButton('3'),
                      _buildButton('+', color: Theme.of(context).colorScheme.primary),
                    ],
                  ),
                ),
                // Row 6: 0, decimal, sqrt, equals
                Expanded(
                  child: Row(
                    children: [
                      _buildButton('0', flex: 2),
                      _buildButton('.'),
                      _buildButton('â'),
                      _buildButton('=', color: Theme.of(context).colorScheme.primary),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```