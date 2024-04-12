import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mapd722_mobile_web_development/models/patient.dart';
import 'package:mapd722_mobile_web_development/screens/patient_details_screen.dart';
import '../constants/constants.dart';
import '../util.dart';

class CriticalPatientCard extends StatefulWidget {
  final Patient patient;

  const CriticalPatientCard({required this.patient});

  @override
  _CriticalPatientCardState createState() => _CriticalPatientCardState();
}

class _CriticalPatientCardState extends State<CriticalPatientCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PatientDetailsScreen(
                patientId: widget.patient.id,
              ),
            ),
          );
        });
      },
      child: Card(
        color: Colors.red,
        margin: EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          children: [
            ListTile(
              leading: CircleAvatar(
                radius: 21,
                child: Image.asset('assets/images/patient_icon.png'),
              ),
              title: Text(
                '${widget.patient.firstName} ${widget.patient.lastName}',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 17,
                  color: Colors.white,
                ),
              ),
              subtitle: Row(
                children: [
                  Text(
                    'Date of Birth: ',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  Text(
                    Util.getFormattedDate(
                            DateTime.tryParse(widget.patient.dateOfBirth ?? ''),
                            DateFormat('dd MMM, yyyy')) ??
                        '',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  )
                ],
              ),
              trailing: IconButton(
                icon: Icon(
                    _expanded ? Icons.arrow_drop_up : Icons.arrow_drop_down),
                color: Colors.white,
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
            SizedBox(height: 10,),
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
      _buildInfoItem(
          'Records:', (widget.patient.recordHistory?.length ?? 0).toString()),
      SizedBox(
        height: 10,
      ),
    ];
  }

  Widget _buildInfoItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 3.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 15,
            ),
          ),
          SizedBox(width: 6),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}
