import 'package:accentuate/private_outfits.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:accentuate/components/my_button.dart';

class EditProfile extends StatefulWidget {
  final String? uid;
  const EditProfile({super.key, required this.uid});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

    gotoPrivateOutfits(){
     Navigator.push(context, MaterialPageRoute(builder: (context) => PrivateOutfits(uid: _auth.currentUser?.uid)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: SafeArea(
              child: Center(
                  child: Column(
            children: [
              const SizedBox(height: 10),

              MyButton(text: "Private Outfits", onTap: gotoPrivateOutfits)
          
            ],
          ))),
        ));
  }
}