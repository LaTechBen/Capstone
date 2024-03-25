import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseGet {
    final FirebaseFirestore _firebase = FirebaseFirestore.instance;
    final FirebaseStorage _storage = FirebaseStorage.instance;
    final FirebaseAuth _auth = FirebaseAuth.instance;

    // Future<List<String>> followers() async{
    //   User? getCurrentUser = _auth.currentUser;
    //   return null;
    // }
}