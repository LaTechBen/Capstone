import 'dart:math';

import 'package:flutter/material.dart';

class ImageGridDisplay extends StatefulWidget {
    final int maxImages;
  final List<dynamic> imageUrls;
  final Function(int) onImageClicked;
  final Function onExpandClicked;
  const ImageGridDisplay({super.key, this.maxImages = 4, required this.imageUrls, required this.onImageClicked, required this.onExpandClicked});

  @override
  State<ImageGridDisplay> createState() => _ImageGridDisplayState();
}

class _ImageGridDisplayState extends State<ImageGridDisplay> {
@override
  Widget build(BuildContext context) {
    var images = buildImages();

    return images;
  }

  Widget buildImages() {
    int numImages = widget.imageUrls.length;
      String imageUrl = widget.imageUrls[0];

      // If its the last image

        // Check how many more images are left
        int remaining = numImages - widget.maxImages;

        // If no more are remaining return a simple image widget
        if (remaining == 0) {
          return GestureDetector(
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
            ),
            onTap: () => widget.onImageClicked(0),
          );
        } else {
          // Create the facebook like effect for the last image with number of remaining  images
          return GestureDetector(
            onTap: () => widget.onExpandClicked(),
            child: SizedBox(
              height: 500,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(imageUrl, fit: BoxFit.cover),
                  Positioned.fill(
                    child: Container(
                      alignment: Alignment.center,
                      color: Colors.black12,
                      child: Text(
                        '+' + remaining.toString(),
                        style: TextStyle(fontSize: 64),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
  }
}
