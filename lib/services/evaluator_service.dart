import 'dart:math' as math;
import 'package:math_expressions/math_expressions.dart';

class EvaluationResult {
  final String value;
  final bool isError;

  EvaluationResult.success(this.value) : isError = false;
  EvaluationResult.error(this.value) : isError = true;
}

class EvaluatorService {
  static const double _pi = math.pi;
  static const double _e = math.e;

  /// Evaluates mathematical expression.
  /// Returns [EvaluationResult] containing evaluated string or error message.
  static EvaluationResult evaluate(String expression, {required bool isDegree}) {
    if (expression.trim().isEmpty) {
      return EvaluationResult.success('');
    }

    // Validate parenthesis balance
    int openBrackets = 0;
    int closeBrackets = 0;
    for (int i = 0; i < expression.length; i++) {
      if (expression[i] == '(') openBrackets++;
      if (expression[i] == ')') closeBrackets++;
    }
    if (openBrackets != closeBrackets) {
      return EvaluationResult.error('Syntax Error');
    }

    // Validate division by zero
    if (RegExp(r'[/÷]\s*0($|[^\d.])').hasMatch(expression)) {
      return EvaluationResult.error('Cannot divide by zero');
    }

    // Validate trailing operator (excluding percentage)
    if (RegExp(r'[+\-×÷*/^]$').hasMatch(expression.trim())) {
      return EvaluationResult.error('Syntax Error');
    }

    try {
      String sanitized = _sanitizeExpression(expression, isDegree: isDegree);
      if (sanitized.isEmpty) {
        return EvaluationResult.success('');
      }

      final GrammarParser parser = GrammarParser();
      final Expression parsedExp = parser.parse(sanitized);

      final double evalResult = RealEvaluator().evaluate(parsedExp).toDouble();

      if (evalResult.isNaN) {
        return EvaluationResult.error('Domain Error');
      }

      if (evalResult.isInfinite) {
        return EvaluationResult.error('Cannot divide by zero');
      }

      String formatted = _formatResult(evalResult);
      return EvaluationResult.success(formatted);
    } catch (e) {
      final errStr = e.toString().toLowerCase();
      if (errStr.contains('zero') || errStr.contains('divide')) {
        return EvaluationResult.error('Cannot divide by zero');
      }
      return EvaluationResult.error('Syntax Error');
    }
  }

  /// Evaluates for live preview. Returns null if current incomplete expression cannot be evaluated.
  static String? livePreview(String expression, {required bool isDegree}) {
    if (expression.trim().isEmpty) return null;

    // Strip trailing incomplete operators for live preview
    String cleanExpr = expression.trim();
    while (cleanExpr.endsWith('+') ||
        cleanExpr.endsWith('-') ||
        cleanExpr.endsWith('×') ||
        cleanExpr.endsWith('÷') ||
        cleanExpr.endsWith('^') ||
        cleanExpr.endsWith('(')) {
      cleanExpr = cleanExpr.substring(0, cleanExpr.length - 1).trim();
    }

    if (cleanExpr.isEmpty) return null;

    final result = evaluate(cleanExpr, isDegree: isDegree);
    if (result.isError) return null;
    return result.value;
  }

  static String _sanitizeExpression(String expr, {required bool isDegree}) {
    String s = expr;

    // Replace visual symbols
    s = s.replaceAll('×', '*');
    s = s.replaceAll('÷', '/');
    s = s.replaceAll('π', _pi.toString());
    s = s.replaceAll('e', _e.toString());

    // Preprocess factorials: handle integers followed by !
    s = _processFactorials(s);

    // Preprocess percentages: e.g. 50% -> (50*0.01)
    s = s.replaceAllMapped(RegExp(r'(\d+(\.\d+)?)%'), (match) {
      return '(${match.group(1)}*0.01)';
    });

    // Handle implicit multiplication (e.g., 2(3) -> 2*(3), 5sqrt -> 5*sqrt, 5sin -> 5*sin)
    s = s.replaceAllMapped(RegExp(r'(\d)\s*\('), (match) => '${match.group(1)}*(');
    s = s.replaceAllMapped(RegExp(r'\)\s*(\d)'), (match) => ')*${match.group(1)}');
    s = s.replaceAllMapped(RegExp(r'(\d)\s*(sin|cos|tan|asin|acos|atan|log|ln|sqrt)'), 
        (match) => '${match.group(1)}*${match.group(2)}');

    // Replace square root visual
    s = s.replaceAll('√', 'sqrt');

    // Replace cube root visual ∛(x) -> (x)^(1/3)
    s = s.replaceAllMapped(RegExp(r'∛\(([^)]+)\)'), (match) {
      return '((${match.group(1)})^(1/3))';
    });

    // Process log base 10: math_expressions log(x) is natural log in parser, so log(x) -> (ln(x)/ln(10))
    s = _processLogBase10(s);

    // Convert degree inputs to radians for trig functions if in Degree mode
    if (isDegree) {
      s = _convertTrigDegreesToRadians(s);
    }

    return s;
  }

  static String _processLogBase10(String expr) {
    return expr.replaceAllMapped(RegExp(r'log\(([^()]+)\)'), (match) {
      final arg = match.group(1);
      return '(ln($arg)/ln(10))';
    });
  }

  static String _convertTrigDegreesToRadians(String expr) {
    final double radFactor = math.pi / 180.0;
    String s = expr;

    s = s.replaceAllMapped(RegExp(r'(?<!a)sin\(([^()]+)\)'), (match) {
      return 'sin((${match.group(1)})*$radFactor)';
    });
    s = s.replaceAllMapped(RegExp(r'(?<!a)cos\(([^()]+)\)'), (match) {
      return 'cos((${match.group(1)})*$radFactor)';
    });
    s = s.replaceAllMapped(RegExp(r'(?<!a)tan\(([^()]+)\)'), (match) {
      return 'tan((${match.group(1)})*$radFactor)';
    });

    return s;
  }

  static String _processFactorials(String expr) {
    return expr.replaceAllMapped(RegExp(r'(\d+)!'), (match) {
      final int val = int.parse(match.group(1)!);
      final double fact = _factorial(val);
      return fact.toString();
    });
  }

  static double _factorial(int n) {
    if (n < 0) return double.nan;
    if (n == 0 || n == 1) return 1.0;
    double res = 1.0;
    for (int i = 2; i <= n; i++) {
      res *= i;
    }
    return res;
  }

  static String _formatResult(double val) {
    if (val.abs() < 1e-12 && val != 0) {
      return '0';
    }

    // Check if integer
    if (val == val.roundToDouble() && val.abs() < 1e15) {
      return val.toInt().toString();
    }

    // Round to max 10 decimal places to eliminate floating point precision artifacts
    String formatted = val.toStringAsFixed(10);
    formatted = formatted.replaceAll(RegExp(r'0+$'), '');
    formatted = formatted.replaceAll(RegExp(r'\.$'), '');

    return formatted;
  }
}
