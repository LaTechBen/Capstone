import 'dart:developer';

import 'package:accentuate/classes/images.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseGet {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final FirebaseStorage _storage = FirebaseStorage.instance;
    final FirebaseAuth _auth = FirebaseAuth.instance;

    // Future<List<String>> followers() async{
    //   User? getCurrentUser = _auth.currentUser;
    //   return null;
    // }

    Future<QuerySnapshot<Map<String, dynamic>>> getPrivatePosts() async {

          var postSnap = await _firestore
          .collection('users')
          .doc(_auth.currentUser?.uid)
          .collection('outfits')
          .get();

          log(postSnap.toString());

          return postSnap;


    }
}