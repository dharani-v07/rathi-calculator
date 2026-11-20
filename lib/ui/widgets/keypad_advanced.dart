import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/calculator_provider.dart';
import '../theme/app_theme.dart';
import 'calc_button.dart';

class KeypadAdvanced extends StatelessWidget {
  const KeypadAdvanced({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CalculatorProvider>(context);

    return Column(
      children: [
        // Scientific Row 0 (Memory Operations): MC, MR, M+, M-, x², 1/x
        Expanded(
          child: Row(
            children: [
              CalcButton(
                text: 'MC',
                type: ButtonType.memory,
                fontSize: 13.0,
                onTap: provider.memoryClear,
              ),
              CalcButton(
                text: 'MR',
                type: ButtonType.memory,
                fontSize: 13.0,
                onTap: provider.memoryRecall,
              ),
              CalcButton(
                text: 'M+',
                type: ButtonType.memory,
                fontSize: 13.0,
                onTap: provider.memoryAdd,
              ),
              CalcButton(
                text: 'M-',
                type: ButtonType.memory,
                fontSize: 13.0,
                onTap: provider.memorySubtract,
              ),
              CalcButton(
                text: 'x²',
                type: ButtonType.scientific,
                fontSize: 14.0,
                onTap: provider.square,
              ),
              CalcButton(
                text: '1/x',
                type: ButtonType.scientific,
                fontSize: 13.0,
                onTap: provider.reciprocal,
              ),
            ],
          ),
        ),
        // Scientific Row 1: RAD/DEG, sin, cos, tan, ln
        Expanded(
          child: Row(
            children: [
              CalcButton(
                text: provider.isDegreeMode ? 'DEG' : 'RAD',
                type: ButtonType.scientific,
                fontSize: 14.0,
                isSelected: true,
                onTap: provider.toggleAngleMode,
              ),
              CalcButton(
                text: 'sin',
                type: ButtonType.scientific,
                fontSize: 14.0,
                onTap: () => provider.appendInput('sin('),
              ),
              CalcButton(
                text: 'cos',
                type: ButtonType.scientific,
                fontSize: 14.0,
                onTap: () => provider.appendInput('cos('),
              ),
              CalcButton(
                text: 'tan',
                type: ButtonType.scientific,
                fontSize: 14.0,
                onTap: () => provider.appendInput('tan('),
              ),
              CalcButton(
                text: 'ln',
                type: ButtonType.scientific,
                fontSize: 14.0,
                onTap: () => provider.appendInput('ln('),
              ),
            ],
          ),
        ),
        // Scientific Row 2: π, log, e, x^y, √
        Expanded(
          child: Row(
            children: [
              CalcButton(
                text: 'π',
                type: ButtonType.scientific,
                fontSize: 16.0,
                onTap: () => provider.appendInput('π'),
              ),
              CalcButton(
                text: 'log',
                type: ButtonType.scientific,
                fontSize: 14.0,
                onTap: () => provider.appendInput('log('),
              ),
              CalcButton(
                text: 'e',
                type: ButtonType.scientific,
                fontSize: 16.0,
                onTap: () => provider.appendInput('e'),
              ),
              CalcButton(
                text: 'x^y',
                type: ButtonType.scientific,
                fontSize: 14.0,
                onTap: () => provider.appendInput('^'),
              ),
              CalcButton(
                text: '√',
                type: ButtonType.scientific,
                fontSize: 16.0,
                onTap: () => provider.appendInput('√('),
              ),
            ],
          ),
        ),
        // Scientific Row 3: (, ), !, AC, ÷
        Expanded(
          child: Row(
            children: [
              CalcButton(
                text: '(',
                type: ButtonType.scientific,
                fontSize: 16.0,
                onTap: () => provider.appendInput('('),
              ),
              CalcButton(
                text: ')',
                type: ButtonType.scientific,
                fontSize: 16.0,
                onTap: () => provider.appendInput(')'),
              ),
              CalcButton(
                text: '!',
                type: ButtonType.scientific,
                fontSize: 16.0,
                onTap: () => provider.appendInput('!'),
              ),
              CalcButton(
                text: 'AC',
                type: ButtonType.action,
                fontSize: 16.0,
                onTap: provider.clear,
              ),
              CalcButton(
                text: '÷',
                type: ButtonType.operator,
                onTap: () => provider.appendInput('÷'),
              ),
            ],
          ),
        ),
        // Standard Grid Row 4: 7, 8, 9, ×, %
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
              CalcButton(
                text: '%',
                type: ButtonType.operator,
                onTap: () => provider.appendInput('%'),
              ),
            ],
          ),
        ),
        // Standard Grid Row 5: 4, 5, 6, -, ()
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
              CalcButton(
                text: '()',
                type: ButtonType.action,
                fontSize: 14.0,
                onTap: provider.appendParenthesis,
              ),
            ],
          ),
        ),
        // Standard Grid Row 6: 1, 2, 3, +, ⌫
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
              CalcButton(
                icon: const Icon(Icons.backspace_outlined, size: 18),
                type: ButtonType.action,
                onTap: provider.backspace,
              ),
            ],
          ),
        ),
        // Standard Grid Row 7: 0, ., =
        Expanded(
          child: Row(
            children: [
              CalcButton(
                text: '0',
                flex: 2,
                type: ButtonType.number,
                onTap: () => provider.appendInput('0'),
              ),
              CalcButton(
                text: '.',
                flex: 1,
                type: ButtonType.number,
                onTap: () => provider.appendInput('.'),
              ),
              CalcButton(
                text: '=',
                flex: 2,
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
