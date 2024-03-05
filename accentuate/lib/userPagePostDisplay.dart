import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'user_page.dart';

class UserPagePostDisplay extends StatefulWidget {
  // final DocumentSnapshot post;
  // var userData = {};
  const UserPagePostDisplay({
    super.key,
    // required this.post,
    // required this.userData,
  });

  @override
  State<UserPagePostDisplay> createState() => _UserPagePostDisplayState();
}

class _UserPagePostDisplayState extends State<UserPagePostDisplay> {
  bool isLiked = false;
  bool canComment = false;

  @override
  void initState() {
    super.initState();
    isLiked = false;
    canComment = false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              child: Image(
                image: AssetImage(
                    'images/p1.jpg'), //NetworkImage(post['postUrl']),
              ),
            ),
            Container(
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text(
                      '1.0k',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 150,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              isLiked = !isLiked;
                            });
                          },
                          icon: isLiked
                              ? const Icon(
                                  Icons.favorite,
                                  // color: Colors.Red,
                                )
                              : const Icon(
                                  Icons.favorite_border,
                                ),
                        ),
                        IconButton(
                          onPressed: () {
                            canComment = true;
                          },
                          icon: const Icon(
                            Icons.comment_rounded,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
      onTap: () => {
        // Navigator.pop(context),
      },
      onDoubleTap: () => {
        isLiked = !isLiked,
      },
    );
  }
}
