import 'package:accentuate/components/my_button.dart';
import 'package:accentuate/components/my_textfield.dart';
import 'package:accentuate/forgot_password_page.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // todo request to firebase
  void signUserIn() {}

  void goToForgotPassword(BuildContext context) {
    // temporary until forgot password page is created.
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ForgotPassword()));
  }

  void signUserUp(BuildContext context) {
    // temporary
    const snackbar = SnackBar(content: Text("Navigate to Sign up."));
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  void signUserInWithGoogle(BuildContext context) {
    // temporary
    const snackbar = SnackBar(content: Text("Navigate to Google Sign in."));
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.pink[100],
        body: SafeArea(
            child: Center(
                child: Column(
          children: [
            const SizedBox(height: 50),

            // Logo
            Image.asset('images/logo.png'),

            // padding
            const SizedBox(height: 25),

            // email input
            MyTextField(
              controller: emailController,
              hintText: 'Email',
              obscureText: false,
            ),

            // spacing
            const SizedBox(height: 25),

            // password input
            MyTextField(
              controller: passwordController,
              hintText: 'Password',
              obscureText: true,
            ),

            // padding
            const SizedBox(height: 5),

            // forgot password
            GestureDetector(
              onTap: () => goToForgotPassword(context),
              child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Forgot Password?',
                        style: TextStyle(color: Colors.black, fontSize: 14),
                      )
                    ],
                  )),
            ),

            const SizedBox(height: 25),

            MyButton(text: "Sign In", onTap: signUserIn),

            const SizedBox(height: 10),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                children: [
                  Expanded(
                    child: Divider(
                      thickness: 0.5,
                      color: Colors.black,
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        'Continue with',
                        style: TextStyle(color: Colors.black),
                      )),
                  Expanded(
                      child: Divider(
                    thickness: 0.5,
                    color: Colors.black,
                  ))
                ],
              ),
            ),

            const SizedBox(height: 25),

            GestureDetector(
                onTap: () => signUserInWithGoogle(context),
                child: Image.asset('images/android_neutral_rd_na@2x.png')),

            const SizedBox(height: 25),

            GestureDetector(
                onTap: () => signUserUp(context),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Need an account?",
                        style: TextStyle(color: Colors.black, fontSize: 16)),
                    SizedBox(width: 4),
                    Text("Sign up.",
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 16,
                            fontWeight: FontWeight.bold))
                  ],
                )),
          ],
        ))));
  }
}
