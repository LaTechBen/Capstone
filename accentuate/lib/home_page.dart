import 'dart:io';
import 'package:accentuate/components/my_image_grid.dart';
import 'package:accentuate/components/my_image_grid_page.dart';
import 'package:accentuate/components/my_image_list_page.dart';
import 'package:accentuate/createoutfit_page.dart';
import 'package:accentuate/firebase_api_calls/firebase_get_requests.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'firebase_api_calls/firebase_write.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'user_page.dart';

class HomePage extends StatefulWidget {
  // uid id required to know whose profile to show.
  final String? uid;
  const HomePage({super.key, required this.uid});

  @override
  _HomePageState createState() => _HomePageState();

  // Public method to delegate the call to _HomePageState's private method
  Future<File> getImageFromGallery() async {
    return await _HomePageState()._getImageFromGallery();
  }

  // Public method to open the camera app to take a picture
  Future<File> getImageFromCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      // You can use the picked file to display the image where you need.
      return File(pickedFile.path);
      // You can now use this imageFile to display the image.
    } else {
      return File('');
    }
  }
}

class _HomePageState extends State<HomePage> {
  var userData = {};

  bool isLoading = false;

  // Get a reference to storage root
  Reference referenceRoot = FirebaseStorage.instance.ref();

  TextEditingController _commentController = TextEditingController();

  // Initialize Firebase Storage reference
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseGet _get = FirebaseGet();
  final Write _write = Write();

  String currUsername = "";

  // Reference from the users post
  final postReference = FirebaseFirestore.instance
      .collection('users/St24OcPlw5ZlxP8YNVKGShzhQPp2/posts')
      .orderBy('time', descending: true);

  List<String> profileImages = [
    "images/1.jpg",
    "images/2.jpg",
    "images/3.jpg",
    "images/4.jpg",
    "images/5.jpg",
    "images/6.jpg",
    "images/7.jpg",
    "images/8.jpg",
    "images/9.jpg",
  ];
  List<String> posts = [
    "images/p1.jpg",
    "images/p2.jpg",
    "images/p3.jpg",
    "images/p4.jpg",
    "images/p5.jpg",
    "images/p6.jpg",
    "images/p7.jpg",
    "images/p8.jpg",
    "images/p9.jpg",
  ];


  updateLikes(bool isLike, Map<String, dynamic> post) async {
    try{
         Map<String, String> obj = {
         "uid": _auth.currentUser!.uid,
         "username": currUsername
         } ;
      _write.addOrRemoveLikeFromPost(!isLike, post, obj);
      setState(() {});
    } catch(e) {
      print("LIKES ERROR: " + e.toString());
    }
  }

  addComments(Map<String, dynamic> post, Map<String, String> comment){
    try{
      _write.addCommentFromPost(post, comment);
      _commentController.clear();
      setState(() {});
    } catch (e){
      print("COMMENTS ERROR" + e.toString());
    }
  }

  removeComments(Map<String, dynamic> post, Map<String, dynamic> comment) {
    try{
      _write.removeCommentFromPost(post, comment);
      setState(() {});
    } catch (e){
      print("REMOVE COMMENTS ERROR" + e.toString());

    }
  }
  /* ENDS HERE */

  Future<void> onRefresh() async {
    await Future.delayed(Duration(seconds: 3));

    // Fetch like counts and comments from Firestore
    setState(() {});
  }

  File? _selectedImage;

  Future<void> _requestPermissions() async {
    // Request permission to access the gallery
    var status = await Permission.photos.request();
    if (!status.isGranted) {
      // Handle permission denied scenario
      print('Permission denied to access gallery');
    }
  }

  Future<File> _getImageFromGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    return File(returnedImage!.path);
  }

  @override
  void initState() {
    super.initState();
    // Set the initial value of imageUrl to an empty string
    imageUrl = '';
    postUrls = [];
    userUrls = [];
    followingList = [];
    imgUrls = [];
    descriptions = [];
    followingPostsList = [];

    // Retrieve the image from Firebase Storage
    getImageUrl();
    // Fetch like counts and comments from Firestore
    fetchLikeCountsAndComments();
  }

  // Method to fetch like counts and comments from Firestore
  void fetchLikeCountsAndComments() async {
    try {
      List<Map<String, dynamic>> followingPosts2 = await _get.getFollowingPosts();
      followingPostsList.addAll(followingPosts2);
      print(followingPostsList);

      var snaps = await _firestore.collection('users').doc(_auth.currentUser!.uid).get();
      currUsername = (snaps.data()!['username']);

      //print(followingPostsList);
      // Update the UI to reflect the changes
      setState(() {});
    } catch (e) {
      print('Error fetching like counts and comments: $e');
    }
  }

  late List<dynamic> postUrls;

  late List<String> followingList;

  late List<String> userUrls;

  late List<String> imgUrls;

  late List<String> descriptions;

  late List<Map<String, dynamic>> followingPostsList;

  Future<void> getImageUrl() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Get the current user's document reference
      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('users').doc(widget.uid);

      // Get the reference to the users collection
      CollectionReference userRef =
          FirebaseFirestore.instance.collection('users');

      // Retrieve all the documents within the collection
      QuerySnapshot userSnapshot = await userRef.get();

      // Get the current user's document
      DocumentSnapshot userDoc = await userDocRef.get();

      // Get the list of users that the current user is following
      List<String> followingUsers = List<String>.from(userDoc.get('following'));

      //print("Following Users: $followingUsers");

      // List to store post URLs
      List<dynamic> urls = [];

      // List to store the user's profile image and user names
      List<String> profileImgs = [];

      List<String> userNames = [];

      List<String> postDescs = [];

      List<String> followersL = [];

      // Iterate through each user that the current user is following
      for (String userId in followingUsers) {
        // Get reference to the Firestore collection of posts of the following user
        CollectionReference postsCollection =
            FirebaseFirestore.instance.collection('users/$userId/posts');

        //print("postsCollection: $postsCollection");

        // Get documents from the posts collection
        QuerySnapshot postsSnapshot = await postsCollection.get();
        // Extract post URLs from the documents of the following user
        List<List<dynamic>> userUrls = postsSnapshot.docs.map((doc) {
          return doc['postUrl'] as List<dynamic>;
        }).toList();
        // Extract username URLs from the documents of the following user
        List<String> usernameUrls = postsSnapshot.docs.map((doc) {
          return doc['username'] as String;
        }).toList();

        List<String> descs = postsSnapshot.docs.map((doc) {
          return doc['description'] as String;
        }).toList();

        List<String> followingAccounts = postsSnapshot.docs.map((doc) {
          return doc['uid'] as String;
        }).toList();

        List<String> profilePic = userSnapshot.docs.map((doc) {
          return doc['profileImage'] as String;
        }).toList();

        //print(descs);

        urls.addAll(userUrls);

        userNames.addAll(usernameUrls);

        postDescs.addAll(descs);

        followersL.addAll(followingAccounts);

        profileImgs.addAll(profilePic);
        //print(urls);
        //print(followersL);
        //print(userNames);
        //List<String> profileImgUrls = postsSnapshot.docs.map().toList();
      }

      setState(() {
        postUrls = urls;
        userUrls = userNames;
        imgUrls = profileImgs;
        descriptions = postDescs;
        followingList = followersL;
        isLoading = false;
        //print("Post Urls: $postUrls");
      });
    } catch (e) {
      print('Error getting image URLs: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  late String imageUrl = '';
  late String profileUrl = '';
  final storage = FirebaseStorage.instance;

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              title: Image.asset(
                "images/smallapplogo.png",
                height: 70,
              ),
              leading: null,
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateOutfitPage()),
                    );
                  },
                  icon: const Icon(Icons.add_circle_outline),
                ),

              ],
            ),
            body: RefreshIndicator(
              onRefresh: onRefresh,
              child: SingleChildScrollView(
                child: Column(children: [
                  /* IMAGES FROM FIREBASE */

                  Divider(),
                  Column(
                    children: List.generate(
                      followingPostsList.length,
                      (index) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //Header post
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                child: CircleAvatar(
                                  radius: 14,
                                  backgroundImage: AssetImage(
                                    "images/story.png",
                                  ),
                                  child: CircleAvatar(
                                    radius: 12,
                                    backgroundImage: NetworkImage(imgUrls[
                                        index]), //AssetImage("images/test.jpg"
                                    //     //profileImages[index],
                                    //     ),
                                  ),
                                ),
                              ),
                              Text(
                                followingPostsList[index]['username'],
                                //userData['username'],
                              ),
                              Spacer(),

                            ],
                          ),
                          ImageGridDisplay(
                              imageUrls: followingPostsList[index]['postUrl'] as List<dynamic>,
                              onImageClicked: (int i) => {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ImageListPage(
                                          imageUrls: followingPostsList[index]['postUrl'],
                                          description: followingPostsList[index]['description'],
                                        ),
                                      ),
                                    ),
                                  },
                              onExpandClicked: () => {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ImageListPage(
                                          imageUrls: followingPostsList[index]['postUrl'],
                                          description: followingPostsList[index]['description'],
                                        ),
                                      ),
                                    ),
                                  },
                              maxImages: 1),
                          // Footer Post
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  print((followingPostsList[index]['likes'] as List<dynamic>).any((item) => item['uid'] == _auth.currentUser!.uid));
                                  updateLikes((followingPostsList[index]['likes'] as List<dynamic>).any((item) => item['uid'] == _auth.currentUser!.uid), followingPostsList[index]);
                                },
                                icon: Icon(
                                  (followingPostsList[index]['likes'] as List<dynamic>).any((item) => item['uid'] == _auth.currentUser!.uid)
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  // Update the color based on the isLiked state
                                  color: (followingPostsList[index]['likes'] as List<dynamic>).any((item) => item['uid'] == _auth.currentUser!.uid) ? Colors.red : null,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  // Open a dialog to add a comment
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Add Comment'),
                                        content: TextField(
                                          controller: _commentController,
                                          decoration: InputDecoration(
                                            hintText: 'Enter your comment',
                                          ),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              // Handle adding a comment
                                              String comm = _commentController.text;
                                              print(comm);
                                              if(comm.isNull || comm.isEmpty){
                                                const snackbar = SnackBar(content: Text("Please leave a comment before adding."));
                                                ScaffoldMessenger.of(context).showSnackBar(snackbar);
                                              }
                                              else{
                                              Map<String, String> obj = {
                                                  "comment": comm,
                                                  "uid": _auth.currentUser!.uid,
                                                  "username": currUsername
                                                } ;
                                                addComments(followingPostsList[index], obj);
                                                Navigator.of(context).pop();
                                              }
                                            },
                                            child: Text('Add'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                icon: Icon(Icons.comment_rounded),
                              ),
                            ],
                          ),

                          Container(
                            padding: EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  text: TextSpan(
                                      style: TextStyle(color: Colors.black),
                                      children: [
                                        TextSpan(text: "Liked by"),
                                        TextSpan(
                                          text: (followingPostsList[index]['likes'] as List).length == 0
                                              ? " no one."
                                              : (followingPostsList[index]['likes'] as List).length == 1

                                              ? " ${followingPostsList[index]['likes'][0]['username']}" :" ${followingPostsList[index]['likes'][0]['username']}" + " and " + "${(followingPostsList[index]['likes'] as List).length - 1}" + " other(s)",
                                          
                                )
                                ]),
                                ),
                                
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: ((followingPostsList[index]['comments'] as List<dynamic>))
                                      .map((commentText) {
                                    return Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 4),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                RichText(
                                                  text: TextSpan(
                                                    style: DefaultTextStyle.of(
                                                            context)
                                                        .style,
                                                    children: [
                                                      TextSpan(
                                                        text: commentText[
                                                            'username'], // Assuming "Profile name" is the user name
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      TextSpan(
                                                          text:
                                                              ' '), // Add space between user name and comment
                                                      TextSpan(
                                                          text: commentText['comment']),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: 
                                            commentText['uid'] == _auth.currentUser!.uid ?
                                            TextButton(
                                              onPressed: () {
                                                // Call a function to delete the comment
                                                if(commentText['uid'] == _auth.currentUser!.uid){
                                                  removeComments(followingPostsList[index], commentText);
                                                }
                                              },
                                              child: Text(
                                                'Delete',
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ),
                                            ) : Text(""),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  /* END HERE */
                ]),
              ),
            ),
          );
  }

  getApplicationDocumentsDirectory() {}
}
