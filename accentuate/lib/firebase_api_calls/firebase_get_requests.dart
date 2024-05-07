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

  Future<List<Map<String, dynamic>>> getFollowingPosts() async {
    var followingList =
        await _firestore.collection('users').doc(_auth.currentUser!.uid).get();

    var followings = (followingList.data()!['following']);
    List<Map<String, dynamic>> list = [];

    for (String followee in followings) {
      var followingPosts = await _firestore
          .collection('users')
          .doc(followee)
          .collection('posts')
          .get();

      followingPosts.docs.forEach((e) => list.add(e.data()));
    }
    return (list);
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    var usersList = await _firestore.collection('users').get();
    List<Map<String, dynamic>> list = [];

    // Loop through each document in the query
    usersList.docs.forEach((doc) {
      // Convert each document snapshot to a Map
      Map<String, dynamic> userData = doc.data();
      // Add the Map to the list
      list.add(userData);
    });
    return (list);
  }
}
