import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import '../models/scanned_product.dart';

class ManualFoodPage extends StatefulWidget {
  const ManualFoodPage({Key? key, required User user, ScannedProduct? product}) : product = product, _user = user,
        super(key: key);

  final User _user;
  final ScannedProduct? product;





  @override
  _ManualFoodPageState createState() => _ManualFoodPageState();
}

class _ManualFoodPageState extends State<ManualFoodPage> {
    late User user;
    var storage = FirebaseStorage.instance;
    String productName = "";
    String brand = "";
    String category = "";
    String allergens = "";
    String imagePath = "";
    String calories = "";
    String fat = "";
    String salt = "";
    String saturatedFat = "";
    String sugar = "";

    final productNameController = TextEditingController();
    final brandController = TextEditingController();
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
        saturatedFatController.text = widget.product?.productDetail?.saturatedFat ?? "";
        sugarController.text = widget.product?.productDetail?.sugar ?? "";
      }
    }

    @override
    void initState() {
      super.initState();
      user = widget._user;
      _getProductInfo();
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
        }
        else {
          print('No image selected');
        }
      });


    }

    Future getImageFromCamera() async {
      var image = await imagePicker.pickImage(source: ImageSource.camera);
      setState(() {
        if (image != null) {
          photo = File(image.path);
          _saveImageToFirebase();
        }
        else {
          print("No image selected");
        }
      });
    }

    _saveImageToFirebase() async {
      if (user != null) {
        if (photo == null) return;
        var uid = user.uid;
        var fileName = basename(photo!.path);



        try {
          var destination = "users/" + user.uid + "/products";
          var storageRef = storage.ref(destination).child(user.uid + "/");
          await storageRef.putFile(photo!);
          storageRef.getDownloadURL().then((url) => {
            setState(() => {
              imagePath = url
            }),
            print(url)
          });
          print(imagePath);
        }
        catch (e) {
          print("Error");
        }



      }


    }

    _saveProductToFirebase() {
      final productRef = databaseReference.child("products/");
      productRef
          .push()
          .set({
        'productname': productName,
        'brand': brand,
        'category': category,
        'calories': calories,
        'image': imagePath,
        'allergens': allergens,
        'fat': fat,
        'saturatedFat': saturatedFat,
        'salt': salt,
        'sugar': sugar
      })
          .then((_) => print("Product was written to the database"))
          .catchError((error) => print("Error: " + error));

    }

    _checkIfImageExists() {
      if (photo != null) {
        return Image.file(photo!, width: 200);
      }
      else {
        return const Text("Image will appear here");
      }
    }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
            _saveProductToFirebase();
            Navigator.pop(context);
        },
        child: const Icon(Icons.save)
      ),
      appBar: AppBar(
        title: const Text("Foodica",
        style: TextStyle(
          fontFamily: "Poppins",
          fontWeight: FontWeight.bold
        ))

      ),
      body: SingleChildScrollView(
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
                fontSize: 35
              ))
            ),
            SizedBox(
              width: 350,
              child: TextField(
                controller: productNameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Name of Food"
                ),
                onChanged: (value) => {
                    productName = value.trim()
                }

              ),
            ),

            const SizedBox(height: 10),
             SizedBox(width: 350, child: TextField(
               controller: brandController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Brand"
              ),
              onChanged: (value) {
                brand = value.trim();
              },
            )),
            const SizedBox(height: 10),
            _checkIfImageExists(),
            ElevatedButton(onPressed: () {
              showModalBottomSheet(context: context,
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
                        color: Colors.black
                      )),
                      Row(children: [
                        const Icon(Icons.camera, color: Colors.black),
                        TextButton(
                            onPressed: () {
                              getImageFromCamera();
                            },
                            child: const Text("Open Camera",
                              textAlign: TextAlign.left,
                            style: TextStyle(
                              fontFamily: "Poppins",
                              color: Colors.black
                            ))
                        ),
                      ]),
                      Row(children: [
                        const Icon(Icons.photo, color: Colors.black),
                        TextButton(
                            onPressed: () {
                              selectImageFromGallery();
                            },
                            child: const Text("Select from gallery",
                            style: TextStyle(fontFamily: "Poppins",
                                color: Colors.black))
                        )
                      ])


                    ],
                  )
                );
              });

            }, child: const Text("Take picture")),
            const SizedBox(height: 10),
            SizedBox(
              width: 350,
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Amount of Calories (in Kcal)",

                ),
                onChanged: (value) {
                  setState(() {
                    calories = value.trim();
                  });
                },
              )
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 350,
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Amount of Fat (in Grams)"
                ),
                onChanged: (value) {
                  fat = value.trim();
                },
              )
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 350,
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Amount of Salt (in Grams)"
                ),
                onChanged: (value) {
                  salt = value.trim();
                },
              )
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 350,
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Amount of Saturated Fats (in Grams)"
                ),
                onChanged: (value) {
                  saturatedFat = value.trim();
                },
              )
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 350,
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Amount of Sugars (in Grams)"
                ),
                onChanged: (value) {
                  sugar = value.trim();
                },
              )
            ),
            const SizedBox(height: 50)



          ],
        )
      )
    );
  }
}