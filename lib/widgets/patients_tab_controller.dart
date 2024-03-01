// patients_tab_controller.dart
import 'package:flutter/material.dart';
import 'package:mapd722_mobile_web_development/widgets/critical_patients_tab.dart';
import 'package:mapd722_mobile_web_development/widgets/patients_tab.dart';

class PatientsTabController extends StatelessWidget {
  final TabController tabController;

  const PatientsTabController({required this.tabController});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF007CFF),
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
                    color: const Color(0xFF007CFF),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  tabs: [
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
        ],
      ),
    );
  }
}
