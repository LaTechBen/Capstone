import 'package:flutter/material.dart';
import 'home_page.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  void click() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: TextField(
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.check_circle_outline_sharp),
                          labelText: "Email Address",
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 5, color: Colors.black)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.pink))))),
              const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: TextField(
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.check_circle_outline_sharp),
                          labelText: "Create Username",
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 5, color: Colors.black)),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.pinkAccent))))),
              const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: TextField(
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.check_circle_outline_sharp),
                          labelText: "Create Password",
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 5, color: Colors.black)),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.pinkAccent))))),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomePage()));
                  },
                  style: const ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(Colors.pinkAccent)),
                  child: const Text(
                    "Create Account",
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                ),
              )
            ],
          )),
    ));
  }
}
