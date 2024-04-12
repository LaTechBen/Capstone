import 'dart:io';
import 'package:accentuate/createoutfit_page.dart';
import 'package:flutter/material.dart';
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
  bool isLoading = false;

  // Get a reference to storage root
  Reference referenceRoot = FirebaseStorage.instance.ref();

  // Initialize Firebase Storage reference
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Reference from the users post
  final postReference = FirebaseFirestore.instance
      .collection('users/St24OcPlw5ZlxP8YNVKGShzhQPp2/outfits')
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

  // Map to store like counts for each post index
  Map<int, int> likeCounts = {
    1: 0,
    2: 0,
    3: 0,
    4: 0,
    5: 0,
    6: 0,
    7: 0,
    8: 0,
    9: 0,
    10: 0,
  };

  // Map to store comments for each post index
  Map<int, List<String>> commentsMap = {
    1: [],
    2: [],
    3: [],
    4: [],
    5: [],
    6: [],
    7: [],
    8: [],
    9: [],
    10: [],
  };

  TextEditingController commentController = TextEditingController();

  // Maintain a list to keep track of the pressed state for each posts
  List<bool> isLiked = List.filled(10, false);

  // Checking if the user already liked the post
  Future<bool> userLiked(int index) async {
    // Get the reference to the post collection
    CollectionReference colRef =
        FirebaseFirestore.instance.collection('users/${widget.uid}/outfits');

    // Query for documents and get their snapshots
    QuerySnapshot qss = await colRef.get();

    // Check if the index is within the bounds of retrieved documents
    if (index >= 0 && index < qss.size) {
      // Access the document snapshot at the specified index
      DocumentSnapshot dss = qss.docs[index];

      // Access the data of the document
      Map<String, dynamic> d = dss.data() as Map<String, dynamic>;

      if (d.containsKey('likes')) {
        // Access the "likes" field
        List<dynamic> ulikes = d['likes'];

        // Check if the user's uid is already in the likes array
        if (ulikes.contains(widget.uid)) {
          return true;
        } else {
          return false;
        }
      }
    }

    // Ensure a consistent return value if the conditions are not met
    return false;
  }

  Future<bool> uLiked(int index) async {
    return await userLiked(index);
  }

  // Method to handle like button press
  void handleLikeButtonPress(int index) {
    setState(() {
      // Toggle the state of the icon when it's pressed
      isLiked[index] = !isLiked[index];
      // Initialize the like count if it's null
      likeCounts[index] ??= 0;
      // Increment like count for the specified post index if it's liked
      if (isLiked[index]) {
        // Increment like count for the specified post index
        likeCounts[index] = likeCounts[index]! + 1;
      } else {
        likeCounts[index] = likeCounts[index]! - 1;
      }
    });
  }

  // Method to handle adding a comment
  void handleCommentButtonPress(int index) {
    setState(() {
      String comment = commentController.text;
      if (comment.isNotEmpty) {
        // Ensure commentsMap[index] is not null before adding the comment
        commentsMap[index] ??= [];
        commentsMap[index]!.add(comment);
        commentController.clear();
      }
    });
  }

  /* NEW LIKE AND COMMENT HANDLER */

  // Method to handle like button press for a specific document by index
  void likeButtonPress(int index) async {
    // Get the reference to the post collection
    CollectionReference postRef =
        FirebaseFirestore.instance.collection('users/${widget.uid}/outfits');

    try {
      // Query for documents and get their snapshots
      QuerySnapshot querySnapshot = await postRef.get();

      // Check if the index is within the bounds of retrieved documents
      if (index >= 0 && index < querySnapshot.size) {
        // Access the document snapshot at the specified index
        DocumentSnapshot docSnapshot = querySnapshot.docs[index];

        // Access the data of the document
        Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;

        if (data.containsKey('likes')) {
          // Access the "likes" field
          List<dynamic> likes = data['likes'];

          // Add the user's UID to the "likes" array if it's not already present
          if (!likes.contains(widget.uid)) {
            likes.add(widget.uid);
            // updating the isLiked array
            //userLiked[index] = true;
            // Update the document in Firestore with the modified "likes" array
            await docSnapshot.reference.update({'likes': likes});
            print(
                'User UID added to likes array in document: ${docSnapshot.id}');
          } else {
            print(
                'User UID already exists in likes array in document: ${docSnapshot.id}');
          }
        } else {
          // Handle the case where the document does not contain the "likes" field
          print('Document does not contain the "likes" field');
        }
      } else {
        print('Invalid index: $index');
      }
    } catch (e) {
      print('Error liking post: $e');
    }
  }

  // Method to handle unlike button press for a specific document by index
  void unlikeButtonPress(int index) async {
    // Get the reference to the post collection
    CollectionReference postRef =
        FirebaseFirestore.instance.collection('users/${widget.uid}/outfits');

    try {
      // Query for documents and get their snapshots
      QuerySnapshot querySnapshot = await postRef.get();

      // Check if the index is within the bounds of retrieved documents
      if (index >= 0 && index < querySnapshot.size) {
        // Access the document snapshot at the specified index
        DocumentSnapshot docSnapshot = querySnapshot.docs[index];

        // Access the data of the document
        Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;

        if (data.containsKey('likes')) {
          // Access the "likes" field
          List<dynamic> likes = data['likes'];

          // Remove the user's UID from the "likes" array if it's present
          if (likes.contains(widget.uid)) {
            likes.remove(widget.uid);
            likeCounts[index]! - 1;

            // Update the document in Firestore with the modified "likes" array
            await docSnapshot.reference.update({'likes': likes});
            print(
                'User UID removed from likes array in document: ${docSnapshot.id}');
          } else {
            print(
                'User UID does not exist in likes array in document: ${docSnapshot.id}');
          }
        } else {
          // Handle the case where the document does not contain the "likes" field
          print('Document does not contain the "likes" field');
        }
      } else {
        print('Invalid index: $index');
      }
    } catch (e) {
      print('Error unliking post: $e');
    }
  }

  // Method to handle adding a comment to a specific document by index
  void commentButtonPress(int index, String commentText) async {
    // Get the reference to the post collection
    CollectionReference postRef =
        FirebaseFirestore.instance.collection('users/${widget.uid}/outfits');

    try {
      // Query for documents and get their snapshots
      QuerySnapshot querySnapshot = await postRef.get();

      // Check if the index is within the bounds of retrieved documents
      if (index >= 0 && index < querySnapshot.size) {
        // Access the document snapshot at the specified index
        DocumentSnapshot docSnapshot = querySnapshot.docs[index];

        // Access the data of the document
        Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;

        // Access the "comments" field
        List<dynamic> comments = data['comments'];

        // Add the user's comment along with their UID to the "comments" array
        comments.add({
          'uid': widget.uid,
          'comment': commentText, // The text of the user's comment
        });

        // Update the document in Firestore with the modified "comments" array
        await docSnapshot.reference.update({'comments': comments});

        print('Comment added successfully to document: ${docSnapshot.id}');
      } else {
        print('Invalid index: $index');
      }
    } catch (e) {
      print('Error adding comment: $e');
    }
  }
  /* ENDS HERE */

  Future<void> onRefresh() async {
    await Future.delayed(Duration(seconds: 1));
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
    // Retrieve the image from Firebase Storage
    getImageUrl();
    // Fetch like counts and comments from Firestore
    fetchLikeCountsAndComments();
  }

  // Method to fetch like counts and comments from Firestore
  void fetchLikeCountsAndComments() async {
    try {
      // Get the reference to the post collection
      CollectionReference postRef =
          FirebaseFirestore.instance.collection('users/${widget.uid}/outfits');

      // Retrieve all documents within the collection
      QuerySnapshot querySnapshot = await postRef.get();

      // Iterate over the documents within the collection
      for (int index = 0; index < querySnapshot.docs.length; index++) {
        // Access the document snapshot at the current index
        DocumentSnapshot doc = querySnapshot.docs[index];

        // Access the data of each document
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        // Calculate the size of the 'likes' array
        int likesCount =
            data.containsKey('likes') ? (data['likes'] as List).length : 0;

        // Store the like count in the likeCounts map with the index as the key
        likeCounts[index] = likesCount;
        if (likeCounts[index] != 0) {
          isLiked[index] = true;
        }

        // Retrieve comments for the current post
        List<dynamic> commentsData =
            data.containsKey('comments') ? data['comments'] : [];
        List<String> commentTexts = [];

// Iterate over each comment data and extract the comment text
        for (var commentData in commentsData) {
          if (commentData is Map<String, dynamic> &&
              commentData.containsKey('comment')) {
            commentTexts.add(commentData['comment'] as String);
          }
        }

// Store comments for the current post in the commentsMap with the index as the key
        commentsMap[index] = commentTexts;

        // Retrieve comments for the current post
        // List<Map<String, dynamic>> comments = data.containsKey('comments')
        //     ? (data['comments'] as List<dynamic>).cast<Map<String, dynamic>>()
        //     : [];

        // Extract just the 'comment' field from each map
        //List<String> commentTexts = comments.map((comment) => comment['comment']).toList();

        // Store comments for the current post in the commentsMap with the index as the key
        //commentsMap[index] = comments.map((comment) => comment['comment']).toList();
      }

      // Update the UI to reflect the changes
      setState(() {});
    } catch (e) {
      print('Error fetching like counts and comments: $e');
    }
  }

  late List<String> postUrls;

  Future<void> getImageUrl() async {
    setState(() {
      isLoading = true;
    });
    // Get the reference to the image file in Firebase Storage
    final Reference ref =
        //storage.ref().child('posts/St24OcPlw5ZlxP8YNVKGShzhQPp2');
        storage.ref().child('outfits/St24OcPlw5ZlxP8YNVKGShzhQPp2');
    final ListResult result = await ref.listAll();
    final List<String> urls = [];

    final profileRef =
        storage.ref().child('profiles/St24OcPlw5ZlxP8YNVKGShzhQPp2');
    final Purl = await profileRef.getDownloadURL();
    // Iterate through the items and fetch download URLs for image files
    await Future.forEach(result.items, (Reference reference) async {
      // Check if the item is an image file (you can add more file extensions if needed)
      final String url = await reference.getDownloadURL();
      urls.add(url);
      // print the URL for debugging
      print('Download URL: $url');
    });
    // Get then imageUrl to download URL
    setState(() {
      postUrls = urls;
      profileUrl = Purl;
      isLoading = false;
    });
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
                "images/logo.png",
                height: 50,
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
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.favorite_border),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.chat_bubble_outline),
                )
              ],
            ),
            body: RefreshIndicator(
              onRefresh: onRefresh,
              child: SingleChildScrollView(
                child: Column(children: [
                  //Story
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(
                        8,
                        (index) => Container(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 35,
                                  backgroundImage: AssetImage(
                                    "images/story.png",
                                  ),
                                  child: CircleAvatar(
                                      radius: 32,
                                      backgroundImage: AssetImage(
                                        profileImages[index],
                                      )),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "Profile Name",
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.black87),
                                )
                              ],
                            )),
                      ),
                    ),
                  ),

                  /* IMAGES FROM FIREBASE */

                  Divider(),
                  Column(
                    children: List.generate(
                      postUrls.length,
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
                                    backgroundImage: NetworkImage(
                                        profileUrl), //AssetImage("images/test.jpg"
                                    //     //profileImages[index],
                                    //     ),
                                  ),
                                ),
                              ),
                              Text("samsamsam"),
                              Spacer(),
                              IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.more_vert),
                              )
                            ],
                          ),
                          // Image Post
                          Image.network(postUrls[index]),
                          // Footer Post
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  handleLikeButtonPress(index);
                                  isLiked[index]
                                      ? likeButtonPress(index)
                                      : unlikeButtonPress(index);
                                },
                                icon: Icon(
                                  isLiked[index]
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  // Update the color based on the isLiked state
                                  color: isLiked[index] ? Colors.red : null,
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
                                          controller: commentController,
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
                                              handleCommentButtonPress(index);
                                              Navigator.of(context).pop();
                                              // Ensure commentsMap[index] is not null before adding the comment
                                              commentsMap[index] ??= [];
                                              List<String>? comment =
                                                  commentsMap[index];
                                              if (comment != null) {
                                                for (var com in comment) {
                                                  commentButtonPress(
                                                      index, com);
                                                }
                                              }

                                              //commentButtonPress(index, commentsMap[index]);
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
                              IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.share_rounded),
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
                                          text: " Profile Name",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextSpan(
                                          text: likeCounts[index] == 0
                                              ? " "
                                              : " and",
                                        ),
                                        TextSpan(
                                          text: likeCounts[index] == 0
                                              ? " "
                                              : " ${likeCounts[index]} others",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ]),
                                ),
                                RichText(
                                  text: TextSpan(
                                      style: TextStyle(color: Colors.black),
                                      children: [
                                        TextSpan(
                                          text: " Profile Name",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextSpan(
                                            text: " This is an amazing fit"),
                                      ]),
                                ),
                                // Display comments with user name in bold and comment in normal text
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: (commentsMap[index] ?? [])
                                      .map((comment) => Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 4),
                                            child: RichText(
                                              text: TextSpan(
                                                style:
                                                    DefaultTextStyle.of(context)
                                                        .style,
                                                children: [
                                                  TextSpan(
                                                    text:
                                                        'samsamsam', // Assuming "Profile name" is the user name
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  TextSpan(
                                                      text:
                                                          ' '), // Add space between user name and comment
                                                  TextSpan(text: comment),
                                                ],
                                              ),
                                            ),
                                          ))
                                      .toList(),
                                ),

                                Text(
                                  "View all 12 comments",
                                  style: TextStyle(color: Colors.black38),
                                )
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
