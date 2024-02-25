import 'package:accentuate/firebase_api_calls/firebase_auth_service.dart';
import 'package:accentuate/components/my_button.dart';
import 'package:accentuate/components/my_textfield.dart';
import 'package:accentuate/signin_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'dart:developer';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  
  final FirebaseAuthService  _auth = FirebaseAuthService();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

@override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void goToSignUserIn(BuildContext context){
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SigninPage()));
  }

  void signUserUp() async {
    String email = _emailController.text;
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;
    String username = _usernameController.text;

    // check if username is valid
    if(!isUsernameCompliant(username)){
      const snackbar = SnackBar(content: Text("Please enter a username that is longer than 5 letters."));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
      return;
    }

    // check if email is valid
    if(!isEmailCompliant(email)){
      const snackbar = SnackBar(content: Text("Please enter a valid email address."));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
      return;
    }

    // check if password follows requirements
    if(!isPasswordCompliant(password)){
      const snackbar = SnackBar(content: Text("Please make a stronger password.\n(Must contain 1 number, 1 capital letter, 1 special character, and 8 characters.)"));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
      return;
    }
    
    // check if passwords are the same
    if(password != confirmPassword){
      const snackbar = SnackBar(content: Text("The passwords do not match."));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
      return;
    }

    // make call to firebase
    User? user = await _auth.signUpWithEmailAndPassword(email, password, username);
    const snackbar = SnackBar(content: Text("Please check your email to verify your account."));
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

    void signUserInWithGoogle(BuildContext context) {
    // temporary
    const snackbar = SnackBar(content: Text("Navigate to Google Sign in."));
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  bool isPasswordCompliant(String password) {
  if (password == null || password.isEmpty) {
    return false;
  }

  bool hasUppercase = password.contains(new RegExp(r'[A-Z]'));
  bool hasDigits = password.contains(new RegExp(r'[0-9]'));
  bool hasLowercase = password.contains(new RegExp(r'[a-z]'));
  bool hasSpecialCharacters = password.contains(new RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
  bool hasMinLength = password.length > 7;

  return hasDigits & hasUppercase & hasLowercase & hasSpecialCharacters & hasMinLength;
}

  bool isEmailCompliant(String email){

    if(email == null || email.isEmpty){
      return false;
    }
    const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
      r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
      r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
      r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
      r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
      r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
      r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
    final regex = RegExp(pattern);

    return regex.hasMatch(email);
}

bool isUsernameCompliant(String username){
  if(username == null || username.isEmpty || username.length < 6){
    return false;
  }
  return true;

}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
        backgroundColor: Colors.pink[100],
        body: SingleChildScrollView(
          child: SafeArea(
              child: Center(
                  child: Column(
            children: [
              const SizedBox(height: 10),
          
              // Logo
              Image.asset('images/newLogo.png'),
          
              // padding
              const SizedBox(height: 10),

              // username input
              MyTextField(
                controller: _usernameController,
                hintText: 'Username',
                obscureText: false,
              ),
          
              // spacing
              const SizedBox(height: 20),
          
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

                            // spacing
              const SizedBox(height: 20),
          
              // password input
              MyTextField(
                controller: _confirmPasswordController,
                hintText: 'Confirm Password',
                obscureText: true,
              ),
          
          
              const SizedBox(height: 25),
          
              MyButton(text: "Sign Up", onTap: signUserUp),
          
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
              //             'Sign up with',
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
                  onTap: () => goToSignUserIn(context),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Have an account?",
                          style: TextStyle(color: Colors.black, fontSize: 16)),
                      SizedBox(width: 4),
                      Text("Sign in.",
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
