import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(const MyApp());
}

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

class PersonalInfoPage extends StatefulWidget {
  const PersonalInfoPage({Key? key}) : super(key: key);

  @override
  _PersonalInfoPageState createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _usernameController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _usernameController = TextEditingController();
    _fetchUserData();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  // fetch user data from firestore
  Future<void> _fetchUserData() async {

    // get the current users ID
    String? uid = FirebaseAuth.instance.currentUser?.uid;

    // retrieve user data from Firestore
    DocumentSnapshot<Map<String, dynamic>> userData =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    // update text controllers with user data
    setState(() {
      _emailController.text = userData['email'] ?? '';
      _phoneController.text = userData['phone'] ?? '';
      _usernameController.text = userData['username'] ?? '';
    });
  }

  // update user data in firestore
  Future<void> _updateUserData() async {
    try {
      String? uid = FirebaseAuth.instance.currentUser?.uid;

      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'email': _emailController.text,
        'phone': _phoneController.text,
        'username': _usernameController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User information updated successfully')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update user information: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Information'),
        centerTitle: true,
      ),
      body: PersonalInfoList(
        emailController: _emailController,
        phoneController: _phoneController,
        usernameController: _usernameController,
        onUpdatePressed: _updateUserData,
      ),
    );
  }
}

class PersonalInfoList extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController usernameController;
  final VoidCallback onUpdatePressed;

  const PersonalInfoList({
    required this.emailController,
    required this.phoneController,
    required this.usernameController,
    required this.onUpdatePressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: <Widget>[
        _buildTextField('Email', emailController),
        _buildTextField('Phone', phoneController),
        _buildTextField('Username', usernameController),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: onUpdatePressed,
            icon: Icon(Icons.check),
            label: Text('Update'),
          ),
        ),
      ],
    );
  }

  // build a text field with label and controller
  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 12),
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        // disable email interaction
        TextField(
          controller: controller,
          enabled: label != 'Email', 
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
