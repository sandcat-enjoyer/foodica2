import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../utils/authentication.dart';
import 'homescreen.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isRegistering = false;

  String email = "";
  String password = "";
  String name = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const SizedBox(height: 60),
                    Image.asset(
                      "assets/splash_icon.png",
                      width: 120,
                    ),
                    const Text("Create an account",
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 36.0,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 30.0),
                    SizedBox(
                      width: 400,
                      child: TextField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: "Email",
                            border: OutlineInputBorder(),
                            hintText: 'Enter an e-mail address',
                          ),
                          onChanged: (value) => {
                                setState(() {
                                  email = value.trim();
                                })
                              }),
                    ),
                    const SizedBox(height: 10.0),
                    SizedBox(
                      width: 400,
                      child: TextField(
                        obscureText: true,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Password',
                        ),
                        onChanged: (value) => {
                          setState(() {
                            password = value.trim();
                          })
                        },
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    OutlinedButton(
                        onPressed: () async => {
                              Authentication()
                                  .signUp(email: email, password: password)
                                  .then((result) => {
                                        if (result == null)
                                          {
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        HomeScreenPage(
                                                            user: FirebaseAuth
                                                                .instance
                                                                .currentUser!)))
                                          }
                                        else
                                          {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(result)))
                                          }
                                      })
                            },
                        child: const Text("Register")),
                  ],
                ))));
  }
}
