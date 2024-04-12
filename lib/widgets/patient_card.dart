import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mapd722_mobile_web_development/models/patient.dart';
import 'package:mapd722_mobile_web_development/screens/patient_details_screen.dart';
import '../util.dart';

class PatientCard extends StatefulWidget {
  final Patient patient;

  const PatientCard({super.key, required this.patient});

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
              builder: (context) => PatientDetailsScreen(
                patientId: widget.patient.id,
              ),
            ),
          );
        });
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          children: [
            ListTile(
              leading: CircleAvatar(
                radius: 21,
                child: Image.asset('assets/images/patient_icon.png'),
              ),
              title: Text(
                '${widget.patient.firstName} ${widget.patient.lastName}',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 17,
                ),
              ),
              subtitle: Row(
                children: [
                  const Text(
                    'Date of Birth: ',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    width: 3,
                  ),
                  Text(
                    Util.getFormattedDate(
                        DateTime.tryParse(widget.patient.dateOfBirth ?? ''),
                        DateFormat('dd MMM, yyyy')) ??
                        '',
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 15,
                    ),
                  )
                ],
              ),
              trailing: IconButton(
                icon: Icon(
                    _expanded ? Icons.arrow_drop_up : Icons.arrow_drop_down),
                color: Colors.black87,
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
            const SizedBox(height: 10,),
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
      const SizedBox(
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
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 15,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black87, fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}
