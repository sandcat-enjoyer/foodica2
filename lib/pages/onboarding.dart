import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Foodica/data/data.dart';
import 'package:Foodica/pages/login.dart';
import 'dart:io';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  List<SliderModel> mySlides = <SliderModel>[];
  int slideIndex = 0;
  PageController? controller;
  late User loggedInUser;
  late bool isLoggedIn = false;

  Widget _buildPageIndicator(bool isCurrentPage) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2.0),
      height: isCurrentPage ? 10.0 : 6.0,
      width: isCurrentPage ? 10.0 : 6.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    mySlides = getSlides();
    controller = PageController();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
        body: SizedBox(
          height: MediaQuery.of(context).size.height - 100,
          child: PageView(
            physics: BouncingScrollPhysics(),
            controller: controller,
            onPageChanged: (index) {
              setState(() {
                slideIndex = index;
              });
            },
            children: <Widget>[
              SlideTile(
                imagePath: mySlides[0].getImageAssetPath(),
                title: mySlides[0].getTitle(),
                desc: mySlides[0].getDesc(),
              ),
              SlideTile(
                imagePath: mySlides[1].getImageAssetPath(),
                title: mySlides[1].getTitle(),
                desc: mySlides[1].getDesc(),
              ),
              SlideTile(
                imagePath: mySlides[2].getImageAssetPath(),
                title: mySlides[2].getTitle(),
                desc: mySlides[2].getDesc(),
              )
            ],
          ),
        ),
        bottomSheet: slideIndex != 2
            ? Container(
                margin: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    TextButton(
                      onPressed: () {
                        controller!.animateToPage(2,
                            duration: const Duration(milliseconds: 150),
                            curve: Curves.easeInOut);
                      },
                      child: const Text(
                        "Skip",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontFamily: "Poppins"),
                      ),
                    ),
                    Row(
                      children: [
                        for (int i = 0; i < 3; i++)
                          i == slideIndex
                              ? _buildPageIndicator(true)
                              : _buildPageIndicator(false),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        controller!.animateToPage(slideIndex + 1,
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeInOut);
                      },
                      child: const Text(
                        "Next",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontFamily: "Poppins"),
                      ),
                    ),
                  ],
                ),
              )
            : InkWell(
                onTap: () async {
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return const Center(
                            child:
                                CircularProgressIndicator(color: Colors.red));
                      });
                  await Future.delayed(const Duration(seconds: 2), () {});
                  navigateToLogin();
                },
                child: Container(
                  height: Platform.isIOS ? 70 : 60,
                  color: Colors.blue,
                  alignment: Alignment.center,
                  child: const Text("Get Started",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Poppins",
                          fontSize: 18)),
                ),
              ),
      ),
    );
  }

  navigateToLogin() async {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginPage()));
  }
}

class SlideTile extends StatelessWidget {
  final String imagePath, title, desc;

  SlideTile(
      {Key? key,
      required this.imagePath,
      required this.title,
      required this.desc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(imagePath),
          const SizedBox(
            height: 20,
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
                fontFamily: "Poppins"),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(desc,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  fontFamily: "Poppins"))
        ],
      ),
    );
  }
}
