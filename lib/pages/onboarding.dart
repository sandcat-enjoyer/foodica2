import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodica/data/data.dart';
import 'package:foodica/pages/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'homescreen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int introViewed = 0;
  List<SliderModel> mySLides = <SliderModel>[];
  int slideIndex = 0;
  PageController? controller;

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<bool> _isIntroViewed;

  Future<void> _introWasViewed() async {
    final SharedPreferences prefs = await _prefs;
    final bool isIntroViewed = true;

    setState(() {
      _isIntroViewed =
          prefs.setBool("isIntroViewed", isIntroViewed).then((bool success) {
        return isIntroViewed;
      });
    });
  }

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
    // TODO: implement initState
    super.initState();
    mySLides = getSlides();
    controller = PageController();
    _isIntroViewed = _prefs.then((SharedPreferences prefs) {
      return prefs.getBool("isIntroViewed") ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
        body: SizedBox(
          height: MediaQuery.of(context).size.height - 100,
          child: PageView(
            controller: controller,
            onPageChanged: (index) {
              setState(() {
                slideIndex = index;
              });
            },
            children: <Widget>[
              SlideTile(
                imagePath: mySLides[0].getImageAssetPath(),
                title: mySLides[0].getTitle(),
                desc: mySLides[0].getDesc(),
              ),
              SlideTile(
                imagePath: mySLides[1].getImageAssetPath(),
                title: mySLides[1].getTitle(),
                desc: mySLides[1].getDesc(),
              ),
              SlideTile(
                imagePath: mySLides[2].getImageAssetPath(),
                title: mySLides[2].getTitle(),
                desc: mySLides[2].getDesc(),
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
                            duration: const Duration(milliseconds: 250),
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
                onTap: () {
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

  /* Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const HomeScreenPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        final tween = Tween(begin: begin, end: end);
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: curve,
        );

        return SlideTransition(
          position: tween.animate(curvedAnimation),
          child: child,
        );
      },
    );
  } */

  void navigateToHome() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const HomeScreenPage()));
  }

  navigateToLogin() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const HomeScreenPage()));
  }
}

class SlideTile extends StatelessWidget {
  String imagePath, title, desc;

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
