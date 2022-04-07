import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:foodica/models/product.dart';
import 'package:foodica/models/product_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key, required this.barcode}) : super(key: key);
  final String barcode;

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late Colors fatColor;
  late Future<int> _weeklyCalories;
  int _weeklyCaloriesInt = 0;
  int _productCalories = 0;
  Product scannedProduct = Product(
      nutriments: Nutriments(
          carbohydrates: -1,
          carbohydratesPer100g: -1,
          energyKcal: -1,
          energyKcal100g: -1,
          fat: -1,
          fatPer100g: -1,
          fiber: -1,
          fiber100g: -1,
          proteins: -1,
          proteinsPer100g: -1,
          salt: -1,
          saltPer100g: -1,
          saturatedFat: -1,
          saturatedFatPer100g: -1,
          sodium: -1,
          sodiumPer100g: -1,
          sugars: -1,
          sugarsPer100g: -1));

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
    _getProduct(widget.barcode);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _getProduct(String barcode) {
    ProductApi.fetchProduct(barcode).then((result) {
      setState(() {
        scannedProduct.productname = result.product!.productname;
        scannedProduct.brand = result.product!.brand;
        scannedProduct.category = result.product!.category;
        scannedProduct.image = result.product!.image;
        scannedProduct.nutriments = result.product!.nutriments;
        scannedProduct.nutrientLevels = result.product!.nutrientLevels;
        scannedProduct.allergens = result.product!.allergens;
        debugPrint("Product loaded: " + productIsLoaded.toString());
        productIsLoaded = true;
        debugPrint("Now what? " + productIsLoaded.toString());
        if (result.product!.nutriments.energyKcal != null) {
          _productCalories = result.product!.nutriments.energyKcal!.toInt();
        } else {
          _productCalories = 0;
        }

        debugPrint(_productCalories.toString());
      });
      _saveCaloriesToMemory();
    });
  }

  void _saveCaloriesToMemory() async {
    if (scannedProduct.nutriments.energyKcal != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt("weekly", (_weeklyCaloriesInt + _productCalories));
      debugPrint(prefs.getInt("weekly").toString());
    }
  }

  Widget _getCalories() {
    //can this process be more optimized?
    if (scannedProduct.nutriments.energyKcal != null) {
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
                                    const Text("Total Calories",
                                        style: TextStyle(
                                            fontFamily: "Poppins",
                                            fontSize: 30.0,
                                            fontWeight: FontWeight.w800)),
                                    const SizedBox(height: 10.0),
                                    Text(
                                        scannedProduct.nutriments.energyKcal
                                                .toString() +
                                            "Kcal",
                                        style: const TextStyle(
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
                                    Text("Total Calories",
                                        style: TextStyle(
                                            fontFamily: "Poppins",
                                            fontSize: 30.0,
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

  Color _checkFatAmount() {
    switch (scannedProduct.nutrientLevels!.fat) {
      case "low":
        return Colors.green;
      case "moderate":
        return Colors.orange;
      case "high":
        return Colors.red;
    }
    return Color.fromARGB(255, 64, 64, 64);
  }

  Color _checkSaltAmount() {
    switch (scannedProduct.nutrientLevels!.salt) {
      case "low":
        return Colors.green;
      case "moderate":
        return Colors.orange;
      case "high":
        return Colors.red;
    }
    return Color.fromARGB(255, 64, 64, 64);
  }

  Color _checkSatFatAmount() {
    switch (scannedProduct.nutrientLevels!.saturatedFat) {
      case "low":
        return Colors.green;
      case "moderate":
        return Colors.orange;
      case "high":
        return Colors.red;
    }
    return Color.fromARGB(255, 64, 64, 64);
  }

  Color _checkSugarAmount() {
    switch (scannedProduct.nutrientLevels!.saturatedFat) {
      case "low":
        return Colors.green;
      case "moderate":
        return Colors.orange;
      case "high":
        return Colors.red;
    }
    return Color.fromARGB(255, 64, 64, 64);
  }

  Widget _getProductImage() {
    String url = "";
    if (scannedProduct.image != null) {
      url = scannedProduct.image!;
      return CachedNetworkImage(imageUrl: url);
    } else {
      url = "https://via.placeholder.com/300";
      return CachedNetworkImage(imageUrl: url);
    }
  }

  Widget _getSaltLevel() {
    if (scannedProduct.nutriments.salt != null) {
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
                        color: _checkSaltAmount(),
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
                                            fontSize: 30.0,
                                            fontWeight: FontWeight.w800)),
                                    const SizedBox(height: 10.0),
                                    Text(
                                        scannedProduct.nutriments.salt
                                                .toString() +
                                            "g",
                                        style: const TextStyle(
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
                        color: _checkSatFatAmount(),
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

  Widget _getFatLevels() {
    if (scannedProduct.nutriments.fat != null) {
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
                        color: _checkFatAmount(),
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
                                            fontWeight: FontWeight.w800)),
                                    const SizedBox(height: 10.0),
                                    Text(
                                        scannedProduct.nutriments.fat
                                                .toString() +
                                            "g",
                                        style: const TextStyle(
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
                        color: _checkSatFatAmount(),
                        elevation: 2.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                        child: Center(
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: const <Widget>[
                                    SizedBox(height: 10.0),
                                    Text("Fat",
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

  Widget _getSugarLevel() {
    if (scannedProduct.nutriments.sugars != null) {
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
                        color: _checkSugarAmount(),
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
                                            fontWeight: FontWeight.w800)),
                                    const SizedBox(height: 10.0),
                                    Text(
                                        scannedProduct.nutriments.sugars
                                                .toString() +
                                            "g",
                                        style: const TextStyle(
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
                        color: _checkSatFatAmount(),
                        elevation: 2.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                        child: Center(
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: const <Widget>[
                                    SizedBox(height: 10.0),
                                    Text("Sugar",
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
                                  children: <Widget>[
                                    const SizedBox(height: 10.0),
                                    const Text("Allergens",
                                        style: TextStyle(
                                            fontFamily: "Poppins",
                                            fontSize: 30.0,
                                            fontWeight: FontWeight.w800)),
                                    const SizedBox(height: 10.0),
                                    Text(scannedProduct.allergens!,
                                        style: const TextStyle(
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
    if (scannedProduct.nutriments.saturatedFat != null) {
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
                        color: _checkSatFatAmount(),
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
                                            fontWeight: FontWeight.w800)),
                                    const SizedBox(height: 10.0),
                                    Text(
                                        scannedProduct.nutriments.saturatedFat
                                                .toString() +
                                            "g",
                                        style: const TextStyle(
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
                      height: 150.0,
                      child: Card(
                        color: _checkSatFatAmount(),
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

  Widget? _buildPage() {
    if (scannedProduct.nutriments.carbohydrates == -1) {
      return const Center(child: CircularProgressIndicator());
    } else {
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
                                          Text(scannedProduct.productname ?? "",
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
            _getCalories(),
            _getFatLevels(),
            _getSaltLevel(),
            _getSugarLevel(),
            _getSaturatedFatLevel()
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
