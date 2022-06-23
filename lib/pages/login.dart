import 'dart:io';

import 'package:Foodica/pages/init_allergens.dart';
import 'package:Foodica/providers/authentication_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:Foodica/utils/authentication.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:provider/provider.dart';
import 'homescreen.dart';
import 'register.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isSigningIn = false;
  bool loggedInWithApple = false;
  String email = "";
  String password = "";
  User? user;

  Route _toRegisterPage() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const RegisterPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = const Offset(1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _checkPlatform(BuildContext context) {
    if (Platform.isIOS) {
      return SignInWithAppleButton(
        style: SignInWithAppleButtonStyle.black,
        iconAlignment: IconAlignment.center,
        onPressed: () async {
          user = await context.read<AuthenticationProvider>().signInWithApple();
          if (user != null) {
            SharedPreferences.getInstance().then((value) {
              value.setBool("signedInWithApple", true);
              if (value.getStringList("allergens") != null) {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => InitAllergens(
                        user: FirebaseAuth.instance.currentUser!)));
              } else {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => HomeScreenPage(
                        user: FirebaseAuth.instance.currentUser!)));
              }
            });
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    InitAllergens(user: FirebaseAuth.instance.currentUser!)));
          }
        },
      );
    } else {
      return SizedBox(height: 5);
    }
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
                    const Text("Sign In",
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 36.0,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 30.0),
                    SizedBox(
                      width: 400,
                      child: TextField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Email',
                        ),
                        onChanged: (value) => {
                          setState(() {
                            email = value.trim();
                          })
                        },
                      ),
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
                          setState(() => {password = value.trim()})
                        },
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    OutlinedButton(
                        onPressed: () => {
                              Authentication()
                                  .signInWithEmail(
                                      email: email, password: password)
                                  .then((result) => {
                                        if (result == null)
                                          {
                                            SharedPreferences.getInstance()
                                                .then((prefs) {
                                              if (prefs.getStringList(
                                                      "allergens") ==
                                                  null) {
                                                Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            InitAllergens(
                                                                user: FirebaseAuth
                                                                    .instance
                                                                    .currentUser!)));
                                              } else {
                                                Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            HomeScreenPage(
                                                                user: FirebaseAuth
                                                                    .instance
                                                                    .currentUser!)));
                                              }
                                            })
                                          }
                                        else
                                          {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(result)))
                                          }
                                      })
                            },
                        child: const Text("Login")),
                    const Text(
                      "Or sign in with these options: ",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    FutureBuilder(
                        future:
                            Authentication.initializeFirebase(context: context),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return const Text("Error initializing Firebase");
                          } else if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return SizedBox(
                                child: _isSigningIn
                                    ? const CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.red),
                                      )
                                    : OutlinedButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.red),
                                            shape: MaterialStateProperty.all(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            40)))),
                                        onPressed: () async {
                                          setState(() {
                                            _isSigningIn = true;
                                          });

                                          User? user = await Authentication
                                              .signInWithGoogle(
                                                  context: context);
                                          setState(() {
                                            _isSigningIn = false;
                                          });

                                          if (user != null) {
                                            SharedPreferences prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            if (prefs.getStringList(
                                                    "allergens") !=
                                                null) {
                                              Navigator.of(context)
                                                  .pushReplacement(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      HomeScreenPage(
                                                    user: user,
                                                  ),
                                                ),
                                              );
                                            } else {
                                              Navigator.of(context)
                                                  .pushReplacement(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              InitAllergens(
                                                                  user: user)));
                                            }
                                          }
                                        },
                                        child: const Text("Sign In with Google",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: "Poppins",
                                                fontWeight: FontWeight.bold)),
                                      ));
                          }
                          return const CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.red),
                          );
                        }),
                    Column(
                      children: [_checkPlatform(context)],
                    ),
                    OutlinedButton(
                        onPressed: () =>
                            {Navigator.of(context).push(_toRegisterPage())},
                        child: const Text("Create New Account"))
                  ],
                ))));
  }
}
