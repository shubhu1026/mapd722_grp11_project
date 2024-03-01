// patients_screen.dart
import 'package:flutter/material.dart';
import 'package:mapd722_mobile_web_development/widgets/custom_app_bar.dart';
import '../widgets/patients_tab_controller.dart';
import 'add_patient_screen.dart';

class PatientsScreen extends StatefulWidget {
  @override
  _PatientsScreenState createState() => _PatientsScreenState();
}

class _PatientsScreenState extends State<PatientsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'MediCare',
        onBack: () {
          Navigator.pop(context);
        },
        onMenu: () {
          print('Custom menu button pressed!');
        },
      ),
      body: PatientsTabController(tabController: _tabController),
      bottomSheet: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddPatientScreen(), // Replace AddPatientScreen with the actual screen widget
                      ),
                    );
                  },
                  tooltip: 'Add Patients',
                  splashRadius: 24,
                  padding: EdgeInsets.all(8),
                  icon: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add,
                        color: Color(0xFF007CFF),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Add Patient',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF007CFF),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
