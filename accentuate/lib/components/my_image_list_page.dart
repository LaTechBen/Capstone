import 'dart:io';

import 'package:accentuate/userPageImageDisplay.dart';
import 'package:flutter/material.dart';

class ImageListPage extends StatefulWidget {
    final List<dynamic> imageUrls;
    final String description;
  const ImageListPage({super.key, required this.imageUrls, required this.description});

  @override
  State<ImageListPage> createState() => _ImageListPageState();
}

class _ImageListPageState extends State<ImageListPage> {
  
  @override
  Widget build(BuildContext context) {
    String desc = widget.description;
    List<dynamic> images = widget.imageUrls;
    return Scaffold(
      appBar: AppBar(leading: null,),
      body: Center(
        child: Column(
          children: [
            Text(desc, style: TextStyle(
              fontSize: 20.0
            ),),
            Expanded(child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 3),
                itemCount: images.length, 
                itemBuilder: (BuildContext context, int index) { 
                  //return Image.file(File(images[index].path), fit: BoxFit.cover,);
                  return GestureDetector(
                    child: Image(
                      image: NetworkImage(images[index]), 
                      fit: BoxFit.cover,
                      ),
                      onTap: () => {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UserPageImageDisplay(
                                      imagePath: images[index])
                                ),
                              ),
                            },
                      ) ;
                  },
              ),
            )
            ),
          ],
        ),
      ),
    );
  }
}