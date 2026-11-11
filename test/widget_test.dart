// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:otorep/main.dart';

void main() {
  testWidgets('shows admin login and Supabase setup status', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const OtorepApp());

    expect(find.text('SIGN IN'), findsOneWidget);
    expect(find.text('RESEND CONFIRMATION EMAIL'), findsNothing);
    expect(find.textContaining('Connect Supabase'), findsOneWidget);
  });
}
