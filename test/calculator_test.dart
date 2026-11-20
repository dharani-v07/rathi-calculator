import 'package:flutter_test/flutter_test.dart';
import 'package:calculator/models/history_item.dart';
import 'package:calculator/services/evaluator_service.dart';

void main() {
  group('EvaluatorService Tests', () {
    test('Basic Arithmetic', () {
      expect(EvaluatorService.evaluate('2 + 3 × 4', isDegree: true).value, '14');
      expect(EvaluatorService.evaluate('10 - 4 ÷ 2', isDegree: true).value, '8');
      expect(EvaluatorService.evaluate('(12 + 8) × 5', isDegree: true).value, '100');
    });

    test('Percentage evaluation', () {
      expect(EvaluatorService.evaluate('50%', isDegree: true).value, '0.5');
      expect(EvaluatorService.evaluate('200 × 15%', isDegree: true).value, '30');
    });

    test('Factorial evaluation', () {
      expect(EvaluatorService.evaluate('5!', isDegree: true).value, '120');
      expect(EvaluatorService.evaluate('0!', isDegree: true).value, '1');
    });

    test('Trigonometric evaluations (DEG vs RAD)', () {
      // sin(90) in DEG = 1
      expect(EvaluatorService.evaluate('sin(90)', isDegree: true).value, '1');
      // sin(0) = 0
      expect(EvaluatorService.evaluate('sin(0)', isDegree: true).value, '0');
      // cos(0) = 1
      expect(EvaluatorService.evaluate('cos(0)', isDegree: true).value, '1');
    });

    test('Logarithms and Exponentiation', () {
      expect(EvaluatorService.evaluate('log(100)', isDegree: true).value, '2');
      expect(EvaluatorService.evaluate('2^3', isDegree: true).value, '8');
      expect(EvaluatorService.evaluate('√(16)', isDegree: true).value, '4');
    });

    test('Error Handling', () {
      final divZero = EvaluatorService.evaluate('10 ÷ 0', isDegree: true);
      expect(divZero.isError, true);
      expect(divZero.value, 'Cannot divide by zero');

      final syntaxErr = EvaluatorService.evaluate('(2 + 3', isDegree: true);
      expect(syntaxErr.isError, true);
      expect(syntaxErr.value, 'Syntax Error');
    });

    test('Live Preview', () {
      expect(EvaluatorService.livePreview('5 + 5 +', isDegree: true), '10');
      expect(EvaluatorService.livePreview('10 × 2', isDegree: true), '20');
    });
  });

  group('HistoryItem Model Tests', () {
    test('JSON serialization and decoding', () {
      final now = DateTime.now();
      final item1 = HistoryItem(
        id: '1',
        expression: '5 + 5',
        result: '10',
        timestamp: now,
      );

      final json = item1.toJson();
      final restored = HistoryItem.fromJson(json);

      expect(restored.id, '1');
      expect(restored.expression, '5 + 5');
      expect(restored.result, '10');

      final list = [item1];
      final encoded = HistoryItem.encodeList(list);
      final decoded = HistoryItem.decodeList(encoded);

      expect(decoded.length, 1);
      expect(decoded.first.expression, '5 + 5');
    });

    test('Decode empty/invalid JSON returns empty list', () {
      expect(HistoryItem.decodeList(''), isEmpty);
      expect(HistoryItem.decodeList('invalid_json'), isEmpty);
    });
  });
}
