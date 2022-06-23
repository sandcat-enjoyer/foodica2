import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/scanned_product.dart';
import '../utils/uuid.dart';

class ManualFoodPage extends StatefulWidget {
  const ManualFoodPage({Key? key, required User user, ScannedProduct? product})
      : product = product,
        _user = user,
        super(key: key);
  final User _user;
  final ScannedProduct? product;
  @override
  _ManualFoodPageState createState() => _ManualFoodPageState();
}

class _ManualFoodPageState extends State<ManualFoodPage> {
  late User user;
  var storage = FirebaseStorage.instance;
  Uuid uuid = Uuid();
  String productName = "";
  String brand = "";
  String category = "";
  String allergens = "";
  String imagePath = "";
  String calories = "";
  String fat = "";
  int? dailyCalories;
  int? weeklyCalories;
  String salt = "";
  String saturatedFat = "";
  String sugar = "";

  final productNameController = TextEditingController();
  final brandController = TextEditingController();
  final categoryController = TextEditingController();
  final caloriesController = TextEditingController();
  final fatController = TextEditingController();
  final saltController = TextEditingController();
  final saturatedFatController = TextEditingController();
  final sugarController = TextEditingController();
  File? photo;
  final databaseReference = FirebaseDatabase(
          databaseURL:
              "https://foodica-9743c-default-rtdb.europe-west1.firebasedatabase.app")
      .ref();
  ImagePicker imagePicker = ImagePicker();

  _getProductInfo() {
    if (widget.product != null) {
      productNameController.text = widget.product!.productDetail!.productname!;
      brandController.text = widget.product!.productDetail!.productname!;
      caloriesController.text = widget.product?.productDetail?.calories ?? "";
      fatController.text = widget.product?.productDetail?.fat ?? "";
      saltController.text = widget.product?.productDetail?.salt ?? "";
      saturatedFatController.text =
          widget.product?.productDetail?.saturatedFat ?? "";
      sugarController.text = widget.product?.productDetail?.sugar ?? "";
    }
  }

  @override
  void initState() {
    super.initState();
    user = widget._user;
    _getProductInfo();
    _getDailyCalories();
    _getWeeklyCalories();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future selectImageFromGallery() async {
    var image = await imagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (image != null) {
        photo = File(image.path);
        _saveImageToFirebase();
      } else {}
    });
  }

  Future getImageFromCamera() async {
    var image = await imagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      if (image != null) {
        photo = File(image.path);
        _saveImageToFirebase();
      } else {}
    });
  }

  _saveImageToFirebase() async {
    if (user != null) {
      if (photo == null) return;
      try {
        var destination = "users/" + user.uid + "/products";
        var storageRef = storage.ref(destination).child(user.uid + "/");
        await storageRef.putFile(photo!);
        storageRef.getDownloadURL().then((url) => {
              setState(() => {imagePath = url}),
            });
      } catch (e) {
        print("Error");
      }
    }
  }

  _saveProductToFirebase() {
    final productRef =
        databaseReference.child("/users/" + user.uid + "/products/");
    productRef
        .push()
        .set({
          "productID": uuid.generateV4(),
          "product": {
            "code": widget.product?.productDetail?.code,
            'productname': productName,
            'brand': brand,
            'category': category,
            'calories': double.parse(calories),
            'image': imagePath,
            'allergens': allergens,
            'fat': double.parse(fat),
            'saturatedFat': double.parse(saturatedFat),
            'salt': double.parse(salt),
            'sugar': double.parse(sugar),
            "scanTime": DateTime.now().toString()
          }
        })
        .then((_) => print("Product was written to the database"))
        .catchError((error) => print("Error: " + error));
  }

  _getDailyCalories() {
    SharedPreferences.getInstance().then((prefs) => {
          setState(() {
            dailyCalories = prefs.getInt("daily");
          })
        });
  }

  _getWeeklyCalories() {
    SharedPreferences.getInstance().then((prefs) => {
          setState(() {
            weeklyCalories = prefs.getInt("weekly") ?? 0;
          })
        });
  }

  _addToDailyCalories() {
    SharedPreferences.getInstance().then((prefs) {
      int newCalories = dailyCalories! + int.parse(calories);
      prefs.setInt("daily", newCalories);
    });
  }

  _addToWeeklyCalories() {
    SharedPreferences.getInstance().then((prefs) {
      int newWeeklyCalories = weeklyCalories! + int.parse(calories);
      print(newWeeklyCalories);
      prefs.setInt("weekly", newWeeklyCalories);
    });
  }

  _saveLastScannedProductName() {
    SharedPreferences.getInstance().then((prefs) {
      print(productName);
      prefs.setString("productname", productName);
    });
  }

  _checkIfImageExists() {
    if (photo != null) {
      return Image.file(photo!, width: 200);
    } else {
      return const Text("Image will appear here",
          style: TextStyle(fontFamily: "Poppins"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              _saveProductToFirebase();
              _addToDailyCalories();
              _saveLastScannedProductName();
              _addToWeeklyCalories();
              Navigator.pop(context);
            },
            child: const Icon(Icons.save)),
        appBar: AppBar(
            centerTitle: true,
            title: const Text("Foodica",
                style: TextStyle(
                    fontFamily: "Poppins", fontWeight: FontWeight.bold))),
        body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                Container(
                    padding: const EdgeInsets.all(20.0),
                    alignment: Alignment.center,
                    child: const Text("Add food",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: "Poppins",
                            fontSize: 35))),
                SizedBox(
                  width: 350,
                  child: TextField(
                      controller: productNameController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintStyle: TextStyle(fontFamily: "Poppins"),
                          hintText: "Name of Food"),
                      onChanged: (value) => {productName = value.trim()}),
                ),
                const SizedBox(height: 10),
                SizedBox(
                    width: 350,
                    child: TextField(
                      controller: brandController,
                      decoration: const InputDecoration(
                          hintStyle: TextStyle(fontFamily: "Poppins"),
                          border: OutlineInputBorder(),
                          hintText: "Brand"),
                      onChanged: (value) {
                        brand = value.trim();
                      },
                    )),
                const SizedBox(height: 10),
                SizedBox(
                    width: 350,
                    child: TextField(
                      controller: categoryController,
                      decoration: const InputDecoration(
                          hintStyle: TextStyle(fontFamily: "Poppins"),
                          border: OutlineInputBorder(),
                          hintText: "Category"),
                      onChanged: (value) {
                        category = value.trim();
                      },
                    )),
                const SizedBox(height: 10),
                _checkIfImageExists(),
                ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                                height: 200,
                                padding: const EdgeInsets.all(15.0),
                                color: Colors.white,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text("Select Source",
                                        style: TextStyle(
                                            fontFamily: "Poppins",
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black)),
                                    Row(children: [
                                      const Icon(Icons.camera,
                                          color: Colors.black),
                                      TextButton(
                                          onPressed: () {
                                            getImageFromCamera();
                                          },
                                          child: const Text("Open Camera",
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  fontFamily: "Poppins",
                                                  color: Colors.black))),
                                    ]),
                                    Row(children: [
                                      const Icon(Icons.photo,
                                          color: Colors.black),
                                      TextButton(
                                          onPressed: () {
                                            selectImageFromGallery();
                                          },
                                          child: const Text(
                                              "Select from gallery",
                                              style: TextStyle(
                                                  fontFamily: "Poppins",
                                                  color: Colors.black)))
                                    ])
                                  ],
                                ));
                          });
                    },
                    child: const Text("Take picture",
                        style: TextStyle(fontFamily: "Poppins"))),
                const SizedBox(height: 10),
                SizedBox(
                    width: 350,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintStyle: TextStyle(fontFamily: "Poppins"),
                        border: OutlineInputBorder(),
                        hintText: "Amount of Calories (in Kcal)",
                      ),
                      onChanged: (value) {
                        setState(() {
                          calories = value.trim();
                        });
                      },
                    )),
                const SizedBox(height: 10),
                SizedBox(
                    width: 350,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          hintStyle: TextStyle(fontFamily: "Poppins"),
                          border: OutlineInputBorder(),
                          hintText: "Amount of Fat (in Grams)"),
                      onChanged: (value) {
                        fat = value.trim();
                      },
                    )),
                const SizedBox(height: 10),
                SizedBox(
                    width: 350,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          hintStyle: TextStyle(fontFamily: "Poppins"),
                          border: OutlineInputBorder(),
                          hintText: "Amount of Salt (in Grams)"),
                      onChanged: (value) {
                        salt = value.trim();
                      },
                    )),
                const SizedBox(height: 10),
                SizedBox(
                    width: 350,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          hintStyle: TextStyle(fontFamily: "Poppins"),
                          border: OutlineInputBorder(),
                          hintText: "Amount of Saturated Fats (in Grams)"),
                      onChanged: (value) {
                        saturatedFat = value.trim();
                      },
                    )),
                const SizedBox(height: 10),
                SizedBox(
                    width: 350,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          hintStyle: TextStyle(fontFamily: "Poppins"),
                          border: OutlineInputBorder(),
                          hintText: "Amount of Sugars (in Grams)"),
                      onChanged: (value) {
                        sugar = value.trim();
                      },
                    )),
                const SizedBox(height: 50)
              ],
            )));
  }
}
