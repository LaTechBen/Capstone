import 'package:flutter/material.dart';


void main() {
  runApp(const MyApp());
}

// Initializes and runs the app
// Will change this to be integrated with main.dart
// For now It is used to only run the 'accountinfo_page.dart' for testing purposes
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Account Information',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: const AccountInfoPage(),
      );
  }
}

// Account Info Screen UI, displays the AccountInfoList
class AccountInfoPage extends StatelessWidget {
  const AccountInfoPage({Key? key}) : super(key: key);

  @override 
  Widget build(BuildContext context) {
    return Scaffold( 
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
            Text('Account Information'),
            SizedBox(width: 8),
            Icon(Icons.person),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_outlined),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center (
        child: Column( 
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 80,
              //backgroundImage: AssetImage(''),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                  // Insert Take Picture Logic
                },
                child: const Text('Take Picture'),
                ),
                ElevatedButton(
                  onPressed: () {
                  // Insert Upload Logic
                  },
                  child: const Text('Upload from Gallery'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

