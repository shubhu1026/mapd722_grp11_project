import 'package:flutter/material.dart';
import 'package:mapd722_mobile_web_development/providers/patient_details_provider.dart';
import 'package:mapd722_mobile_web_development/providers/patient_records_provider.dart';
import 'package:mapd722_mobile_web_development/providers/patients_provider.dart';
import 'package:mapd722_mobile_web_development/screens/home_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PatientsProvider()),
        ChangeNotifierProvider(create: (_) => PatientDetailsProvider()),
        ChangeNotifierProvider(create: (_) => PatientRecordsProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        themeMode: ThemeMode.light,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
