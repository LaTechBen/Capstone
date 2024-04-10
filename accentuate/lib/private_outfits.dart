import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class _PrivateOutfits extends StatefulWidget {
  final String? uid;
  const _PrivateOutfits({super.key, required this.uid});
  
  @override
  State<_PrivateOutfits> createState() => __PrivateOutfitsState();

  getPrivateOutfits(){
    
  }
}

class __PrivateOutfitsState extends State<_PrivateOutfits> {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List of Lists of Images'),
      ),
      body: Expanded(
                  child: FutureBuilder(
                    future: _firestore
                        .collection('users')
                        .doc(widget.uid)
                        .collection('posts')
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return GridView.builder(
                        shrinkWrap: true,
                        itemCount: (snapshot.data! as dynamic).docs.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 1.5,
                          childAspectRatio: 1,
                        ),
                        itemBuilder: (context, index) {
                          DocumentSnapshot snap =
                              (snapshot.data! as dynamic).docs[index];

                          return GestureDetector(
                            child: SizedBox(
                              child: Image(
                                image: NetworkImage(
                                  snap['postUrl'],
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                            onTap: () => {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UserPageImageDisplay(
                                      imagePath: snap['postUrl']),
                                ),
                              ),
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
    );
  }
}