import 'package:flutter/material.dart';
import 'package:mapd722_mobile_web_development/widgets/critical_patients_tab.dart';
import 'package:mapd722_mobile_web_development/widgets/patients_tab.dart';
import 'package:mapd722_mobile_web_development/constants/constants.dart';

import '../screens/add_patient_screen.dart';

class PatientsTabController extends StatelessWidget {
  final TabController tabController;

  const PatientsTabController({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Constants.primaryColor,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TabBar(
                  controller: tabController,
                  labelColor: Colors.white,
                  indicator: BoxDecoration(
                    color: Constants.primaryColor,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  tabs: const [
                    Tab(text: 'Critical Patients'),
                    Tab(text: 'All Patients'),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: CriticalPatientsTab(),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: PatientsTab(),
                ),
              ],
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 2),
                ),
              ],
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
                            builder: (context) => const AddPatientScreen(),
                          ),
                        );
                      },
                      tooltip: 'Add Patients',
                      splashRadius: 24,
                      padding: const EdgeInsets.all(8),
                      icon: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add,
                            color: Constants.primaryColor,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Add Patient',
                            style: TextStyle(
                              fontSize: 17,
                              color: Constants.primaryColor,
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
        ],
      ),
    );
  }
}
