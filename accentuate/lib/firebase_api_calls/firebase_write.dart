import 'dart:developer';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../classes/image.dart';
import '../classes/images.dart';
import '../classes/user.dart' as UserData;

class Write {
  final FirebaseFirestore _firebase = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Update Function
  Future<void> updateExistingDocuments(String uid) async {
    try {
      // Retrieve all documents from the collection
      QuerySnapshot querySnapshot = (await _firebase
          .collection('users')
          .doc(uid)
          .get()) as QuerySnapshot<Object?>;

      // Iterate through each document and update it
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        var docData = doc.data() as Map<String, dynamic>;
        // Check if the document already has the 'comments' field
        if (docData != null && docData.containsKey('comments')) {
          // Update the document to add the 'comments' field
          await _firebase.collection('users').doc(doc.id).update({
            'comments': [], // You can set an empty array or any initial value
          });
        }
      }

      print('Updated documents successfully.');
    } catch (e) {
      print('Error updating documents: $e');
    }
  }

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

  Future<List<String>> storeImages(List<File> files, bool isPost) async {
    Reference ref;
    if (isPost) {
      ref = _storage.ref().child('posts').child(_auth.currentUser!.uid);
    } else {
      ref = _storage.ref().child('outfits').child(_auth.currentUser!.uid);
    }

    List<String> fileUrls = [];

    try {
      for (File file in files) {
        String id = const Uuid().v1();
        ref = ref.child(id);
        final uploadTask = ref.putFile(file);
        TaskSnapshot snapshot = await uploadTask;
        String downloadUrl = await snapshot.ref.getDownloadURL();
        fileUrls.add(downloadUrl);
      }
    } catch (error) {
      throw Exception("There was a problem with storing the images.");
    }
    return fileUrls;
  }

  Future<String> uploadImage(
      String description, File file, String uid, String username,
      {bool isProfile = false}) async {
    String response = "Error occured";
    try {
      String photoUrl;
      if (isProfile) {
        //   var profileData = await _firebase
        //     .collection('users')
        //     .doc(uid)
        //     .collection('profile-image')
        //     .get();

        // for (DocumentSnapshot snap in profileData.docs) {
        //   snap.reference.delete();
        // }

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
          comments: [],
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

  Future<String> storeOutfit(File file, bool isPost) async {
    Reference ref;
    if(isPost){
    ref = _storage.ref().child('posts').child(_auth.currentUser!.uid);
    }
    else{
      ref = _storage.ref().child('outfits').child(_auth.currentUser!.uid);
    }

  String downloadUrl = "didnt save";
    try{
        String id = const Uuid().v1();
        ref = ref.child(id);
        final uploadTask = ref.putFile(file);
        TaskSnapshot snapshot = await uploadTask;
        String downloadUrl = await snapshot.ref.getDownloadURL();
        return downloadUrl;
    }
    catch (error){
      throw Exception("There was a problem with storing the outfit.");
    }
  }

  Future<String> uploadOutfit(File image, bool isPost, String uid, String username, String description) async {
    String response = "Error occured";

    try {
      String photoUrl;

        photoUrl = await storeOutfit(image, isPost);

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
        if(isPost){
          _firebase
            .collection('users')
            .doc(uid)
            .collection("posts")
            .doc(postID)
            .set(img.toJson());
        }
        else{
          _firebase
            .collection('users')
            .doc(uid)
            .collection("outfits")
            .doc(postID)
            .set(img.toJson());
        }
      
      response = "Success!";
    } catch (error) {
      response = error.toString();
    }
    log(response);
    return response;
  
  }

  Future<String> uploadImages(List<File> images, bool isPost, String uid, String username, String description) async {
    String response = "Error occured";

    try {
      List<String> photoUrl;

      photoUrl = await storeImages(images, false);

      String postID = const Uuid().v1();

      Images img = Images(
        datePublished: DateTime.now(),
        description: description,
        likes: [],
        comments: [],
        postID: postID,
        postUrl: photoUrl,
        uid: uid,
        username: username,
      );
      if (isPost) {
        _firebase
            .collection('users')
            .doc(uid)
            .collection("posts")
            .doc(postID)
            .set(img.toJson());
      } else {
        _firebase
            .collection('users')
            .doc(uid)
            .collection("outfits")
            .doc(postID)
            .set(img.toJson());
      }

      response = "Success!";
    } catch (error) {
      response = error.toString();
    }
    return response;
  }

  deletePost(String uid, DocumentSnapshot image, String location){
    try {
    _firebase.collection('users')
    .doc(uid)
    .collection(location)
    .doc(image["postID"])
    .delete();

    } catch (error) {
      log(error.toString());
    }
  }

  moveOutfitToPublicOrPrivate(String uid, DocumentSnapshot image, String previousLocation, String newLocation){
    Timestamp timestamp = image["datePublished"];
    DateTime time = timestamp.toDate();
    Image newImage = Image(datePublished: time, description: image["description"] , likes: image["likes"], postID: image["postID"], postUrl: image["postUrl"], uid: image["uid"], username: image["username"]);
    try {
    _firebase.collection('users')
    .doc(uid)
    .collection(previousLocation)
    .doc(image["postID"])
    .delete();

    String postID = const Uuid().v1();
    _firebase.collection('users')
    .doc(uid)
    .collection(newLocation)
    .doc(postID)
    .set(newImage.toJson());

    } catch (error) {
      log(error.toString());
    }
  }
}
