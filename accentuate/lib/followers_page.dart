import 'dart:convert';
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

Future<List<String>> getUsernameFromUid(List<dynamic> uids) async {
  List<String> usernames = [];

  try {
    for (String uid in uids) {
      var docSnapshot = await _firebase.collection('users').doc(uid).get();
      if (docSnapshot.exists && docSnapshot.data() != null) {
        // Explicitly cast the username to a String and handle possible nulls
        var username = docSnapshot.data()!['username'] as String?;
        usernames.add(username ?? 'Unknown'); // Provide a default value for null or missing usernames
      } else {
        usernames.add('Unknown'); // Handle cases where the document doesn't exist
      }
      
    }
  } catch (e) {
    // Log the error or handle it as needed
    print('Error fetching usernames: $e');
    throw Exception('Failed to fetch usernames');
  }

  return usernames;
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(

  appBar: AppBar( 
    title: const Text('Followers'),
    centerTitle: true,
    backgroundColor: Colors.pink[100],),

body: StreamBuilder(
      stream: _firebase.collection('users').doc(widget.uid).snapshots(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data['followers'].length > 0) {
            var snap = snapshot.data;
            return ListView.builder(
              itemCount: snap['followers'].length,
              itemBuilder: (context, index) {
                return FutureBuilder(
                  future: getUsernameFromUid(snap['followers']),
                  builder: (context, AsyncSnapshot<List<String>> usernamesSnapshot) {
                    if (usernamesSnapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (usernamesSnapshot.hasData) {
                      print(usernamesSnapshot.data);
                      return ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(150),
                          child: Text(
                            usernamesSnapshot.data![index], style: TextStyle(fontSize: 24.0)// Access the specific username
                          )
                        ),
                      );
                    } else {
                      return Text("Error retrieving username", style: TextStyle(fontSize: 24.0));
                    }
                  },
                );
              }
            );
          } else if (snapshot.data['followers'].length == 0) {
            return const Text("There are no followers.", style: TextStyle(fontSize: 24.0));
          }
        }
        return const Center(child: CircularProgressIndicator());
      },
    ),
    );
  }
}