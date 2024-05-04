import 'package:accentuate/firebase_api_calls/firebase_auth_service.dart';
import 'package:accentuate/signin_page.dart';
import 'package:flutter/material.dart';

import 'components/my_button.dart';
import 'components/my_textfield.dart';

class ForgotPassword extends StatefulWidget {
  ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _emailController = TextEditingController();

  final FirebaseAuthService  _auth = FirebaseAuthService();

  void submitForgotPassword(BuildContext context) async {
    // temporary
    String email = _emailController.text;
    try{
      await _auth.forgotPassword(email: email);
        const snackbar = SnackBar(content: Text("Please check your email to reset your password"));
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
    } catch (e) {
        const snackbar = SnackBar(content: Text("There was an error in sending the forgot password email."));
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }

  }

  void goToLoginPage(BuildContext context){
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => SigninPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 50),

              // Logo
              Image.asset('images/signinlogo.png'),

              // padding
              const SizedBox(height: 25),

              // email input
              MyTextField(
                controller: _emailController,
                hintText: 'Email',
                obscureText: false,
              ),

              // padding
              const SizedBox(height: 5),

              // button to login page
              GestureDetector(
                onTap: () => goToLoginPage(context),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Login Page',
                        style: TextStyle(color: Colors.black, fontSize: 14),
                      )
                    ],
                  )),
              ),

              // padding
              const SizedBox(height: 25),

              // submit button
              MyButton(text: "Submit", onTap:() => submitForgotPassword(context)),
            ],
          ),
        )),
    );
  }
}