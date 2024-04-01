import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapd722_mobile_web_development/widgets/custom_text_field.dart';

void main() {
 testWidgets('CustomTextField renders correctly', (WidgetTester tester) async {
    // Create a TextEditingController
    final controller = TextEditingController();

    await tester.pumpWidget(MaterialApp(home: CustomTextField(labelText: 'Test Label', prefixIcon: Icons.delete , controller: controller)));

    expect(find.text('Test Label'), findsOneWidget);
 });
}
