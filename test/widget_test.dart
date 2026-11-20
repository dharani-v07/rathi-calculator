import 'package:flutter_test/flutter_test.dart';
import 'package:calculator/main.dart';

void main() {
  testWidgets('CalculatorApp builds cleanly', (WidgetTester tester) async {
    await tester.pumpWidget(const CalculatorApp());
    expect(find.text('Rathi Calculator'), findsOneWidget);
  });
}
