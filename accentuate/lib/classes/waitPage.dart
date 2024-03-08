import 'package:flutter/material.dart';

class WaitPage extends StatelessWidget {
  const WaitPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
