import 'package:Foodica/pages/add_food_manual.dart';
import 'package:Foodica/utils/uuid.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter/material.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';

import '../models/scanned_product.dart';

class DetailPage extends StatefulWidget {
  const DetailPage(
      {Key? key,
      required this.barcode,
      required firebase.User user,
      required this.isFromScan})
      : _user = user,
        super(key: key);
  final String barcode;
  final firebase.User _user;
  final bool isFromScan;

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late Colors fatColor;
  late firebase.User user;
  late Future<int> _dailyCalories;
  late Future<int> _weeklyCalories;
  Uuid uuid = Uuid();
  final fb = FirebaseDatabase.instance;
  //need a new way for this but i can only find solutions using a deprecated method
  final databaseReference = FirebaseDatabase(
          databaseURL:
              "https://foodica-9743c-default-rtdb.europe-west1.firebasedatabase.app")
      .ref();
  int _dailyCaloriesInt = 0;
  int? weeklyCaloriesInt;
  List<String> allergens = [];
  Product scannedProduct = Product();

  bool productIsLoaded = false;
  bool? productFound;
  String productImgUrl = "";

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    super.initState();
    user = widget._user;
    _dailyCalories = _prefs.then((SharedPreferences prefs) {
      _dailyCaloriesInt = prefs.getInt("daily") ?? 0;
      return prefs.getInt("daily") ?? 0;
    });
    _weeklyCalories = _prefs.then((SharedPreferences prefs) {
      weeklyCaloriesInt = prefs.getInt("weekly") ?? 0;
      return prefs.getInt("weekly") ?? 0;
    });
    getProduct();
  }

  Future<Product?> getProduct() async {
    var barcode = widget.barcode;

    ProductQueryConfiguration configuration = ProductQueryConfiguration(barcode,
        language: OpenFoodFactsLanguage.ENGLISH, fields: [ProductField.ALL]);
    ProductResult result = await OpenFoodAPIClient.getProduct(configuration);

    if (result.status == 1) {
      Future.delayed(Duration(milliseconds: 500), () {
        setState(() {
          scannedProduct = result.product!;
          result.product?.allergens!.names.forEach((element) {
            allergens.add(element);
          });
          productIsLoaded = true;
        });
      });
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              title: Text(
                "Product not found",
                style: TextStyle(
                    fontFamily: "Poppins", fontWeight: FontWeight.bold),
              ),
              content: Text(
                  "Try scanning the product barcode again. If that doesn't work, add the details of this product manually.",
                  style: TextStyle(fontFamily: "Poppins")),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Close",
                      style: TextStyle(fontFamily: "Poppins"),
                    ))
              ],
            );
          });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _saveCaloriesToMemory() async {
    if (widget.isFromScan != false) {
      if (scannedProduct.productName != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt(
            "daily",
            (_dailyCaloriesInt +
                scannedProduct.nutriments!.energyKcal!.round()));
        await prefs.setInt(
            "weekly",
            weeklyCaloriesInt! +
                scannedProduct.nutriments!.energyKcal!.round());
        await prefs.setString("productname", scannedProduct.productName!);
      }
    }
  }

  _checkCalories() {
    if (scannedProduct.nutriments?.energyKcal != null) {
      return scannedProduct.nutriments!.energyKcal!.toStringAsFixed(2) + "Kcal";
    } else {
      return "Not Found";
    }
  }

  Widget _buildCaloriesCard() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Center(
            child: Wrap(
              spacing: 20,
              runSpacing: 20.0,
              children: <Widget>[
                SizedBox(
                    width: 300.0,
                    height: 180.0,
                    child: Card(
                      elevation: 2.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                      child: Center(
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: <Widget>[
                                  const SizedBox(height: 10.0),
                                  const Text("Calories",
                                      style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontSize: 30.0,
                                        fontWeight: FontWeight.w800,
                                      )),
                                  const SizedBox(height: 10.0),
                                  Text(_checkCalories(),
                                      style: const TextStyle(
                                        fontFamily: "Poppins",
                                        fontSize: 30.0,
                                        fontWeight: FontWeight.w600,
                                      ))
                                ],
                              ))),
                    ))
              ],
            ),
          ),
        )
      ],
    );
  }

  _checkFat() {
    if (scannedProduct.nutriments?.fat != null) {
      return scannedProduct.nutriments!.fat!.toStringAsFixed(2) + "g";
    } else {
      return "Not Found";
    }
  }

  Widget _buildFatLevelsCard() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Center(
            child: Wrap(
              spacing: 20,
              runSpacing: 20.0,
              children: <Widget>[
                SizedBox(
                    width: 300.0,
                    height: 180.0,
                    child: Card(
                      elevation: 2.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                      child: Center(
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: <Widget>[
                                  const SizedBox(height: 10.0),
                                  const Text("Fat",
                                      style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontSize: 30.0,
                                        fontWeight: FontWeight.w800,
                                      )),
                                  const SizedBox(height: 10.0),
                                  Text(_checkFat(),
                                      style: const TextStyle(
                                        fontFamily: "Poppins",
                                        fontSize: 30.0,
                                        fontWeight: FontWeight.w600,
                                      ))
                                ],
                              ))),
                    ))
              ],
            ),
          ),
        )
      ],
    );
  }

  _checkSaturatedFat() {
    if (scannedProduct.nutriments?.saturatedFat != null) {
      return scannedProduct.nutriments!.fat!.toStringAsFixed(2) + "g";
    } else {
      return "Not Found";
    }
  }

  Widget _buildSaturatedFatCard() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Center(
            child: Wrap(
              spacing: 20,
              runSpacing: 20.0,
              children: <Widget>[
                SizedBox(
                    width: 300.0,
                    height: 180.0,
                    child: Card(
                      elevation: 2.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                      child: Center(
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: <Widget>[
                                  const SizedBox(height: 10.0),
                                  const Text("Saturated Fats",
                                      style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontSize: 25.0,
                                        fontWeight: FontWeight.w800,
                                      )),
                                  const SizedBox(height: 10.0),
                                  Text(_checkSaturatedFat(),
                                      style: const TextStyle(
                                        fontFamily: "Poppins",
                                        fontSize: 30.0,
                                        fontWeight: FontWeight.w600,
                                      ))
                                ],
                              ))),
                    ))
              ],
            ),
          ),
        )
      ],
    );
  }

  _checkSalt() {
    if (scannedProduct.nutriments?.salt != null) {
      return scannedProduct.nutriments!.salt!.toStringAsFixed(2) + "g";
    } else {
      return "Not Found";
    }
  }

  _showAllergens() {
    String allergenString = "";
    for (int i = 0; i <= allergens.length - 1; i++) {
      if (allergens.length != 0) {
        allergenString += allergens[i] + "\n";
      } else {
        allergenString = "No allergens found";
      }
    }
    return Text(
      allergenString,
      style: TextStyle(
          fontFamily: "Poppins", fontSize: 20, fontWeight: FontWeight.w600),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildSaltCard() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Center(
            child: Wrap(
              spacing: 20,
              runSpacing: 20.0,
              children: <Widget>[
                SizedBox(
                    width: 300.0,
                    height: 180.0,
                    child: Card(
                      elevation: 2.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                      child: Center(
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: <Widget>[
                                  const SizedBox(height: 10.0),
                                  const Text("Salt",
                                      style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontSize: 25.0,
                                        fontWeight: FontWeight.w800,
                                      )),
                                  const SizedBox(height: 10.0),
                                  Text(_checkSalt(),
                                      style: const TextStyle(
                                        fontFamily: "Poppins",
                                        fontSize: 30.0,
                                        fontWeight: FontWeight.w600,
                                      ))
                                ],
                              ))),
                    ))
              ],
            ),
          ),
        )
      ],
    );
  }

  _checkSugar() {
    if (scannedProduct.nutriments?.sugars != null) {
      return scannedProduct.nutriments!.sugars!.toStringAsFixed(2) + "g";
    } else {
      return "Not Found";
    }
  }

  _manuallyAddDetailsPopUp() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            title: Text("Not all product values found",
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.bold,
                )),
            content: StatefulBuilder(
              builder: (context, SBsetState) {
                return Text(
                    "Some values of this product were not found in the Open Food Facts database. Would you like to add these values manually?",
                    style: TextStyle(
                      fontFamily: "Poppins",
                    ));
              },
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    ScannedProduct product = ScannedProduct(
                        productID: uuid.generateV4(),
                        productDetail: ProductDetail(
                          code: scannedProduct.barcode,
                          productname: scannedProduct.productName ?? "",
                          brand: scannedProduct.brands ?? "",
                          calories: scannedProduct.nutriments!.energyKcal100g
                              .toString(),
                          fat: scannedProduct.nutriments?.fat.toString() ?? "0",
                          salt:
                              scannedProduct.nutriments?.salt.toString() ?? "0",
                          sugar: scannedProduct.nutriments?.sugars.toString() ??
                              "0",
                          image: scannedProduct.imagePackagingUrl ?? "",
                          scanTime: DateTime.now(),
                          allergens: scannedProduct.allergens!.names,
                          saturatedFat: scannedProduct.nutriments?.saturatedFat
                                  .toString() ??
                              "",
                          category: scannedProduct.categories ?? "",
                        ));
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            ManualFoodPage(user: user, product: product)));
                  },
                  child: Text("Add Details",
                      style: TextStyle(
                          fontFamily: "Poppins", fontWeight: FontWeight.bold))),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancel", style: TextStyle(fontFamily: "Poppins")),
              )
            ],
          );
        });
  }

  Widget _buildSugarCard() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Center(
            child: Wrap(
              spacing: 20,
              runSpacing: 20.0,
              children: <Widget>[
                SizedBox(
                    width: 300.0,
                    height: 180.0,
                    child: Card(
                      elevation: 2.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                      child: Center(
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: <Widget>[
                                  const SizedBox(height: 10.0),
                                  const Text("Sugar",
                                      style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontSize: 30.0,
                                        fontWeight: FontWeight.w800,
                                      )),
                                  const SizedBox(height: 10.0),
                                  Text(_checkSugar(),
                                      style: const TextStyle(
                                        fontFamily: "Poppins",
                                        fontSize: 30.0,
                                        fontWeight: FontWeight.w600,
                                      ))
                                ],
                              ))),
                    ))
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _getProductImage() {
    String url = "";
    if (scannedProduct.imagePackagingUrl != null) {
      url = scannedProduct.imagePackagingUrl!;
      return CachedNetworkImage(imageUrl: url, width: 300);
    } else {
      return Column(
        children: [
          Image.asset("assets/splash_icon.png", width: 300),
          SizedBox(height: 10),
          Text("No Product Image Found",
              style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 16,
                  fontWeight: FontWeight.bold))
        ],
      );
    }
  }

  Widget _checkAllergens() {
    if (scannedProduct.allergens != "") {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Center(
              child: Wrap(
                spacing: 20,
                runSpacing: 20.0,
                children: <Widget>[
                  SizedBox(
                      width: 300.0,
                      child: Card(
                        elevation: 2.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                        child: Center(
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(height: 10.0),
                                    Text("Allergens",
                                        style: TextStyle(
                                            fontFamily: "Poppins",
                                            fontSize: 30.0,
                                            fontWeight: FontWeight.w800)),
                                    SizedBox(height: 10.0),
                                    _showAllergens()
                                  ],
                                ))),
                      ))
                ],
              ),
            ),
          )
        ],
      );
    } else {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Center(
              child: Wrap(
                spacing: 20,
                runSpacing: 20.0,
                children: <Widget>[
                  SizedBox(
                      width: 300.0,
                      height: 180.0,
                      child: Card(
                        elevation: 2.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                        child: Center(
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: const <Widget>[
                                    SizedBox(height: 10.0),
                                    Text("Allergens",
                                        style: TextStyle(
                                            fontFamily: "Poppins",
                                            fontSize: 30.0,
                                            fontWeight: FontWeight.w800)),
                                    SizedBox(height: 10.0),
                                    Text("None",
                                        style: TextStyle(
                                            fontFamily: "Poppins",
                                            fontSize: 30.0,
                                            fontWeight: FontWeight.w600))
                                  ],
                                ))),
                      ))
                ],
              ),
            ),
          )
        ],
      );
    }
  }

  _pushToDatabase() {
    _saveCaloriesToMemory();
    final productRef =
        databaseReference.child("users/" + user.uid + "/products");
    if (widget.isFromScan == true) {
      if (scannedProduct.productName != null) {
        productRef
            .push()
            .set({
              'productID': uuid.generateV4(),
              "product": {
                "code": scannedProduct.barcode,
                "productname": scannedProduct.productName ?? "",
                'brand': scannedProduct.brands ?? "",
                'category': scannedProduct.categories ?? "",
                'calories': scannedProduct.nutriments?.energyKcal ?? 0,
                'image': scannedProduct.imagePackagingUrl ?? 0,
                'allergens': scannedProduct.allergens?.names ?? [""],
                'fat': scannedProduct.nutriments?.fat ?? 0,
                'saturatedFat': scannedProduct.nutriments?.saturatedFat ?? 0,
                'salt': scannedProduct.nutriments?.salt ?? 0,
                'sugar': scannedProduct.nutriments?.sugars ?? 0,
                "scanTime": DateTime.now().toString()
              },
            })
            .then((_) => print("Product was written to the database"))
            .catchError((error) => print("Error: " + error));
      }
    }
  }

  Widget? _buildPage() {
    if (productIsLoaded == false) {
      return const Center(child: CircularProgressIndicator());
    } else {
      Future.delayed(Duration.zero, () {
        if (scannedProduct.nutriments?.energyKcal100g == null ||
            scannedProduct.nutriments?.saturatedFat == null ||
            scannedProduct.nutriments?.fat == null ||
            scannedProduct.nutriments?.salt == null ||
            scannedProduct.nutriments?.sugars == null) {
          _manuallyAddDetailsPopUp();
        }
      });
      _pushToDatabase();
      return SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20.0),
              child: const Text("Product Details",
                  style: TextStyle(
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.bold,
                      fontSize: 30.0)),
            ),
            _getProductImage(),
            const SizedBox(height: 10.0),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Center(
                    child: Wrap(
                      spacing: 20,
                      runSpacing: 20.0,
                      children: <Widget>[
                        SizedBox(
                            width: 300.0,
                            child: Card(
                              elevation: 2.0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0)),
                              child: Center(
                                  child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: <Widget>[
                                          const SizedBox(height: 10.0),
                                          const Text("Product Name",
                                              style: TextStyle(
                                                  fontFamily: "Poppins",
                                                  fontSize: 28.0,
                                                  fontWeight: FontWeight.w800)),
                                          const SizedBox(height: 10.0),
                                          Text(scannedProduct.productName ?? "",
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  fontFamily: "Poppins",
                                                  fontSize: 22.0,
                                                  fontWeight: FontWeight.w600))
                                        ],
                                      ))),
                            ))
                      ],
                    ),
                  ),
                )
              ],
            ),
            _checkAllergens(),
            _buildCaloriesCard(),
            _buildFatLevelsCard(),
            _buildSaltCard(),
            _buildSugarCard(),
            _buildSaturatedFatCard()
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          centerTitle: true,
          title: const Text("Foodica",
              style: TextStyle(
                  fontFamily: "Poppins", fontWeight: FontWeight.bold)),
        ),
        body: _buildPage());
  }
}
