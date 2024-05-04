import 'dart:developer';
import 'package:accentuate/accountinfo_page.dart';
import 'package:accentuate/firebase_api_calls/firebase_auth_service.dart';
import 'package:accentuate/components/my_button.dart';
import 'package:accentuate/components/my_textfield.dart';
import 'package:accentuate/signup_page.dart';
import 'package:accentuate/forgot_password_page.dart';
import 'package:accentuate/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';

class SigninPage extends StatefulWidget {
  SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {

  final FirebaseAuthService  _auth = FirebaseAuthService();
  final FirebaseAuth _user = FirebaseAuth.instance;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

@override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  // todo request to firebase
  void signUserIn() async {
    String email = _emailController.text;
    String password = _passwordController.text;
    //await _user.currentUser?.reload();
    User? user = await _auth.signInWithEmailAndPassword(email, password);

    if(user==null){
      const snackbar = SnackBar(content: Text("Invalid Email or Password."));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
      return null;
    }
      if(!user!.emailVerified){
      const snackbar = SnackBar(content: Text("Please verify your email before signing in."));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
      return null;
    }

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyHomePage( title: "")));
  }

  void goToForgotPassword(BuildContext context) {
    // temporary until forgot password page is created.
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ForgotPassword()));
  }

  void goToSignUp(BuildContext context) {
    // temporary
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SignupPage()));
  }

  void signUserInWithGoogle(BuildContext context) {
    // temporary
    const snackbar = SnackBar(content: Text("Navigate to Google Sign in."));
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: SafeArea(
              child: Center(
                  child: Column(
            children: [
          
              // Logo
              Image.asset('images/signinlogo.png'),
          
              // email input
              MyTextField(
                controller: _emailController,
                hintText: 'Email',
                obscureText: false,
              ),
          
              // spacing
              const SizedBox(height: 20),
          
              // password input
              MyTextField(
                controller: _passwordController,
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
          
              // const SizedBox(height: 10),
          
              // const Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 25.0),
              //   child: Row(
              //     children: [
              //       Expanded(
              //         child: Divider(
              //           thickness: 0.5,
              //           color: Colors.black,
              //         ),
              //       ),
              //       Padding(
              //           padding: EdgeInsets.symmetric(horizontal: 10.0),
              //           child: Text(
              //             'Continue with',
              //             style: TextStyle(color: Colors.black),
              //           )),
              //       Expanded(
              //           child: Divider(
              //         thickness: 0.5,
              //         color: Colors.black,
              //       ))
              //     ],
              //   ),
              // ),
          
              // const SizedBox(height: 25),
          
              // GestureDetector(
              //     onTap: () => signUserInWithGoogle(context),
              //     child: Image.asset('images/android_neutral_rd_na@2x.png')),
          
              const SizedBox(height: 25),
          
              GestureDetector(
                  onTap: () => goToSignUp(context),
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
          ))),
        ));
  }
}
