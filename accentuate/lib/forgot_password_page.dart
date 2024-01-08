import 'package:flutter/material.dart';

import 'components/my_button.dart';
import 'components/my_textfield.dart';

class ForgotPassword extends StatelessWidget {
  ForgotPassword({super.key});

  final emailController = TextEditingController();

  void submitForgotPassword(BuildContext context) {
    // temporary
    const snackbar = SnackBar(content: Text("Send forgot password email."));
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