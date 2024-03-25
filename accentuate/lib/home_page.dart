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
                  // Divider(),
                  // Column(
                  //   children: List.generate(
                  //     8,
                  //     (index) => Column(
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         //Header post
                  //         Row(
                  //           children: [
                  //             Container(
                  //               padding: EdgeInsets.all(10),
                  //               child: CircleAvatar(
                  //                 radius: 14,
                  //                 backgroundImage: AssetImage(
                  //                   "images/story.png",
                  //                 ),
                  //                 child: CircleAvatar(
                  //                   radius: 12,
                  //                   backgroundImage: AssetImage(
                  //                     profileImages[index],
                  //                   ),
                  //                 ),
                  //               ),
                  //             ),
                  //             Text("Profile Name"),
                  //             Spacer(),
                  //             IconButton(
                  //               onPressed: () {},
                  //               icon: Icon(Icons.more_vert),
                  //             )
                  //           ],
                  //         ),
                  //         // Image Post
                  //         Image.asset(posts[index]),
                  //         // Footer Post
                  //         Row(
                  //           children: [
                  //             IconButton(
                  //               onPressed: () {
                  //                 handleLikeButtonPress(index);
                  //               },
                  //               icon: Icon(
                  //                 isLiked[index]
                  //                     ? Icons.favorite
                  //                     : Icons.favorite_border,
                  //                 // Update the color based on the isLiked state
                  //                 color: isLiked[index] ? Colors.red : null,
                  //               ),
                  //             ),
                  //             IconButton(
                  //               onPressed: () {
                  //                 // Open a dialog to add a comment
                  //                 showDialog(
                  //                   context: context,
                  //                   builder: (BuildContext context) {
                  //                     return AlertDialog(
                  //                       title: Text('Add Comment'),
                  //                       content: TextField(
                  //                         controller: commentController,
                  //                         decoration: InputDecoration(
                  //                           hintText: 'Enter your comment',
                  //                         ),
                  //                       ),
                  //                       actions: <Widget>[
                  //                         TextButton(
                  //                           onPressed: () {
                  //                             Navigator.of(context).pop();
                  //                           },
                  //                           child: Text('Cancel'),
                  //                         ),
                  //                         TextButton(
                  //                           onPressed: () {
                  //                             // Handle adding a comment
                  //                             handleCommentButtonPress(index);
                  //                             Navigator.of(context).pop();
                  //                           },
                  //                           child: Text('Add'),
                  //                         ),
                  //                       ],
                  //                     );
                  //                   },
                  //                 );
                  //               },
                  //               icon: Icon(Icons.comment_rounded),
                  //             ),
                  //             IconButton(
                  //               onPressed: () {},
                  //               icon: Icon(Icons.share_rounded),
                  //             ),
                  //           ],
                  //         ),

                  //         Container(
                  //           padding: EdgeInsets.all(15),
                  //           child: Column(
                  //             crossAxisAlignment: CrossAxisAlignment.start,
                  //             children: [
                  //               RichText(
                  //                 text: TextSpan(
                  //                     style: TextStyle(color: Colors.black),
                  //                     children: [
                  //                       TextSpan(text: "Liked by"),
                  //                       TextSpan(
                  //                         text: " Profile Name",
                  //                         style: TextStyle(
                  //                           fontWeight: FontWeight.bold,
                  //                         ),
                  //                       ),
                  //                       TextSpan(
                  //                         text: likeCounts[index] == 0
                  //                             ? " "
                  //                             : " and",
                  //                       ),
                  //                       TextSpan(
                  //                         text: likeCounts[index] == 0
                  //                             ? " "
                  //                             : " ${likeCounts[index]} others",
                  //                         style: TextStyle(
                  //                           fontWeight: FontWeight.bold,
                  //                         ),
                  //                       ),
                  //                     ]),
                  //               ),
                  //               RichText(
                  //                 text: TextSpan(
                  //                     style: TextStyle(color: Colors.black),
                  //                     children: [
                  //                       TextSpan(
                  //                         text: " Profile Name",
                  //                         style: TextStyle(
                  //                           fontWeight: FontWeight.bold,
                  //                         ),
                  //                       ),
                  //                       TextSpan(
                  //                           text: " This is an amazing fit"),
                  //                     ]),
                  //               ),
                  //               // Display comments with user name in bold and comment in normal text
                  //               Column(
                  //                 crossAxisAlignment: CrossAxisAlignment.start,
                  //                 children: (commentsMap[index] ?? [])
                  //                     .map((comment) => Padding(
                  //                           padding: EdgeInsets.symmetric(
                  //                               horizontal: 16, vertical: 4),
                  //                           child: RichText(
                  //                             text: TextSpan(
                  //                               style:
                  //                                   DefaultTextStyle.of(context)
                  //                                       .style,
                  //                               children: [
                  //                                 TextSpan(
                  //                                   text:
                  //                                       'Profile name', // Assuming "Profile name" is the user name
                  //                                   style: TextStyle(
                  //                                       fontWeight:
                  //                                           FontWeight.bold),
                  //                                 ),
                  //                                 TextSpan(
                  //                                     text:
                  //                                         ' '), // Add space between user name and comment
                  //                                 TextSpan(text: comment),
                  //                               ],
                  //                             ),
                  //                           ),
                  //                         ))
                  //                     .toList(),
                  //               ),

                  //               Text(
                  //                 "View all 12 comments",
                  //                 style: TextStyle(color: Colors.black38),
                  //               )
                  //             ],
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),

                  /* IMAGES FROM FIREBASE */

                  Divider(),
                  Column(
                    children: List.generate(
                      9,
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
                                                        'Profile name', // Assuming "Profile name" is the user name
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
