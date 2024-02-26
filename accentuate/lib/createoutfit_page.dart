import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'firebase_api_calls/firebase_write.dart';
import 'dart:io';
import 'dart:developer';

// Settings Screen UI, displays the SettingsList
class CreateOutfitPage extends StatefulWidget {
  const CreateOutfitPage({Key? key}) : super(key: key);

  @override
  State<CreateOutfitPage> createState() => _CreateOutfitPageState();
}

class _CreateOutfitPageState extends State<CreateOutfitPage> {
  final Write _write = Write();

  // final CreateOutfitButton _body =
  // const CreateOutfitButton(icon: Icons.person, text: 'Add Image From Gallery');

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  var userdata = {};

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    var userSnap =
        await _firestore.collection('users').doc(_auth.currentUser?.uid).get();
    userdata = userSnap.data()!;
  }

  File selectedImage = File('');

  final HomePage _homePage = HomePage();

  setGalleryImage() async {
    try {
      selectedImage = await _homePage.getImageFromGallery();

      // setState(() {});
    } catch (e) {
      log(e.toString());
    }
  }

  storeImage() async {
    await _write.uploadImage(
        '', selectedImage, _auth.currentUser!.uid, userdata['username'],
        isProfile: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Create Outfit'),
            SizedBox(width: 8),
            Icon(Icons.add),
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
            onPressed: () {
              // Add your onPressed logic here
              storeImage();
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                // Button Logic here
                setGalleryImage();
                /*
        if (text == 'Account Information') {
            Navigator.push(
            context, 
            MaterialPageRoute(builder: (context) => const AccountInfoPage()),
          );
        } */
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.person),
                    Text(
                      'Add Image From Gallery',
                      style: TextStyle(fontSize: 18),
                    ),
                    Opacity(opacity: 0, child: Icon(Icons.person)),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CreateOutfitBody extends StatefulWidget {
  const CreateOutfitBody({Key? key}) : super(key: key);

  @override
  State<CreateOutfitBody> createState() => _CreateOutfitBodyState();
}

class _CreateOutfitBodyState extends State<CreateOutfitBody> {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [],
      ),
    );
  }
}

class CreateOutfitButton extends StatefulWidget {
  final IconData icon;
  final String text;

  const CreateOutfitButton({super.key, required this.icon, required this.text});

  @override
  State<CreateOutfitButton> createState() => _CreateOutfitButtonState();
}

class _CreateOutfitButtonState extends State<CreateOutfitButton> {
  File selectedImage = File('');

  final HomePage _homePage = HomePage();

  setGalleryImage() async {
    try {
      selectedImage = await _homePage.getImageFromGallery();

      // setState(() {});
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Button Logic here
        setGalleryImage();
        /*
        if (text == 'Account Information') {
            Navigator.push(
            context, 
            MaterialPageRoute(builder: (context) => const AccountInfoPage()),
          );
        } */
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(widget.icon),
            Text(
              widget.text,
              style: const TextStyle(fontSize: 18),
            ),
            Opacity(opacity: 0, child: Icon(widget.icon)),
          ],
        ),
      ),
    );
  }
}
