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
          content: Text('Please fill in all fields.'), // Your error message
          duration: Duration(
              seconds:
                  3), // Optional: How long the snackbar should be displayed
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
        title: Text('Enter your details'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(right: 100, left: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 50,
            ),
            TextFormField(
              controller: firstNameController,
              decoration: InputDecoration(labelText: 'First Name'),
            ),
            TextFormField(
              controller: lastNameController,
              decoration: InputDecoration(labelText: 'Last Name'),
            ),
            TextFormField(
              controller: mobileNumberController,
              decoration: InputDecoration(labelText: 'Mobile Number'),
            ),
            TextFormField(
              controller: dobController,
              decoration: InputDecoration(labelText: 'Date of Birth'),
            ),
            SizedBox(height: 16),
            Text('Gender:'),
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
            SizedBox(height: 16),
            Container(
              width: 400,
              height: 40,
              child: ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.white),
                  onPressed: _saveProfile,
                  child: Text(
                    'Save Profile',
                    style: TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(255, 14, 25, 72),
                        fontWeight: FontWeight.w500),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
