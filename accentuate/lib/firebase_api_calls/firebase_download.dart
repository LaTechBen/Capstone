import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_core/firebase_core.dart";
import "package:firebase_storage/firebase_storage.dart";
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

Future<void> downloadPosts() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseStorage storage = FirebaseStorage.instance;
  final cacheManager = DefaultCacheManager();

  var userSnap =
      await firestore.collection('users').doc(auth.currentUser!.uid).get();
  var userPostSnap = userSnap['posts'];
  for (DocumentSnapshot post in userPostSnap) {
    cacheManager.getSingleFile(post['PostUrl']);
  }

  
}
