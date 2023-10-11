import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventvista/home_screen.dart';
import 'package:eventvista/add_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as Path;

class AuthController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;

  var isloading = false.obs;

  void login({String? email, String? password, required BuildContext context}) {
    isloading(true);

    auth
        .signInWithEmailAndPassword(email: email!, password: password!)
        .then((value) {
      isloading(false);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }).catchError((e) {
      isloading(false);
      Get.snackbar("error", "$e");
    });
  }

  void signup(
      {String? email, String? password, required BuildContext context}) {
    isloading(true);

    auth
        .createUserWithEmailAndPassword(email: email!, password: password!)
        .then((value) {
      isloading(false);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => ProfileScreen()),
      );
    }).catchError((e) {
      isloading(false);
      print("error in authentication $e");
    });
  }

  var isProfileInformationLoading = false.obs;

  uploadProfileData(String firstName, String lastName, String mobileNumber,
      String dob, String gender, BuildContext context) {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    FirebaseFirestore.instance.collection('users').doc(uid).set({
      'first': firstName,
      'last': lastName,
      'dob': dob,
      'gender': gender
    }).then((value) {
      isProfileInformationLoading(false);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
      // Get.offAll(()=> BottomBarView());
    });
  }
}
