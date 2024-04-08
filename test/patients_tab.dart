import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapd722_mobile_web_development/widgets/patients_tab.dart';

void main() {
 testWidgets('displays CircularProgressIndicator when loading', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: PatientsTab()));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
 });
}