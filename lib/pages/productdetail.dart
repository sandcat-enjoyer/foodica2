import 'package:Foodica/utils/uuid.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:openfoodfacts/model/Product.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key, required this.barcode}) : super(key: key);
  final String barcode;

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late Colors fatColor;
  late Future<int> _weeklyCalories;
  Uuid uuid = Uuid();
  final fb = FirebaseDatabase.instance;
  //need a new way for this but i can only find solutions using a deprecated method
  final databaseReference = FirebaseDatabase(
          databaseURL:
              "https://foodica-9743c-default-rtdb.europe-west1.firebasedatabase.app")
      .ref();
  int _weeklyCaloriesInt = 0;
  int _productCalories = 0;
  Product scannedProduct = Product();

  bool productIsLoaded = false;
  String productImgUrl = "";

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    super.initState();
    _weeklyCalories = _prefs.then((SharedPreferences prefs) {
      _weeklyCaloriesInt = prefs.getInt("weekly")!;
      debugPrint(_weeklyCaloriesInt.toString());
      return prefs.getInt("weekly") ?? 0;
    });
    getProduct();
    _saveCaloriesToMemory();
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
          productIsLoaded = true;
        });
      });
    } else {
      throw Exception("Product not found");
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  // void _getProduct(String barcode) {
  //   ProductApi.fetchProduct(barcode).then((result) {
  //     setState(() {
  //       scanProperties.status = result.status;
  //       scannedProduct.productname = result.product!.productname;
  //       scannedProduct.brand = result.product!.brand;
  //       scannedProduct.category = result.product!.category;
  //       scannedProduct.image = result.product!.image;
  //       scannedProduct.nutriments = result.product!.nutriments;
  //       scannedProduct.nutrientLevels = result.product!.nutrientLevels;
  //       if (result.product!.allergens == "") {
  //         scannedProduct.allergens = "None";
  //       } else {
  //         scannedProduct.allergens = result.product!.allergens;
  //       }
  //       debugPrint("Product loaded: " + productIsLoaded.toString());
  //       productIsLoaded = true;
  //       debugPrint("Now what? " + productIsLoaded.toString());
  //       if (result.product!.nutriments.energyKcal != null) {
  //         _productCalories = result.product!.nutriments.energyKcal!.toInt();
  //       } else {
  //         _productCalories = 0;
  //       }
  //       debugPrint(_productCalories.toString());
  //     });
  //     _saveCaloriesToMemory();
  //   });
  // }

  void _saveCaloriesToMemory() async {
    if (scannedProduct.nutriments?.energyKcal != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt("weekly", (_weeklyCaloriesInt + _productCalories));
      debugPrint(prefs.getInt("weekly").toString());
      await prefs.setString("productname", scannedProduct.productName!);
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
    print(scannedProduct.allergens!.names);
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

  // Color _checkFatAmount() {
  //   switch (scannedProduct.nutrientLevels?.levels) {
  //     case "low":
  //       return Colors.green;
  //     case "moderate":
  //       return Colors.orange;
  //     case "high":
  //       return Colors.red;
  //   }
  //   return const Color.fromARGB(255, 64, 64, 64);
  // }
  //
  // Color _checkSaltAmount() {
  //   switch (scannedProduct.nutrientLevels!.salt) {
  //     case "low":
  //       return Colors.green;
  //     case "moderate":
  //       return Colors.orange;
  //     case "high":
  //       return Colors.red;
  //   }
  //   return const Color.fromARGB(255, 64, 64, 64);
  // }
  //
  // Color _checkSatFatAmount() {
  //   switch (scannedProduct.nutrientLevels!.saturatedFat) {
  //     case "low":
  //       return Colors.green;
  //     case "moderate":
  //       return Colors.orange;
  //     case "high":
  //       return Colors.red;
  //   }
  //   return const Color.fromARGB(255, 64, 64, 64);
  // }
  //
  // Color _checkSugarAmount() {
  //   switch (scannedProduct.nutrientLevels!.sugars) {
  //     case "low":
  //       return Colors.green;
  //     case "moderate":
  //       return Colors.orange;
  //     case "high":
  //       return Colors.red;
  //   }
  //   return const Color.fromARGB(255, 64, 64, 64);
  // }

  Widget _getProductImage() {
    String url = "";
    if (scannedProduct.imagePackagingUrl != null) {
      url = scannedProduct.imagePackagingUrl!;
      return CachedNetworkImage(imageUrl: url);
    } else {
      url = "https://via.placeholder.com/300";
      return CachedNetworkImage(imageUrl: url);
    }
  }

  // Widget _getSaltLevel() {
  //   if (scannedProduct.nutriments?.salt != null) {
  //     return Column(
  //       children: [
  //         Padding(
  //           padding: const EdgeInsets.all(12.0),
  //           child: Center(
  //             child: Wrap(
  //               spacing: 20,
  //               runSpacing: 20.0,
  //               children: <Widget>[
  //                 SizedBox(
  //                     width: 300.0,
  //                     height: 180.0,
  //                     child: Card(
  //                       elevation: 2.0,
  //                       shape: RoundedRectangleBorder(
  //                           borderRadius: BorderRadius.circular(8.0)),
  //                       child: Center(
  //                           child: Padding(
  //                               padding: const EdgeInsets.all(8.0),
  //                               child: Column(
  //                                 children: <Widget>[
  //                                   const SizedBox(height: 10.0),
  //                                   const Text("Salt",
  //                                       style: TextStyle(
  //                                           fontFamily: "Poppins",
  //                                           fontSize: 30.0,
  //                                           fontWeight: FontWeight.w800,
  //                                           )),
  //                                   const SizedBox(height: 10.0),
  //                                   Text(
  //                                       scannedProduct.nutriments!.salt!
  //                                               .toStringAsPrecision(2) +
  //                                           "g",
  //                                       style: const TextStyle(
  //                                           fontFamily: "Poppins",
  //                                           fontSize: 30.0,
  //                                           fontWeight: FontWeight.w600,
  //                                           ))
  //                                 ],
  //                               ))),
  //                     ))
  //               ],
  //             ),
  //           ),
  //         )
  //       ],
  //     );
  //   } else {
  //     return Column(
  //       children: [
  //         Padding(
  //           padding: const EdgeInsets.all(12.0),
  //           child: Center(
  //             child: Wrap(
  //               spacing: 20,
  //               runSpacing: 20.0,
  //               children: <Widget>[
  //                 SizedBox(
  //                     width: 300.0,
  //                     height: 180.0,
  //                     child: Card(
  //                       elevation: 2.0,
  //                       shape: RoundedRectangleBorder(
  //                           borderRadius: BorderRadius.circular(8.0)),
  //                       child: Center(
  //                           child: Padding(
  //                               padding: const EdgeInsets.all(8.0),
  //                               child: Column(
  //                                 children: const <Widget>[
  //                                   SizedBox(height: 10.0),
  //                                   Text("Saturated Fats",
  //                                       style: TextStyle(
  //                                           fontFamily: "Poppins",
  //                                           fontSize: 25.0,
  //                                           fontWeight: FontWeight.w800,
  //                                           )),
  //                                   SizedBox(height: 10.0),
  //                                   Text("Not Found",
  //                                       style: TextStyle(
  //                                           fontFamily: "Poppins",
  //                                           fontSize: 30.0,
  //                                           fontWeight: FontWeight.w600,
  //                                           ))
  //                                 ],
  //                               ))),
  //                     ))
  //               ],
  //             ),
  //           ),
  //         )
  //       ],
  //     );
  //   }
  // }
  //
  // Widget _getFatLevels() {
  //   if (scannedProduct.nutriments?.fat != null) {
  //     return Column(
  //       children: [
  //         Padding(
  //           padding: const EdgeInsets.all(12.0),
  //           child: Center(
  //             child: Wrap(
  //               spacing: 20,
  //               runSpacing: 20.0,
  //               children: <Widget>[
  //                 SizedBox(
  //                     width: 300.0,
  //                     height: 180.0,
  //                     child: Card(
  //
  //                       elevation: 2.0,
  //                       shape: RoundedRectangleBorder(
  //                           borderRadius: BorderRadius.circular(8.0)),
  //                       child: Center(
  //                           child: Padding(
  //                               padding: const EdgeInsets.all(8.0),
  //                               child: Column(
  //                                 children: <Widget>[
  //                                   const SizedBox(height: 10.0),
  //                                   const Text("Fat",
  //                                       style: TextStyle(
  //                                           fontFamily: "Poppins",
  //                                           fontSize: 30.0,
  //                                           fontWeight: FontWeight.w800,
  //                                           )),
  //                                   const SizedBox(height: 10.0),
  //                                   Text(
  //                                       scannedProduct.nutriments!.fat!
  //                                               .toStringAsFixed(2) +
  //                                           "g",
  //                                       style: const TextStyle(
  //                                           fontFamily: "Poppins",
  //                                           fontSize: 30.0,
  //                                           fontWeight: FontWeight.w600,
  //                                           ))
  //                                 ],
  //                               ))),
  //                     ))
  //               ],
  //             ),
  //           ),
  //         )
  //       ],
  //     );
  //   } else {
  //     return Column(
  //       children: [
  //         Padding(
  //           padding: const EdgeInsets.all(12.0),
  //           child: Center(
  //             child: Wrap(
  //               spacing: 20,
  //               runSpacing: 20.0,
  //               children: <Widget>[
  //                 SizedBox(
  //                     width: 300.0,
  //                     height: 180.0,
  //                     child: Card(
  //                       elevation: 2.0,
  //                       shape: RoundedRectangleBorder(
  //                           borderRadius: BorderRadius.circular(8.0)),
  //                       child: Center(
  //                           child: Padding(
  //                               padding: const EdgeInsets.all(8.0),
  //                               child: Column(
  //                                 children: const <Widget>[
  //                                   SizedBox(height: 10.0),
  //                                   Text("Fat",
  //                                       style: TextStyle(
  //                                           fontFamily: "Poppins",
  //                                           fontSize: 25.0,
  //                                           fontWeight: FontWeight.w800)),
  //                                   SizedBox(height: 10.0),
  //                                   Text("Not Found",
  //                                       style: TextStyle(
  //                                           fontFamily: "Poppins",
  //                                           fontSize: 30.0,
  //                                           fontWeight: FontWeight.w600))
  //                                 ],
  //                               ))),
  //                     ))
  //               ],
  //             ),
  //           ),
  //         )
  //       ],
  //     );
  //   }
  // }
  //
  // Widget _getSugarLevel() {
  //   if (scannedProduct.nutriments?.sugars != null) {
  //     return Column(
  //       children: [
  //         Padding(
  //           padding: const EdgeInsets.all(12.0),
  //           child: Center(
  //             child: Wrap(
  //               spacing: 20,
  //               runSpacing: 20.0,
  //               children: <Widget>[
  //                 SizedBox(
  //                     width: 300.0,
  //                     height: 180.0,
  //                     child: Card(
  //                       elevation: 2.0,
  //                       shape: RoundedRectangleBorder(
  //                           borderRadius: BorderRadius.circular(8.0)),
  //                       child: Center(
  //                           child: Padding(
  //                               padding: const EdgeInsets.all(8.0),
  //                               child: Column(
  //                                 children: <Widget>[
  //                                   const SizedBox(height: 10.0),
  //                                   const Text("Sugar",
  //                                       style: TextStyle(
  //                                           fontFamily: "Poppins",
  //                                           fontSize: 30.0,
  //                                           fontWeight: FontWeight.w800,
  //                                           )),
  //                                   const SizedBox(height: 10.0),
  //                                   Text(
  //                                       scannedProduct.nutriments!.sugars!
  //                                               .toStringAsFixed(2)
  //                                               .toString() +
  //                                           "g",
  //                                       style: const TextStyle(
  //                                           fontFamily: "Poppins",
  //                                           fontSize: 30.0,
  //                                           fontWeight: FontWeight.w600,
  //                                           ))
  //                                 ],
  //                               ))),
  //                     ))
  //               ],
  //             ),
  //           ),
  //         )
  //       ],
  //     );
  //   } else {
  //     return Column(
  //       children: [
  //         Padding(
  //           padding: const EdgeInsets.all(12.0),
  //           child: Center(
  //             child: Wrap(
  //               spacing: 20,
  //               runSpacing: 20.0,
  //               children: <Widget>[
  //                 SizedBox(
  //                     width: 300.0,
  //                     height: 180.0,
  //                     child: Card(
  //                       elevation: 2.0,
  //                       shape: RoundedRectangleBorder(
  //                           borderRadius: BorderRadius.circular(8.0)),
  //                       child: Center(
  //                           child: Padding(
  //                               padding: const EdgeInsets.all(8.0),
  //                               child: Column(
  //                                 children: const <Widget>[
  //                                   SizedBox(height: 10.0),
  //                                   Text("Sugar",
  //                                       style: TextStyle(
  //                                           fontFamily: "Poppins",
  //                                           fontSize: 25.0,
  //                                           fontWeight: FontWeight.w800)),
  //                                   SizedBox(height: 10.0),
  //                                   Text("Not Found",
  //                                       style: TextStyle(
  //                                           fontFamily: "Poppins",
  //                                           fontSize: 30.0,
  //                                           fontWeight: FontWeight.w600))
  //                                 ],
  //                               ))),
  //                     ))
  //               ],
  //             ),
  //           ),
  //         )
  //       ],
  //     );
  //   }
  // }

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
                                    Text(
                                        "Allergens", //scannedProduct.allergens?.names,
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

  Widget _getSaturatedFatLevel() {
    if (scannedProduct.nutriments?.saturatedFat != null) {
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
                                    Text(
                                        scannedProduct.nutriments!.saturatedFat
                                                .toString() +
                                            "g",
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
                      height: 150.0,
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
                                    Text("Saturated Fats",
                                        style: TextStyle(
                                            fontFamily: "Poppins",
                                            fontSize: 25.0,
                                            fontWeight: FontWeight.w800)),
                                    SizedBox(height: 10.0),
                                    Text("Not Found",
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
    final productRef = databaseReference.child("products/");
    productRef
        .push()
        .set({
          'productID': uuid.generateV4(),
          "product": {
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

  Widget? _buildPage() {
    if (productIsLoaded == false) {
      return const Center(child: CircularProgressIndicator());
      //need a way to also check for the status of the scan
      //if the result of that equals 0 then this progress indicator should disappear
      //and a message saying the product couldn't be found would appear here
    } else {
      // print(scanProperties.status);
      // if (scanProperties.status == 0) {
      //   return SingleChildScrollView(
      //       child: Container(
      //     alignment: Alignment.center,
      //     child: Column(
      //       children: [
      //         Text("Product not found",
      //             style: TextStyle(
      //               fontFamily: "Poppins",
      //               fontSize: 36,
      //               fontWeight: FontWeight.bold,
      //             )),
      //         SizedBox(height: 10.0),
      //         Text("Try scanning a different product")
      //       ],
      //     ),
      //   ));
      // }

      _pushToDatabase();
      return SingleChildScrollView(
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
                                          const Text("Product Name",
                                              style: TextStyle(
                                                  fontFamily: "Poppins",
                                                  fontSize: 28.0,
                                                  fontWeight: FontWeight.w800)),
                                          const SizedBox(height: 10.0),
                                          Text(scannedProduct.productName ?? "",
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
          title: const Text("Product Details",
              style: TextStyle(
                  fontFamily: "Poppins", fontWeight: FontWeight.bold)),
        ),
        body: _buildPage());
  }
}
