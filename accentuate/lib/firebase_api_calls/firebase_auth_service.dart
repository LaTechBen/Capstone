import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:uuid/uuid.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebase = FirebaseFirestore.instance;

  Future<User?> signUpWithEmailAndPassword(String email, String password, String username) async {
    String postID = const Uuid().v1();
    try{
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      await _auth.currentUser?.sendEmailVerification().then((value) => {
        _firebase.collection('users').doc(credential.user?.uid).set({
          "username": username,
          "following": []
        })
      });
      return credential.user;
    } catch (e){
      log(e.toString());
    }
    return null;
  }

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try{
      UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } catch (e) {
      log("Error! " + e.toString());
    }
    return null;
  }

  Future forgotPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch(e) {
      log(e.toString());
    }
  }
}