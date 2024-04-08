import 'package:flutter/material.dart';
import 'package:mapd722_mobile_web_development/providers/patients_provider.dart';
import 'package:mapd722_mobile_web_development/screens/home_screen.dart';
<<<<<<< HEAD
import 'package:provider/provider.dart';
=======
import 'package:flutter_driver/driver_extension.dart';
>>>>>>> 94b9277de942aef293ba64d5822852547e776736

void main() {
  enableFlutterDriverExtension();

  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PatientsProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
