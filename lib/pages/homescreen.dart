import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:foodica/pages/history.dart';
import 'package:foodica/pages/settings.dart';
import 'package:foodica/pages/tips.dart';
import 'package:foodica/widgets/scanner.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class HomeScreenPage extends StatefulWidget {
  const HomeScreenPage({Key key}) : super(key: key);

  @override 
  _HomeScreenPageState createState() => _HomeScreenPageState();


}

class _HomeScreenPageState extends State<HomeScreenPage> {

  void navigateToHistory() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HistoryPage()));
  }

  void navigateToSettings() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SettingsPage()));
  }

  void navigateToTips() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const TipsPage()));
  }
  
  @override
  Widget build(BuildContext context) {
    //to do: turn all of these views into actual pages
    //this will save on resources since we're making entirely new views every time we navigate to a new page
    //not very efficient you should be ashamed of this
    return Scaffold(
      drawer: Drawer(
  // Add a ListView to the drawer. This ensures the user can scroll
  // through the options in the drawer if there isn't enough vertical
  // space to fit everything.
  child: ListView(
    // Important: Remove any padding from the ListView.
    padding: EdgeInsets.zero,
    children: [
      DrawerHeader(
        decoration: BoxDecoration(
          image: new DecorationImage(
            image: AssetImage("assets/drawer-header.jpg"),
            fit: BoxFit.cover
          )
        ),
      ),
      ListTile(
        title: RichText(text: TextSpan(children: [
            WidgetSpan(child: Icon(Icons.home, size: 22)),
            TextSpan(text: "Home", style: TextStyle(
              color: Colors.black,
              fontFamily: "Poppins",
            ))
          ]),),
        onTap: () {
          // Update the state of the app.
          // ...
        },
      ),
      ListTile(
        title: RichText(text: TextSpan(children: [
            WidgetSpan(child: Icon(Icons.history, size: 22)),
            TextSpan(text: "History", style: TextStyle(
              color: Colors.black,
              fontFamily: "Poppins",
            ))
          ]),),
        onTap: () {
          navigateToHistory();
        },
      ),
      ListTile(
        title: RichText(text: TextSpan(children: [
            WidgetSpan(child: Icon(Icons.lightbulb, size: 22)),
            TextSpan(text: "Tips", style: TextStyle(
              color: Colors.black,
              fontFamily: "Poppins",
            ))
          ]),),
        onTap: () {
          navigateToTips();
        },
      ),
      ListTile(
        title: RichText(text: TextSpan(children: [
            WidgetSpan(child: Icon(Icons.account_box, size: 22)),
            TextSpan(text: "Extra", style: TextStyle(
              color: Colors.black,
              fontFamily: "Poppins",
            ))
          ]),),
        onTap: () {
          // Update the state of the app.
          // ...
        },
      ),
      ListTile(
        title: RichText(text: TextSpan(children: [
            WidgetSpan(child: Icon(Icons.settings, size: 22)),
            TextSpan(text: "Settings", style: TextStyle(
              color: Colors.black,
              fontFamily: "Poppins",
            ))
          ]),),
        onTap: () {
          navigateToSettings();
        },
      )
    ],
  ),
),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => ScannerWidget())),
        child: const Icon(Icons.add_rounded, size: 40),
        backgroundColor: Colors.red,
      ),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          
          leading: Builder(
            builder: (context) => IconButton(onPressed: () => Scaffold.of(context).openDrawer(), icon: new Icon(Icons.menu)),
          ),
          /* GestureDetector(
          onTap: () { 
           },
          child: const Icon(
              Icons.menu,  // add custom icons also
          ),
  ), */
          title: const Text("Home",
              style: TextStyle(
                fontFamily: "Poppins",
                fontWeight: FontWeight.bold,
              )),
        ),
        //page needs to be scrollable so the body is wrapped in a SingleChildScrollView
        body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20.0), child: const Text("Welcome", style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: "Poppins",
                  fontSize: 35
                )
                ),
                ),
                Column(children: [
                  Padding(
              padding: const EdgeInsets.all(12.0),
              child: Center(
                child: Wrap(
                  spacing:20,
                  runSpacing: 20.0,
                  children: <Widget>[
                    SizedBox(
                      width: 350.0,
                      height: 200.0,
                      child: Card(

                        color: const Color.fromARGB(255,255, 255, 255),
                        elevation: 2.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)
                        ),
                        child:Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 10.0,
                              ),
                              Icon(Icons.food_bank_outlined, size: 60,),
                              Text(
                                "Weekly Calories ",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30.0
                                ),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Text(
                                "1900/2400 calories",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20.0,
                                ),
                              )
                            ],
                            ),
                          )
                        ),
                      ),
                    ),
              ],
              
                )
                )
    )
                ],),
                Column(children: [
                  Padding(
              padding: const EdgeInsets.all(12.0),
              child: Center(
                child: Wrap(
                  spacing:20,
                  runSpacing: 20.0,
                  children: <Widget>[
                    SizedBox(
                      width: 350.0,
                      height: 200.0,
                      child: Card(

                        color: Color.fromARGB(255,255, 255, 255),
                        elevation: 2.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)
                        ),
                        child:Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 10.0,
                              ),
                              Icon(Icons.food_bank_outlined, size: 60,),
                              Text(
                                "Weekly Calories ",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30.0
                                ),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Text(
                                "1900/2400 calories",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20.0,
                                ),
                              )
                            ],
                            ),
                          )
                        ),
                      ),
                    ),
              ],
              
                )
                )
    )
                ],),
                Column(children: [
                  Padding(
              padding: const EdgeInsets.all(12.0),
              child: Center(
                child: Wrap(
                  spacing:20,
                  runSpacing: 20.0,
                  children: <Widget>[
                    SizedBox(
                      width: 350.0,
                      height: 200.0,
                      child: Card(

                        color: Color.fromARGB(255,255, 255, 255),
                        elevation: 2.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)
                        ),
                        child:Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 10.0,
                              ),
                              Icon(Icons.food_bank_outlined, size: 60,),
                              Text(
                                "Weekly Calories ",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30.0
                                ),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Text(
                                "1900/2400 calories",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20.0,
                                ),
                              )
                            ],
                            ),
                          )
                        ),
                      ),
                    ),
              ],
              
                )
                )
    )
                ],)
                
              ])
        )
    );
        
  }

}