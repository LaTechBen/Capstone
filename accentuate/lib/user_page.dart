import 'package:accentuate/edit_profile_page.dart';
import 'package:accentuate/private_outfits.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'dart:developer';
import 'userPageImageDisplay.dart';
import 'package:cached_network_image/cached_network_image.dart';

class UserPage extends StatefulWidget {
  // uid id required to know whose profile to show.
  final String? uid;
  const UserPage({super.key, required this.uid});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  var userData = {};
  var userProfile = {};
  var profImage;
  int postLength = 0;
  int likes = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;
  bool testing = false;
  double screenWidth = 0;
  double screenHeight = 0;

  @override
  void initState() {
    super.initState();
    if (widget.uid == '0') {
      setState(
        () {
          testing = true;
        },
      );
    } else {
      getData();
    }
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await _firestore.collection('users').doc(widget.uid).get();

      var postSnap = await _firestore
          .collection('users')
          .doc(widget.uid)
          .collection('posts')
          .get();

      userData = userSnap.data()!;
      postLength = postSnap.docs.length;
      followers = userSnap.data()!['followers'].length;
      following = userSnap.data()!['following'].length;
      isFollowing =
          userSnap.data()!['followers'].contains(_auth.currentUser!.uid);
      for (DocumentSnapshot post in postSnap.docs) {
        int postLikes = post['likes'].length;
        likes += postLikes;
      }

      setState(() {});
    } catch (e) {
      log(e.toString());
    }

    setState(() {
      isLoading = false;
    });
  }


  gotoPrivateOutfits(BuildContext context){
    Navigator.push(context, MaterialPageRoute(builder: (context) => PrivateOutfits(uid: _auth.currentUser?.uid)));
  }

  gotoEditProfile(BuildContext context){
     Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfile(uid: _auth.currentUser?.uid)));
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: const Color.fromARGB(255, 233, 30, 99),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    testing ? 'Username' : userData['username'],
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  widget.uid == _auth.currentUser?.uid
                      ? Container(
                          padding: const EdgeInsets.only(top: 2),
                          child: Container(
                            height: 36,
                            width: 120,
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                ),
                                borderRadius: BorderRadius.circular(5)),
                            child: TextButton(
                              onPressed: () => gotoPrivateOutfits(context),
                              child: const Text(
                                'Private Outfits',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        )
                      : isFollowing
                          ? Container(
                              padding: const EdgeInsets.only(top: 2),
                              child: Container(
                                height: 36,
                                width: 120,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black,
                                    ),
                                    borderRadius: BorderRadius.circular(5)),
                                child: TextButton(
                                  onPressed: () => setState(
                                    () {
                                      isFollowing = !isFollowing;
                                    },
                                  ),
                                  child: const Text(
                                    'Unfollow',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Container(
                              padding: const EdgeInsets.only(top: 2),
                              child: Container(
                                height: 36,
                                width: 120,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Colors.white,
                                    ),
                                    borderRadius: BorderRadius.circular(5)),
                                child: TextButton(
                                  onPressed: () => setState(
                                    () {
                                      isFollowing = !isFollowing;
                                    },
                                  ),
                                  child: const Text(
                                    'Follow',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                ],
              ),
              leading: null,
            ),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.black,
                            radius: 40,
                            child: CircleAvatar(
                                backgroundColor: Colors.pinkAccent,
                                backgroundImage:
                                    NetworkImage(userData['profileImage']),
                                radius: 38,
                                child: userData['profileImage'] == Null
                                    ? Text(
                                        userData['username']
                                            .substring(0, 2)
                                            .toUpperCase(),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 40))
                                    : const Text("")),
                          ),
                          statColumn(followers, 'Followers'),
                          statColumn(postLength, 'Posts'),
                          statColumn(likes, 'Likes'),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(),
                Expanded(
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
              ],
            ),
          );
  }

  Column statColumn(int stat, String statLabel) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          NumberFormat.compact().format(stat),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        //Followers
        Container(
          margin: const EdgeInsets.only(top: 5),
          child: Text(
            statLabel,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
    
    
    
    
    
    
//     return isLoading
//         ? const Center(
//             child: CircularProgressIndicator(),
//           )
//         : Scaffold(
//             appBar: AppBar(
//               toolbarHeight: MediaQuery.of(context).size.height * .2,
//               flexibleSpace: SizedBox(
//                 child: Row(
//                   children: [
//                     Container(
//                       child: Column(
//                         children: [
//                           Flexible(
//                             child: Align(
//                               alignment: Alignment.centerRight,
//                               child: Text(
//                                 testing ? 'Username' : userData['username'],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Flexible(
//                       child: Align(
//                         alignment: Alignment.center,
//                         child: CircleAvatar(
//                           radius: 40,
//                           backgroundColor: Colors.pink,
//                           child: CircleAvatar(
//                             radius: 38,
//                             backgroundImage: userData['userProfImg'],
//                             backgroundColor: Colors.white,
//                             child: Text(
//                                 testing
//                                     ? 'US'
//                                     : userData['username']
//                                         .substring(0, 2)
//                                         .toUpperCase(),
//                                 style: const TextStyle(
//                                     fontWeight: FontWeight.bold, fontSize: 40)),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             body: GridView.builder(
//               scrollDirection: Axis.vertical,
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 4,
//                 mainAxisSpacing: 2.0,
//                 crossAxisSpacing: 2.0,
//               ),
//               itemCount: testing ? 25 : postLength,
//               itemBuilder: (context, index) {
//                 return Padding(
//                   padding: const EdgeInsets.all(1.0),
//                   child: Container(
//                     color: Colors.blue, // color of grid items
//                     child: Center(
//                       child: Text(
//                         index.toString(),
//                         style: const TextStyle(
//                             fontSize: 18.0, color: Colors.white),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           );
//   }
// }




// Column(
//       children: [
//         Container(
//           height: MediaQuery.of(context).size.height * .2,
//           decoration: const BoxDecoration(
//             border: Border(
//               bottom: BorderSide(
//                 color: Colors.black,
//               ),
//             ),
//           ),
//           child: Row(
//             children: [
//               Text(
//                 testing ? 'Username' : userData['username'],
//                 style: const TextStyle(
//                   fontSize: 20,
//                   color: Colors.black,
//                 ),
//               ),
//               Flexible(
//                 child: Align(
//                   alignment: Alignment.centerRight,
//                   child: CircleAvatar(
//                     radius: 40,
//                     backgroundColor: Colors.pink,
//                     child: CircleAvatar(
//                       radius: 38,
//                       backgroundImage: userData['userProfImg'],
//                       backgroundColor: Colors.white,
//                       child: Text(
//                           testing
//                               ? 'US'
//                               : userData['username']
//                                   .substring(0, 2)
//                                   .toUpperCase(),
//                           style: const TextStyle(
//                               fontWeight: FontWeight.bold, fontSize: 40)),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         const Padding(
//           padding: EdgeInsets.all(
//             1.0,
//           ),
//         ),
        