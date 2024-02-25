import 'package:flutter/material.dart';
import 'home_page.dart';

// Settings Screen UI, displays the SettingsList
class CreateOutfitPage extends StatelessWidget {
  const CreateOutfitPage({Key? key}) : super(key: key);

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment:MainAxisAlignment.center,
          children:[
            Text('Create Outfit'),
            SizedBox(width:8),
            Icon(Icons.add),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_outlined),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              // Add your onPressed logic here
            },
          ),
        ],
      ),
      body: const CreateOutfitBody(),
    );
  }
}

class CreateOutfitBody extends StatelessWidget {
  const CreateOutfitBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CreateOutfitButton(
              icon: Icons.person, text: 'Add Image From Gallery'),
        ],
      ),
    );
  }
}

class CreateOutfitButton extends StatelessWidget {
  final IconData icon;
  final String text;

  CreateOutfitButton({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Button Logic here
        HomePage().getImageFromGallery();
        /*
        if (text == 'Account Information') {
            Navigator.push(
            context, 
            MaterialPageRoute(builder: (context) => const AccountInfoPage()),
          );
        } */
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon),
            Text(
              text,
              style: const TextStyle(fontSize: 18),
            ),
            Opacity(opacity: 0, child: Icon(icon)),
          ],
        ),
      ),
    );
  }
}
