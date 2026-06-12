import 'package:flutter_test/flutter_test.dart';
import 'package:callwork_flutter/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const CallWorkApp());
    expect(find.byType(CallWorkApp), findsOneWidget);
  });
}
