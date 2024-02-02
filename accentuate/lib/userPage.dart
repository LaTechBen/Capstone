import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'components/user_id.dart';
import 'components/post_card.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final imagePath = getStorage() + "/" + getID();

  // Stream<ListResult> listAllPaginated(Reference storageRef) async* {
  //   String? pageToken;
  //   do {
  //     final listResult = await storageRef.list(ListOptions(
  //       maxResults: 4,
  //       pageToken: pageToken,
  //     ));
  //     yield listResult;
  //     pageToken = listResult.nextPageToken;
  //   } while (pageToken != null);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
      stream: FirebaseFirestore.instance.collection('posts').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) => Container(
                  child: PostCard(
                    snap: snapshot.data!.docs[index].data(),
                  ),
                ));
      },
    ));
  }
}
