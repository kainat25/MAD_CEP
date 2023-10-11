import 'package:eventvista/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  int? selectedGender; // 0 for Male, 1 for Female

  void _saveProfile() {
    // Get the values from the controllers
    final String firstName = firstNameController.text;
    final String lastName = lastNameController.text;
    final String mobileNumber = mobileNumberController.text;
    final String dob = dobController.text;
    final String gender = selectedGender == 0 ? 'Male' : 'Female';

    // Validate the data (you can add more validation)
    if (firstName.isEmpty ||
        lastName.isEmpty ||
        mobileNumber.isEmpty ||
        dob.isEmpty ||
        selectedGender == null) {
      // Show a snackbar if any field is empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in all fields.',
              style: TextStyle(color: Colors.white)), // Your error message
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red, // Set the background color
        ),
      );
      return; // Return to exit the function and prevent further execution
    }

    // Continue with your logic if all fields are filled

    // Save the user information to Firestore
    FirebaseFirestore.instance.collection('users').add({
      'firstName': firstName,
      'lastName': lastName,
      'mobileNumber': mobileNumber,
      'dob': dob,
      'gender': gender,
    }).then((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }).catchError((error) {
      // Handle any errors that occur during data saving
      print('Error saving user data: $error');
      // Show an error message or snackbar to the user
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 39, 47, 82),
        title: Text('Enter your details',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30),
            // Replace TextFormFields with TextFields
            TextField(
              controller: firstNameController,
              decoration: InputDecoration(
                labelText: 'First Name',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
            ),
            SizedBox(height: 15),
            TextField(
              controller: lastNameController,
              decoration: InputDecoration(
                labelText: 'Last Name',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
            ),
            SizedBox(height: 15),
            TextField(
              controller: mobileNumberController,
              decoration: InputDecoration(
                labelText: 'Mobile Number',
                prefixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
            ),
            SizedBox(height: 15),
            TextField(
              controller: dobController,
              decoration: InputDecoration(
                labelText: 'Date of Birth',
                prefixIcon: Icon(Icons.calendar_today),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text('Gender:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            RadioListTile<int>(
              title: Text('Male'),
              value: 0,
              groupValue: selectedGender,
              onChanged: (int? value) {
                setState(() {
                  selectedGender = value;
                });
              },
            ),
            RadioListTile<int>(
              title: Text('Female'),
              value: 1,
              groupValue: selectedGender,
              onChanged: (int? value) {
                setState(() {
                  selectedGender = value;
                });
              },
            ),
            SizedBox(height: 20),
            Container(
              width: 160, // Adjust the width to fit within the available space
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 39, 47, 82),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
                onPressed: _saveProfile,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.save, color: Colors.white),
                    SizedBox(width: 4),
                    Text(
                      'Save Profile',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
