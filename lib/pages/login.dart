import 'dart:io';

import 'package:Foodica/pages/init_allergens.dart';
import 'package:Foodica/providers/authentication_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
      return Container(
          width: 205,
          height: 60,
          child: SignInWithAppleButton(
            style: SignInWithAppleButtonStyle.black,
            iconAlignment: IconAlignment.center,
            onPressed: () async {
              user = await context
                  .read<AuthenticationProvider>()
                  .signInWithApple();
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
                    builder: (context) => InitAllergens(
                        user: FirebaseAuth.instance.currentUser!)));
              }
            },
          ));
    } else {
      return SizedBox(height: 5);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        child: Column(
          children: <Widget>[
            Container(
              height: 400,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/background.png'),
                      fit: BoxFit.fill)),
              child: Stack(
                children: <Widget>[
                  Positioned(
                      right: MediaQuery.of(context).size.width * 0.4,
                      top: 40,
                      width: 80,
                      height: 200,
                      child: Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/splash_icon.png'))),
                      )),
                  Positioned(
                      child: Container(
                    margin: EdgeInsets.only(top: 50),
                    child: Center(
                      child: Text(
                        "Sign In",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontFamily: "Inter Tight",
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ))
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(30.0),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                              color: Color.fromRGBO(143, 148, 251, .2),
                              blurRadius: 20.0,
                              offset: Offset(0, 10))
                        ]),
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom:
                                      BorderSide(color: Colors.grey[100]!))),
                          child: TextField(
                            decoration: InputDecoration(
                                labelStyle:
                                    TextStyle(fontFamily: "Inter Tight"),
                                border: InputBorder.none,
                                hintText: 'Enter your email address',
                                hintStyle: TextStyle(
                                    fontFamily: "Inter Tight",
                                    color: Colors.grey[400])),
                            onChanged: (value) => {
                              setState(() {
                                email = value.trim();
                              })
                            },
                          ), /* TextField(
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Email or Phone number",
                                hintStyle: TextStyle(
                                    color: Colors.grey[400],
                                    fontFamily: "Inter Tight")),
                          ), */
                        ),
                        Container(
                          padding: EdgeInsets.all(8.0),
                          child: TextField(
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Password",
                                hintStyle: TextStyle(
                                    color: Colors.grey[400],
                                    fontFamily: "Inter Tight")),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: 50,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Color.fromARGB(255, 211, 74, 74)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ))),
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
                        child: Text("Log in")),
                  ),
                  SizedBox(height: 30),
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
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.redAccent),
                                    )
                                  : Container(
                                      height: 50,
                                      child: OutlinedButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.white),
                                            shape: MaterialStateProperty.all(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            7)))),
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
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              child: CachedNetworkImage(
                                                  imageUrl:
                                                      'http://pngimg.com/uploads/google/google_PNG19635.png',
                                                  width: 30,
                                                  fit: BoxFit.cover),
                                            ),
                                            SizedBox(width: 5),
                                            const Text("Sign In with Google",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily: "Inter Tight",
                                                    fontWeight:
                                                        FontWeight.bold))
                                          ],
                                        ),
                                      ),
                                    ));
                        }
                        return const CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.redAccent),
                        );
                      }),
                  SizedBox(height: 20),
                  OutlinedButton(
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))))),
                      onPressed: () =>
                          {Navigator.of(context).push(_toRegisterPage())},
                      child: const Text("Create New Account",
                          style: TextStyle(
                              fontFamily: "Inter Tight",
                              fontWeight: FontWeight.bold)))
                ],
              ),
            )
          ],
        ),
      ),
    ));
  } /* SingleChildScrollView(
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
                            fontFamily: "Inter Tight",
                            fontSize: 36.0,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 30.0),
                    SizedBox(
                      width: 400,
                      child: TextField(
                        decoration: const InputDecoration(
                            labelText: "Email",
                            labelStyle: TextStyle(fontFamily: "Inter Tight"),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            hintText: 'Enter your email address',
                            hintStyle: TextStyle(fontFamily: "Inter Tight")),
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
                            labelText: "Password",
                            labelStyle: TextStyle(fontFamily: "Inter Tight"),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            hintText: 'Enter your password',
                            hintStyle: TextStyle(fontFamily: "Inter Tight")),
                        onChanged: (value) => {
                          setState(() => {password = value.trim()})
                        },
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Container(
                      width: 200,
                      height: 45,
                      child: TextButton(
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.login_rounded),
                              SizedBox(width: 5),
                              Text("Log in",
                                  style: TextStyle(
                                      fontFamily: "Inter Tight",
                                      fontWeight: FontWeight.bold))
                            ],
                          ),
                          style: ButtonStyle(
                              padding: MaterialStateProperty.all<EdgeInsets>(
                                  EdgeInsets.all(10)),
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.red),
                              foregroundColor:
                                  MaterialStateProperty.all(Colors.white),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(7)))))),
                    ),
                    SizedBox(height: 20),
                    const Text(
                      "Or sign in with these options: ",
                      style: TextStyle(
                          fontFamily: "Inter Tight",
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
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
                                                Colors.redAccent),
                                      )
                                    : Container(
                                        height: 50,
                                        child: OutlinedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.white),
                                              shape: MaterialStateProperty.all(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              7)))),
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
                                                                    user:
                                                                        user)));
                                              }
                                            }
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                child: CachedNetworkImage(
                                                    imageUrl:
                                                        'http://pngimg.com/uploads/google/google_PNG19635.png',
                                                    width: 30,
                                                    fit: BoxFit.cover),
                                              ),
                                              SizedBox(width: 5),
                                              const Text("Sign In with Google",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontFamily: "Inter Tight",
                                                      fontWeight:
                                                          FontWeight.bold))
                                            ],
                                          ),
                                        ),
                                      ));
                          }
                          return const CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.redAccent),
                          );
                        }),
                    SizedBox(height: 10),
                    Column(
                      children: [
                        Container(
                          width: 250,
                          child: _checkPlatform(context),
                        )
                      ],
                    ),
                    SizedBox(height: 40),
                    OutlinedButton(
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8))))),
                        onPressed: () =>
                            {Navigator.of(context).push(_toRegisterPage())},
                        child: const Text("Create New Account",
                            style: TextStyle(
                                fontFamily: "Inter Tight",
                                fontWeight: FontWeight.bold)))
                  ],
                ))) */
}
