import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_calllwork/main.dart';

void main() {
  testWidgets('CallWork app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const CallWorkApp());
    expect(find.text('Call Work'), findsWidgets);
  });
}
