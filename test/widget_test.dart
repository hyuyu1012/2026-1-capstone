import 'package:flutter_test/flutter_test.dart';

import 'package:capstone/main.dart';

void main() {
  testWidgets('LoginScreen renders brand and social buttons',
      (WidgetTester tester) async {
    await tester.pumpWidget(const CareTrackerApp());
    await tester.pump();

    expect(find.text('안심 케어'), findsOneWidget);
    expect(find.text('카카오로 시작하기'), findsOneWidget);
    expect(find.text('Google로 시작하기'), findsOneWidget);
    expect(find.text('Apple로 시작하기'), findsOneWidget);
    expect(find.text('이메일로 시작하기'), findsOneWidget);
  });
}
