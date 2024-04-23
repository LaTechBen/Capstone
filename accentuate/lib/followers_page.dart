import 'dart:developer';

import 'package:accentuate/user_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:string_similarity/string_similarity.dart';

class FollowersPage extends StatefulWidget {
  final String? uid;
  const FollowersPage({super.key, required this.uid});

  @override
  State<FollowersPage> createState() => _FollowersPageState();
}

class _FollowersPageState extends State<FollowersPage> {
  final FirebaseFirestore _firebase = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
    Future<List<DocumentSnapshot>>? _searchUserResults;

Future<List<DocumentSnapshot>> getUsers(String query) async {
    final snapshot = await _firebase.collection('users').get();
    List<DocumentSnapshot> users = snapshot.docs;

    // Handle Null Case for Users and Weight
    if (query.isNotEmpty) {
      users = users.where((user) {
        var username = (user.data() as Map<String, dynamic>)['username'];
        double score = _calculateRelevanceScore(username ?? '', query); // Handle null username
        return score > 0.5; // You can adjust the threshold as needed
      }).toList();
    }

    // Limit Results to 25 'users'
    return users.take(25).toList();
  }

    double _calculateRelevanceScore(String text, String query) {
    return text.similarityTo(query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

  appBar: AppBar( 
    title: const Text('Followers'),
    centerTitle: true,
    backgroundColor: Colors.pink[100],),

   body:  StreamBuilder(
     stream: _firebase.collection('users').doc(widget.uid).snapshots(),
     builder: (context,AsyncSnapshot snapshot) {
       if(snapshot.hasData) {
        print(snapshot.data['followers'].toString());
         if(snapshot.data['followers'].length > 0) {
           var snap = snapshot.data;
           return ListView.builder(
             itemCount: snap['followers'].length,
             itemBuilder: (context,index) {
               var snaps = snapshot.data['followers'];
                return ListTile(
                  leading: ClipRRect(
                      borderRadius: BorderRadius.circular(150),
                      child: Text(
                        snaps[index]
                      ),
                    ),

                );
             });
         }
         else if(snapshot.data['followers'].length == 0){
          return const Text("There are no followers.");
         }
       } return Center(child: CircularProgressIndicator(),);
     },
   ),
    );
  }
}