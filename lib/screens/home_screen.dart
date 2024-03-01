import 'package:flutter/material.dart';
import 'package:mapd722_mobile_web_development/screens/patients_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF007CFF),
        title: const Text(
          'MediCare',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w500, fontSize: 24),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.menu_rounded),
            onPressed: () {
              // Add your menu button functionality here
            },
          ),
        ],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const SizedBox(
            height: 20,
          ),
          Image.asset(
            "assets/images/MediCare.png",
            height: 100,
          ),
          const SizedBox(
            height: 20,
          ),
          Image.asset("assets/images/home_image.png"),
        ],
      ),
      bottomSheet: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF007CFF),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Consult Only with a Doctor you Trust!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Schedule appointments, monitor vital signs, and access lab results effortlessly. Your well-being, simplified.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PatientsScreen()),
                  );
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Get Started',
                      style: TextStyle(
                        color: Color(0xFF007CFF),
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.arrow_forward,
                      color: Color(0xFF007CFF),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NextScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Next Screen'),
      ),
      body: Center(
        child: Text('This is the next screen.'),
      ),
    );
  }
}
