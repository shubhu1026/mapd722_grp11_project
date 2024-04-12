import 'package:flutter/material.dart';
import 'package:mapd722_mobile_web_development/widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';
import '../providers/patients_provider.dart';
import '../widgets/patients_tab_controller.dart';
import 'add_patient_screen.dart';
import '../widgets/custom_drawer.dart';
import '../constants/constants.dart'; // Importing the Constants class

class PatientsScreen extends StatefulWidget {
  const PatientsScreen({super.key});

  @override
  _PatientsScreenState createState() => _PatientsScreenState();
}

class _PatientsScreenState extends State<PatientsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Fetch patient list every time the screen is loaded
    Provider.of<PatientsProvider>(context, listen: false).updatePatientLists();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        title: 'MediCare',
        onBack: () {
          Navigator.pop(context);
        },
        onMenu: () {
          _scaffoldKey.currentState!.openDrawer();
        },
      ),
      drawer: CustomDrawer(),
      body: PatientsTabController(tabController: _tabController),
    );
  }
}
