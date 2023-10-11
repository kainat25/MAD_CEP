import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventCreation extends StatefulWidget {
  @override
  _EventCreationState createState() => _EventCreationState();
}

class _EventCreationState extends State<EventCreation> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != _selectedDate)
      setState(() {
        _selectedDate = pickedDate;
      });
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (pickedTime != null && pickedTime != _selectedTime)
      setState(() {
        _selectedTime = pickedTime;
      });
  }

  void _saveEvent() {
    // Get the values from the text controllers
    final String eventTitle = _titleController.text;
    final String eventDescription = _descriptionController.text;
    final DateTime eventDate = _selectedDate;
    final TimeOfDay eventTime = _selectedTime;
    final String eventLocation = _locationController.text;

    // Validate the data (you can add more validation)
    if (eventTitle.isEmpty ||
        eventDescription.isEmpty ||
        eventLocation.isEmpty) {
      // Show a snackbar if any required field is empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Please fill in all required fields.'), // Your error message
          duration: Duration(
              seconds:
                  3), // Optional: How long the snackbar should be displayed
        ),
      );
      return; // Return to exit the function and prevent further execution
    }

    // Combine the date and time into a single DateTime
    final DateTime eventDateTime = DateTime(
      eventDate.year,
      eventDate.month,
      eventDate.day,
      eventTime.hour,
      eventTime.minute,
    );

    // Convert the combined DateTime to a Firestore timestamp
    final Timestamp eventTimestamp = Timestamp.fromDate(eventDateTime);

    // Save the event information to Firestore
    FirebaseFirestore.instance.collection('events').add({
      'title': eventTitle,
      'description': eventDescription,
      'date_time': eventTimestamp,
      'location': eventLocation,
    }).then((_) {
      // Navigate back or perform other actions as needed
      Navigator.pop(context);
    }).catchError((error) {
      // Handle any errors that occur during data saving
      print('Error creating event: $error');
      // Show an error message or snackbar to the user
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 39, 47, 82),
        title: Text('Create Event'),
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
              InkWell(
                onTap: () => _selectDate(context),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Event Date',
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "${_selectedDate.toLocal()}".split(' ')[0],
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () => _selectTime(context),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Event Time',
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "${_selectedTime.format(context)}",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Icon(Icons.access_time),
                    ],
                  ),
                ),
              ),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(labelText: 'Event Location'),
              ),
              SizedBox(height: 16),
              Container(
                width: screenWidth * 0.4,
                height: screenHeight * 0.05,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  onPressed: _saveEvent,
                  child: Text(
                    'Create Event',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color.fromARGB(255, 14, 25, 72),
                      fontWeight: FontWeight.w500,
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
