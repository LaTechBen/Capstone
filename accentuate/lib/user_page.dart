import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:math';

class UserPage extends StatefulWidget {
  // uid id required to know whose profile to show.
  final String uid;
  const UserPage({super.key, required this.uid});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  var userData = {};
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await _firestore.collection('users').doc(widget.uid).get();

      var postSnap = await _firestore
          .collection('posts')
          .where('uid', isEqualTo: widget.uid)
          .get();

      userData = userSnap.data()!;

      setState(() {});
    } catch (e) {
      SnackBar(
        content: Text(e.toString()),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text(userData['username']),
              centerTitle: false,
            ),
            body: CircleAvatar(
              radius: 40,
              backgroundColor: Colors.pink,
              child: CircleAvatar(
                radius: 38,
                backgroundImage: userData['userProfImg'],
                backgroundColor: Colors.white,
                child: Text(userData['username'].substring(0, 2).toUpperCase(),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 40)),
              ),
            ),
          );
  }
}




// GridView.count(
//               crossAxisCount: 4,
//               mainAxisSpacing: 5.0,
//               crossAxisSpacing: 5.0,
//               children: List.generate(24, (index) {
//                 return InkWell(
//                     splashColor: Colors.transparent,
//                     highlightColor: Colors.transparent,
//                     child: Container(
//                       color: Colors
//                           .primaries[Random().nextInt(Colors.primaries.length)],
//                     ));
//               }),
//             ),
//           );