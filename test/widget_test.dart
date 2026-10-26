import 'package:flutter_test/flutter_test.dart';
import 'package:smart_label/main.dart';

void main() {
  testWidgets('Smart Label uygulaması açılır', (WidgetTester tester) async {
    await tester.pumpWidget(const SmartLabelApp());

    expect(find.text('Smart Label'), findsOneWidget);
  });
}