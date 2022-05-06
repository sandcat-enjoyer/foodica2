import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TipsPage extends StatefulWidget {
  const TipsPage({Key? key, required User user})
      : _user = user,
        super(key: key);

  final User _user;
  @override
  _TipsPageState createState() => _TipsPageState();
}

class _TipsPageState extends State<TipsPage> {
  late User _user;
  String allergen = "";

  _determineTips() {
    switch (allergen) {
      case "gluten":
        return Column(children: [
          Card(
              child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    "assets/drawer-header.jpg",
                    height: 240,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                      child: Column(
                    children: const [
                      Text("Avoid processed foods",
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 28,
                              fontWeight: FontWeight.bold)),
                      Text(
                          "This means avoiding things as salad dressings, luncheon meats, vegetarian mock meats and soup stocks.",
                          style: TextStyle(fontFamily: "Poppins", fontSize: 16))
                    ],
                  ))),
            ],
          )),
          const SizedBox(height: 30),
          Card(
              child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    "assets/drawer-header.jpg",
                    height: 240,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                      child: Column(
                    children: const [
                      Text("Avoid products containing wheat, rye and barley",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 28,
                              fontWeight: FontWeight.bold)),
                      Text(
                          "Try to avoid products like bread or pasta as much as you can.",
                          style: TextStyle(fontFamily: "Poppins", fontSize: 16))
                    ],
                  ))),
            ],
          )),
          const SizedBox(height: 30),
          Card(
              child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    "assets/drawer-header.jpg",
                    height: 240,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                      child: Column(
                    children: const [
                      Text("Eat more whole grains",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 28,
                              fontWeight: FontWeight.bold)),
                      Text(
                          "Products like rice, white rice, millet, seeds, beans and nuts are ideal in this case.",
                          style: TextStyle(fontFamily: "Poppins", fontSize: 16))
                    ],
                  ))),
            ],
          )),
        ]);
        break;
      case "eggs":
        return Column(children: [
          Card(
              child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    "assets/drawer-header.jpg",
                    height: 240,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                      child: Column(
                    children: const [
                      Text("Avoid eating products with eggs",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 28,
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Text(
                          "Unfortunately this isn't as simple as it seems. A lot of products have eggs hidden in them. You have to be extra careful reading the labels on the products you consume.",
                          style: TextStyle(fontFamily: "Poppins", fontSize: 16))
                    ],
                  ))),
            ],
          )),
          const SizedBox(height: 30),
          Card(
              child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    "assets/drawer-header.jpg",
                    height: 240,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                      child: Column(
                    children: const [
                      Text("Egg substitutes",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 28,
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Text(
                          "There are many recipes that can still be modified to avoid the need for eggs. If your recipe needs 3 or fewer eggs, you can substitute this with a mix of 1 tablespoon water, 1 tablespoon oil and 1 teaspoon of baking powder.",
                          style: TextStyle(fontFamily: "Poppins", fontSize: 16))
                    ],
                  ))),
            ],
          ))
        ]);
      case "soy":
        return Column(
          children: [
            Card(
                child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      "assets/drawer-header.jpg",
                      height: 240,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Padding(
                    padding: const EdgeInsets.all(20),
                    child: Center(
                        child: Column(
                      children: const [
                        Text("Foods to avoid",
                            style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 28,
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                        Text(
                            "These include the following: \nEdamame\nGlycine max\nKinako\nMiso\nNatto",
                            style:
                                TextStyle(fontFamily: "Poppins", fontSize: 16))
                      ],
                    ))),
              ],
            )),
            const SizedBox(height: 30),
            Card(
                child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      "assets/drawer-header.jpg",
                      height: 240,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Padding(
                    padding: const EdgeInsets.all(20),
                    child: Center(
                        child: Column(
                      children: const [
                        Text("Be careful at restaurants",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 28,
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                        Text(
                            "Even if you order a soy-free dish, you could still be exposed because the ingredient is used so often in foods from Asian cultures. A cook might use the same utensil on soy and non-soy dishes. Explain that you need to be sure your food doesn’t touch soy in any way.",
                            style:
                                TextStyle(fontFamily: "Poppins", fontSize: 16))
                      ],
                    ))),
              ],
            ))
          ],
        );
      case "peanuts":
        return Column(children: [
          Card(
              child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    "assets/drawer-header.jpg",
                    height: 240,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                      child: Column(
                    children: const [
                      Text(
                          "Avoid foods containing any of the following ingredients",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 28,
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Text(
                          "Arachis hypogaea\nBeer nuts\nCacahuete\nChinese nuts\nEarthnuts\nGroundnuts\nMadelonas\nMonkey nuts",
                          style: TextStyle(fontFamily: "Poppins", fontSize: 16))
                    ],
                  ))),
            ],
          )),
        ]);
      case "milk":
        return Column(children: [
          Card(
              child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    "assets/drawer-header.jpg",
                    height: 240,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                      child: Column(
                    children: const [
                      Text(
                          "Look for low-lactose or lactose-free dairy products",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 28,
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Text(
                          "Products are widely available and can include products like milk, yoghurt, cheese, ice cream and others",
                          style: TextStyle(fontFamily: "Poppins", fontSize: 16))
                    ],
                  ))),
            ],
          )),
          const SizedBox(height: 30),
          Card(
              child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    "assets/drawer-header.jpg",
                    height: 240,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                      child: Column(
                    children: const [
                      Text("Eat foods with active cultures",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 28,
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Text(
                          "Active cultures in foods makes lactose easier to digest for people with this allergy.",
                          style: TextStyle(fontFamily: "Poppins", fontSize: 16))
                    ],
                  ))),
            ],
          )),
        ]);
      default:
        return Card(
            child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  "assets/drawer-header.jpg",
                  height: 240,
                  fit: BoxFit.cover,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Padding(
                padding: const EdgeInsets.all(20),
                child: Center(
                    child: Column(
                  children: const [
                    Text("This is a title",
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 28,
                            fontWeight: FontWeight.bold)),
                    Text("Subtitle",
                        style: TextStyle(fontFamily: "Poppins", fontSize: 16))
                  ],
                ))),
          ],
        ));
    }
  }

  _getTipsFromMemory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      allergen = prefs.getString("allergen")!;
    });
  }

  @override
  void initState() {
    super.initState();
    _getTipsFromMemory();
    _determineTips();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20.0),
          child: Text("Tips for " + allergen,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: "Poppins",
                  fontSize: 35)),
        ),
        const SizedBox(height: 8.0),
        _determineTips()
      ],
    )));
  }
}
