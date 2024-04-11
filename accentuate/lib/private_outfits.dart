import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'userPageImageDisplay.dart';

class PrivateOutfits extends StatefulWidget {
  final String? uid;
  const PrivateOutfits({super.key, required this.uid});
  
  @override
  State<PrivateOutfits> createState() => _PrivateOutfitsState();

}

class _PrivateOutfitsState extends State<PrivateOutfits> {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  getPrivateOutfits(){
    
  }

  gotoPrivateOutfits(BuildContext context){
    Navigator.push(context, MaterialPageRoute(builder: (context) => PrivateOutfits(uid: _auth.currentUser?.uid)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Private Outfits'),
        leading: null,
      ),
      body: Expanded(
                  child: FutureBuilder(
                    future: _firestore
                        .collection('users')
                        .doc(widget.uid)
                        .collection('outfits')
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