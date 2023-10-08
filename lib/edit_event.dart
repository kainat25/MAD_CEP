import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditEvent extends StatefulWidget {
  final String eventId;

  EditEvent({required this.eventId});

  @override
  _EditEventState createState() => _EditEventState();
}

class _EditEventState extends State<EditEvent> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadEventData();
  }

  void _loadEventData() {
    FirebaseFirestore.instance
        .collection('events')
        .doc(widget.eventId)
        .get()
        .then((eventDoc) {
      if (eventDoc.exists) {
        final eventData = eventDoc.data() as Map<String, dynamic>;
        setState(() {
          _titleController.text = eventData['title'];
          _descriptionController.text = eventData['description'];
          _dateController.text = eventData['date'];
          _timeController.text = eventData['time'];
          _locationController.text = eventData['location'];
        });
      }
    });
  }

  void _saveEventChanges() {
    final String updatedTitle = _titleController.text;
    final String updatedDescription = _descriptionController.text;
    final String updatedDate = _dateController.text;
    final String updatedTime = _timeController.text;
    final String updatedLocation = _locationController.text;

    FirebaseFirestore.instance.collection('events').doc(widget.eventId).update({
      'title': updatedTitle,
      'description': updatedDescription,
      'date': updatedDate,
      'time': updatedTime,
      'location': updatedLocation,
    }).then((_) {
      Navigator.pop(context);
    }).catchError((error) {
      print('Error updating event: $error');
      // Handle errors, e.g., show a snackbar
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 39, 47, 82),
        title: Text('Edit Event'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Event Title'),
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Event Description'),
              ),
              TextFormField(
                controller: _dateController,
                decoration: InputDecoration(labelText: 'Date'),
              ),
              TextFormField(
                controller: _timeController,
                decoration: InputDecoration(labelText: 'Time'),
              ),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(labelText: 'Location'),
              ),
              SizedBox(
                  height: screenHeight *
                      0.02), // Adjust spacing based on screen height
              Container(
                width: screenWidth * 0.4,
                height: screenHeight * 0.05,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  onPressed: _saveEventChanges,
                  child: Text(
                    'Save Changes',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 14, 25, 72),
                    ),
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
