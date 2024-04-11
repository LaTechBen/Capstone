import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// Initializes and runs the app
// Will change this to be integrated with main.dart
// For now It is used to only run the 'personalinfo_page.dart' for testing purposes
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Information',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: const PersonalInfoPage(),
      );
  }
}

// Personal Info Screen UI, displays the PersonalInfoList
class PersonalInfoPage extends StatelessWidget {
  const PersonalInfoPage({Key? key}) : super(key: key);

  @override 
  Widget build(BuildContext context) {
    return Scaffold( 
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
            Text('Personal Information'),
            SizedBox(width: 8),
            Icon(Icons.person),
          ],
        ),
        leading: null
        // IconButton(
        //   icon: const Icon(Icons.arrow_back_outlined),
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        // ),
      ),
      body: const PersonalInfoList(),
    );
  }
}

// Displays the Email, Phone, Username, and Password text fields using ListView
class PersonalInfoList extends StatelessWidget {
  const PersonalInfoList({Key? key}) : super(key: key);

  @override 
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: <Widget>[
        _buildTextFieldWithButton('Email'),
        _buildTextFieldWithButton('Phone'),
        _buildTextFieldWithButton('Username'),
        _buildTextFieldWithButton('Password'),
      ],
    );
  }
}

// Helper Method to build the view. 
// Includes a 'change' button  
Widget _buildTextFieldWithButton(String label) {
  return Column( 
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      const SizedBox(height: 12),
      Text(
        label, 
        style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        TextField( 
          decoration: InputDecoration(
            hintText: 'Enter $label',
            border: const OutlineInputBorder()
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              // IMPLEMENT 'CHANGE' BUTTON FUNCTION HERE
            },
            child: const Text('Change'),
          ),
        ),
    ],
  );
}

