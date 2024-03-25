// import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import '../classes/image.dart';
import '../classes/user.dart' as UserData;

class Write {
  final FirebaseFirestore _firebase = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> storeImage(String childname, File file, bool isPost) async {
    Reference ref =
        _storage.ref().child(childname).child(_auth.currentUser!.uid);

    if (isPost) {
      String id = const Uuid().v1();
      ref = ref.child(id);
    }

    final uploadTask = ref.putFile(file);

    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<String> uploadImage(
      String description, File file, String uid, String username,
      {bool isProfile = false}) async {
    String response = "Error occured";
    try {
      String photoUrl;
      if (isProfile) {

        photoUrl = await storeImage('profiles', file, false);

        var userData = await _firebase.collection('users').doc(uid).get();

        UserData.User user = UserData.User(
          username: username,
          profileImage: photoUrl,
          following: userData['following'],
        );

        _firebase.collection('users').doc(uid).set(user.toJson());
      } else {
        photoUrl = await storeImage('posts', file, true);

        String postID = const Uuid().v1();

        Image img = Image(
          datePublished: DateTime.now(),
          description: description,
          likes: [],
          postID: postID,
          postUrl: photoUrl,
          uid: uid,
          username: username,
        );

        _firebase
            .collection('users')
            .doc(uid)
            .collection("posts")
            .doc(postID)
            .set(img.toJson());
      }
      response = "Success!";
    } catch (error) {
      response = error.toString();
    }

    return response;
  }
}
