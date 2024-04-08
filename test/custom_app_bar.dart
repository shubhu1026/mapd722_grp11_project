import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapd722_mobile_web_development/widgets/custom_app_bar.dart';

void main() {
 testWidgets('CustomAppBar renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: CustomAppBar(title: 'Test Title')));

    expect(find.text('Test Title'), findsOneWidget);
 });
}
