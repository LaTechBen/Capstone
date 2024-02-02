import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  const PostCard({super.key, required this.snap});
  final snap;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 16,
            ).copyWith(right: 0),
            child: const Row(
              children: [CircleAvatar(
                radius: 16,
                
              )],
            ),
          )
        ],
      ),
    );
  }
}
