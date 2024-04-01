import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mapd722_mobile_web_development/models/patient.dart';
import 'package:mapd722_mobile_web_development/screens/patient_details_screen.dart';
import '../constants/constants.dart';
import '../util.dart';

class PatientCard extends StatefulWidget {
  final Patient patient;

  const PatientCard({required this.patient});

  @override
  _PatientCardState createState() => _PatientCardState();
}

class _PatientCardState extends State<PatientCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PatientDetailsScreen(patientId:  widget.patient.id,),
            ),
          );
        });
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          children: [
            ListTile(
              leading: CircleAvatar(child: Image.asset('assets/images/patient_icon.png'),),
              title: Text('${widget.patient.firstName} ${widget.patient.lastName}'),
              subtitle: Text('Date of Birth: ' + (Util.getFormattedDate(DateTime.tryParse(widget.patient.dateOfBirth ?? ''), DateFormat('dd MMM, yyyy')) ?? ''),),
              trailing: IconButton(
                icon: Icon(_expanded ? Icons.arrow_drop_up : Icons.arrow_drop_down),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
            if (_expanded) ..._buildAdditionalInfo(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildAdditionalInfo() {
    return [
      _buildInfoItem('Gender:', widget.patient.gender),
      _buildInfoItem('Address:', widget.patient.address),
      _buildInfoItem('Phone:', widget.patient.contactNumber),
      // Add more info items as needed
    ];
  }

  Widget _buildInfoItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
