import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:accentuate/home_page.dart';
import 'dart:io';
import 'dart:developer';
import 'firebase_api_calls/firebase_write.dart';

void main() {
  runApp(MyApp());
}

// Initializes and runs the app
// Will change this to be integrated with main.dart
// For now It is used to only run the 'accountinfo_page.dart' for testing purposes
class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Account Information',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: const AccountInfoPage(),
    );
  }
}

// Account Info Screen UI, displays the AccountInfoList
class AccountInfoPage extends StatefulWidget {
  const AccountInfoPage({Key? key}) : super(key: key);

  @override
  State<AccountInfoPage> createState() => _AccountInfoPageState();
}

class _AccountInfoPageState extends State<AccountInfoPage> {
  File selectedImage = File('');
  final Write _write = Write();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebase = FirebaseFirestore.instance;
  final HomePage _homePage = HomePage();
  var userdata = {};

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    var userSnap =
        await _firebase.collection('users').doc(_auth.currentUser?.uid).get();
    userdata = userSnap.data()!;
  }

  setCameraImage() async {
    try {
      selectedImage = await _homePage.getImageFromCamera();

      setState(() {});
    } catch (e) {
      log(e.toString());
    }
  }

  setGalleryImage() async {
    try {
      selectedImage = await _homePage.getImageFromGallery();

      setState(() {});
    } catch (e) {
      log(e.toString());
    }
  }

  storeImage(context) async {
    await _write.uploadImage(
        '', selectedImage, _auth.currentUser!.uid, userdata['username'],
        isProfile: true);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Account Information'),
            SizedBox(width: 8),
            Icon(Icons.person),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_outlined),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            // Insert Confirm Page Logic Here
            onPressed: () {
              storeImage(context);
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 80,
              backgroundImage:
                  selectedImage != File('') ? FileImage(selectedImage) : null,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    var status = await Permission.camera.status;
                    if (status.isDenied) {
                      Permission.camera.request();
                    } else if (status.isGranted) {
                      // upload logic
                      setCameraImage();
                    }
                  },
                  child: const Text('Take Picture'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    var status = await Permission.manageExternalStorage.status;
                    if (status.isDenied) {
                      Permission.manageExternalStorage.request();
                    } else if (status.isGranted) {
                      // open storage
                      setGalleryImage();
                    }
                  },
                  child: const Text('Upload from Gallery'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
