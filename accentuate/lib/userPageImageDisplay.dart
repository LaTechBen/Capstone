import 'package:flutter/material.dart';

class UserPageImageDisplay extends StatelessWidget {
  final String imagePath;
  const UserPageImageDisplay({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              child: Image(
                image: NetworkImage(imagePath),
              ),
            ),
          ],
        ),
      ),
      onTap: () => {
        Navigator.pop(context),
      },
    );
  }
}
