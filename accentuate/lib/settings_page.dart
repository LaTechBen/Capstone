import 'package:accentuate/signin_page.dart';
import 'package:flutter/material.dart';
import 'personalinfo_page.dart';
import 'accountinfo_page.dart';
import 'home_page.dart';

/*void main() {
  runApp(const MyApp());
}*/

// Initializes and runs the app
// Will change this to be integrated with main.dart
// For now It is used to only run the 'settings_page.dart' for testing purposes
/*class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Settings Page',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: const SettingsPage(),
    );
  }
}*/

// Settings Screen UI, displays the SettingsList
class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Settings'),
            SizedBox(width: 8),
            Icon(Icons.settings),
          ],
        ),
        leading: null,
      ),
      body: const SettingsBody(),
    );
  }
}

class SettingsBody extends StatelessWidget {
  const SettingsBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SettingsButton(icon: Icons.person, text: 'Account Information'),
          const SizedBox(height: 16),
          SettingsButton(icon: Icons.credit_card, text: 'Personal Information'),
          const SizedBox(height: 16),
          SettingsButton(icon: Icons.logout_rounded, text: 'Log out'),
        ],
      ),
    );
  }
}

class SettingsButton extends StatelessWidget {
  final IconData icon;
  final String text;

  SettingsButton({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Button Logic here
        if (text == 'Account Information') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AccountInfoPage()),
          );
        } else if (text == 'Personal Information') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PersonalInfoPage()),
          );
        } else if (text == 'Log out') {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => SigninPage()),
            (route) => false, // This line clears the entire navigation stack
          );
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromARGB(255, 248, 201, 205),
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
