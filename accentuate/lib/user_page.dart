import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
// import 'dart:math';
import 'dart:developer';

class UserPage extends StatefulWidget {
  // uid id required to know whose profile to show.
  final String uid;
  const UserPage({super.key, required this.uid});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  var userData = {};
  int postLength = 0;
  num likes = 0;
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
          .collection('posts')
          .where('uid', isEqualTo: widget.uid)
          .get();

      userData = userSnap.data()!;
      postLength = postSnap.docs.length;
      followers = userSnap.data()!['followers'].length;
      following = userSnap.data()!['following'].length;
      isFollowing =
          userSnap.data()!['followers'].contains(_auth.currentUser!.uid);
      for (DocumentSnapshot post in postSnap.docs) {
        likes += post['likes'];
      }

      setState(() {});
    } catch (e) {
      log(e.toString());
    }

    setState(() {
      isLoading = false;
    });
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
              backgroundColor: Colors.pink,
              title: Text(
                testing ? 'Username' : userData['username'],
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            body: ListView(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 30, horizontal: 25),
                  alignment: Alignment.bottomCenter,
                  height: screenHeight * .2,
                  decoration: const BoxDecoration(color: Colors.pink),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            testing ? 'Username' : userData['username'],
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          //Followers
                          Text(
                            'followers: $followers',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                            ),
                          ),
                          //Following
                          Text(
                            'following: $following',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                            ),
                          ),
                          //Likes
                          Text(
                            'likes: $likes',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 40,
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.black,
                        radius: 40,
                        child: CircleAvatar(
                          backgroundColor: Colors.pinkAccent,
                          backgroundImage: userData['profImage'],
                          radius: 38,
                          child: Text(
                              testing
                                  ? 'US'
                                  : userData['username']
                                      .substring(0, 2)
                                      .toUpperCase(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 40)),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                Expanded(
                  child: FutureBuilder(
                    future: _firestore
                        .collection('posts')
                        .where('uid', isEqualTo: widget.uid)
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

                          return SizedBox(
                            child: Image(
                              image: NetworkImage(
                                snap['postUrl'],
                              ),
                              fit: BoxFit.cover,
                            ),
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
        