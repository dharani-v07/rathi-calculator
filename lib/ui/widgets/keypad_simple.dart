import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/calculator_provider.dart';
import '../theme/app_theme.dart';
import 'calc_button.dart';

class KeypadSimple extends StatelessWidget {
  const KeypadSimple({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CalculatorProvider>(context, listen: false);

    return Column(
      children: [
        // Row 1: AC (All Clear), +/-, %, ÷
        Expanded(
          child: Row(
            children: [
              CalcButton(
                text: 'AC',
                type: ButtonType.action,
                onTap: provider.clear,
              ),
              CalcButton(
                text: '()',
                type: ButtonType.action,
                onTap: provider.appendParenthesis,
              ),
              CalcButton(
                text: '%',
                type: ButtonType.action,
                onTap: () => provider.appendInput('%'),
              ),
              CalcButton(
                text: '÷',
                type: ButtonType.operator,
                onTap: () => provider.appendInput('÷'),
              ),
            ],
          ),
        ),
        // Row 2: 7, 8, 9, ×
        Expanded(
          child: Row(
            children: [
              CalcButton(
                text: '7',
                type: ButtonType.number,
                onTap: () => provider.appendInput('7'),
              ),
              CalcButton(
                text: '8',
                type: ButtonType.number,
                onTap: () => provider.appendInput('8'),
              ),
              CalcButton(
                text: '9',
                type: ButtonType.number,
                onTap: () => provider.appendInput('9'),
              ),
              CalcButton(
                text: '×',
                type: ButtonType.operator,
                onTap: () => provider.appendInput('×'),
              ),
            ],
          ),
        ),
        // Row 3: 4, 5, 6, -
        Expanded(
          child: Row(
            children: [
              CalcButton(
                text: '4',
                type: ButtonType.number,
                onTap: () => provider.appendInput('4'),
              ),
              CalcButton(
                text: '5',
                type: ButtonType.number,
                onTap: () => provider.appendInput('5'),
              ),
              CalcButton(
                text: '6',
                type: ButtonType.number,
                onTap: () => provider.appendInput('6'),
              ),
              CalcButton(
                text: '-',
                type: ButtonType.operator,
                onTap: () => provider.appendInput('-'),
              ),
            ],
          ),
        ),
        // Row 4: 1, 2, 3, +
        Expanded(
          child: Row(
            children: [
              CalcButton(
                text: '1',
                type: ButtonType.number,
                onTap: () => provider.appendInput('1'),
              ),
              CalcButton(
                text: '2',
                type: ButtonType.number,
                onTap: () => provider.appendInput('2'),
              ),
              CalcButton(
                text: '3',
                type: ButtonType.number,
                onTap: () => provider.appendInput('3'),
              ),
              CalcButton(
                text: '+',
                type: ButtonType.operator,
                onTap: () => provider.appendInput('+'),
              ),
            ],
          ),
        ),
        // Row 5: 0, ., ⌫ (single delete), =
        Expanded(
          child: Row(
            children: [
              CalcButton(
                text: '0',
                type: ButtonType.number,
                onTap: () => provider.appendInput('0'),
              ),
              CalcButton(
                text: '.',
                type: ButtonType.number,
                onTap: () => provider.appendInput('.'),
              ),
              CalcButton(
                icon: const Icon(Icons.backspace_outlined, size: 22),
                type: ButtonType.action,
                onTap: provider.backspace,
              ),
              CalcButton(
                text: '=',
                type: ButtonType.equals,
                onTap: provider.evaluate,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
