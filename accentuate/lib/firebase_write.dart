import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'classes/image.dart';

class Write {
  final FirebaseFirestore _firebase = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> storeImage(
      String childname, Uint8List file, bool isPost) async {
    Reference ref = _storage.ref().child(_auth.currentUser!.uid);

    if (isPost) {
      String id = const Uuid().v1();
      ref = ref.child(id);
    }

    UploadTask uploadTask = ref.putData(file);

    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<String> uploadImage(
      String description, Uint8List file, String uid, String username) async {
    String response = "Error occured";
    try {
      String photoUrl = await storeImage('posts', file, true);
      String postID = const Uuid().v1();

      Image img = Image(
          datePublished: DateTime.now(),
          description: description,
          likes: [],
          postID: postID,
          postUrl: photoUrl,
          uid: uid,
          username: username);

      _firebase.collection('posts').doc(postID).set(img.toJson());
      response = "Success!";
    } catch (error) {
      response = error.toString();
    }

    return response;
  }
}
