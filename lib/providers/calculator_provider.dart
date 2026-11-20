import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/history_item.dart';
import '../services/evaluator_service.dart';

class CalculatorProvider with ChangeNotifier {
  static const String _historyKey = 'calc_history_items';
  static const String _memoryKey = 'calc_memory_val';

  final TextEditingController textController = TextEditingController();

  String _expression = '';
  String _result = '';
  String? _preview;
  bool _isError = false;
  bool _isAdvancedMode = false;
  bool _isDegreeMode = true; // true = DEG, false = RAD
  double _memoryValue = 0.0;
  List<HistoryItem> _history = [];

  String get expression => _expression;
  String get result => _result;
  String? get preview => _preview;
  bool get isError => _isError;
  bool get isAdvancedMode => _isAdvancedMode;
  bool get isDegreeMode => _isDegreeMode;
  double get memoryValue => _memoryValue;
  List<HistoryItem> get history => List.unmodifiable(_history);

  CalculatorProvider() {
    _loadHistory();
    _loadMemory();
    textController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    if (_expression != textController.text) {
      _expression = textController.text;
      _updatePreview();
      notifyListeners();
    }
  }

  Future<void> _loadHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? historyJson = prefs.getString(_historyKey);
      if (historyJson != null && historyJson.isNotEmpty) {
        _history = HistoryItem.decodeList(historyJson);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading calculation history: $e');
    }
  }

  Future<void> _loadMemory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _memoryValue = prefs.getDouble(_memoryKey) ?? 0.0;
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading memory: $e');
    }
  }

  Future<void> _saveHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String encoded = HistoryItem.encodeList(_history);
      await prefs.setString(_historyKey, encoded);
    } catch (e) {
      debugPrint('Error saving calculation history: $e');
    }
  }

  Future<void> _saveMemory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(_memoryKey, _memoryValue);
    } catch (e) {
      debugPrint('Error saving memory: $e');
    }
  }

  void toggleMode() {
    _isAdvancedMode = !_isAdvancedMode;
    notifyListeners();
  }

  void toggleAngleMode() {
    _isDegreeMode = !_isDegreeMode;
    _updatePreview();
    notifyListeners();
  }

  void appendInput(String text) {
    if (_isError) {
      _isError = false;
      _result = '';
    }

    if (_result.isNotEmpty && _expression.isEmpty) {
      if (RegExp(r'[\d.πe]').hasMatch(text) || text.contains('(')) {
        _result = '';
      } else {
        textController.text = _result;
        _result = '';
      }
    }

    final int selStart = textController.selection.start;
    final int selEnd = textController.selection.end;
    final String currentText = textController.text;

    if (selStart >= 0 && selEnd >= selStart) {
      final newText = currentText.substring(0, selStart) + text + currentText.substring(selEnd);
      textController.text = newText;
      textController.selection = TextSelection.collapsed(offset: selStart + text.length);
    } else {
      textController.text += text;
      textController.selection = TextSelection.collapsed(offset: textController.text.length);
    }
    _updatePreview();
    notifyListeners();
  }

  void appendParenthesis() {
    if (_isError) {
      _isError = false;
      _result = '';
    }

    if (_result.isNotEmpty && _expression.isEmpty) {
      _result = '';
    }

    int openCount = 0;
    int closeCount = 0;
    for (int i = 0; i < _expression.length; i++) {
      if (_expression[i] == '(') openCount++;
      if (_expression[i] == ')') closeCount++;
    }

    String textToAdd = '(';
    if (_expression.isNotEmpty) {
      final int selStart = textController.selection.start;
      final lastChar = selStart > 0 && selStart <= _expression.length 
          ? _expression[selStart - 1] 
          : (_expression.isNotEmpty ? _expression[_expression.length - 1] : '');
      if (RegExp(r'[\d.πe)]').hasMatch(lastChar)) {
        if (openCount > closeCount) {
          textToAdd = ')';
        } else {
          textToAdd = '×(';
        }
      }
    }

    appendInput(textToAdd);
  }

  void square() {
    if (_expression.isNotEmpty) {
      _expression = '($_expression)^2';
      textController.text = _expression;
    } else if (_result.isNotEmpty && !_isError) {
      _expression = '($_result)^2';
      textController.text = _expression;
      _result = '';
    }
    _updatePreview();
    notifyListeners();
  }

  void reciprocal() {
    if (_expression.isNotEmpty) {
      _expression = '1/($_expression)';
      textController.text = _expression;
    } else if (_result.isNotEmpty && !_isError) {
      _expression = '1/($_result)';
      textController.text = _expression;
      _result = '';
    }
    _updatePreview();
    notifyListeners();
  }

  void memoryClear() {
    _memoryValue = 0.0;
    _saveMemory();
    notifyListeners();
  }

  void memoryRecall() {
    final valStr = EvaluatorService.evaluate(_memoryValue.toString(), isDegree: _isDegreeMode).value;
    appendInput(valStr);
  }

  void memoryAdd() {
    double currentVal = 0.0;
    if (_result.isNotEmpty && !_isError) {
      currentVal = double.tryParse(_result) ?? 0.0;
    } else if (_expression.isNotEmpty) {
      final res = EvaluatorService.evaluate(_expression, isDegree: _isDegreeMode);
      if (!res.isError) {
        currentVal = double.tryParse(res.value) ?? 0.0;
      }
    }
    _memoryValue += currentVal;
    _saveMemory();
    notifyListeners();
  }

  void memorySubtract() {
    double currentVal = 0.0;
    if (_result.isNotEmpty && !_isError) {
      currentVal = double.tryParse(_result) ?? 0.0;
    } else if (_expression.isNotEmpty) {
      final res = EvaluatorService.evaluate(_expression, isDegree: _isDegreeMode);
      if (!res.isError) {
        currentVal = double.tryParse(res.value) ?? 0.0;
      }
    }
    _memoryValue -= currentVal;
    _saveMemory();
    notifyListeners();
  }

  void toggleSign() {
    if (_expression.isEmpty && _result.isNotEmpty && !_isError) {
      if (_result.startsWith('-')) {
        _result = _result.substring(1);
      } else {
        _result = '-$_result';
      }
      notifyListeners();
      return;
    }

    if (_expression.isEmpty) {
      _expression = '-';
    } else if (_expression.startsWith('-(') && _expression.endsWith(')')) {
      _expression = _expression.substring(2, _expression.length - 1);
    } else if (_expression.startsWith('-') && !_expression.contains(RegExp(r'[+×÷]'))) {
      _expression = _expression.substring(1);
    } else {
      _expression = '-($_expression)';
    }
    textController.text = _expression;
    textController.selection = TextSelection.collapsed(offset: _expression.length);
    _updatePreview();
    notifyListeners();
  }

  void backspace() {
    if (_isError) {
      _isError = false;
      _result = '';
    }
    final int selStart = textController.selection.start;
    final int selEnd = textController.selection.end;
    final String currentText = textController.text;

    if (selStart >= 0 && selEnd > selStart) {
      final newText = currentText.substring(0, selStart) + currentText.substring(selEnd);
      textController.text = newText;
      textController.selection = TextSelection.collapsed(offset: selStart);
    } else if (selStart > 0) {
      const functions = ['sin(', 'cos(', 'tan(', 'asin(', 'acos(', 'atan(', 'log(', 'ln(', 'sqrt('];
      int deleteLen = 1;
      for (final fn in functions) {
        if (selStart >= fn.length && currentText.substring(selStart - fn.length, selStart) == fn) {
          deleteLen = fn.length;
          break;
        }
      }
      final newText = currentText.substring(0, selStart - deleteLen) + currentText.substring(selStart);
      textController.text = newText;
      textController.selection = TextSelection.collapsed(offset: selStart - deleteLen);
    } else if (currentText.isNotEmpty && selStart == 0) {
      textController.text = currentText.substring(1);
      textController.selection = const TextSelection.collapsed(offset: 0);
    }
    
    _isError = false;
    _updatePreview();
    notifyListeners();
  }

  void clear() {
    textController.text = '';
    _expression = '';
    _result = '';
    _preview = null;
    _isError = false;
    notifyListeners();
  }

  void evaluate() {
    if (_expression.trim().isEmpty) return;

    final evalRes = EvaluatorService.evaluate(_expression, isDegree: _isDegreeMode);
    if (evalRes.isError) {
      _result = evalRes.value;
      _isError = true;
      _preview = null;
    } else {
      _result = evalRes.value;
      _isError = false;
      _preview = null;

      bool hasOperation = RegExp(r'[+\-×÷*/^%!()]').hasMatch(_expression) ||
          _expression.contains('sin') ||
          _expression.contains('cos') ||
          _expression.contains('tan') ||
          _expression.contains('log') ||
          _expression.contains('ln') ||
          _expression.contains('sqrt');

      if (hasOperation) {
        final newItem = HistoryItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          expression: _expression,
          result: _result,
          timestamp: DateTime.now(),
        );

        _history.insert(0, newItem);
        _saveHistory();
      }

      textController.text = '';
      _expression = '';
    }
    notifyListeners();
  }

  void _updatePreview() {
    if (_expression.isEmpty) {
      _preview = null;
      return;
    }
    _preview = EvaluatorService.livePreview(_expression, isDegree: _isDegreeMode);
  }

  void setExpression(String expr) {
    textController.text = expr;
    textController.selection = TextSelection.collapsed(offset: expr.length);
    _expression = expr;
    _result = '';
    _isError = false;
    _updatePreview();
    notifyListeners();
  }

  void deleteHistoryItem(String id) {
    _history.removeWhere((item) => item.id == id);
    _saveHistory();
    notifyListeners();
  }

  void clearHistory() {
    _history.clear();
    _saveHistory();
    notifyListeners();
  }
}
