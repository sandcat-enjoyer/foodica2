import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ManualFoodPage extends StatefulWidget {
  const ManualFoodPage({Key? key, required User user}) : _user = user, super(key: key);

  final User _user;

  @override
  _ManualFoodPageState createState() => _ManualFoodPageState();
}

class _ManualFoodPageState extends State<ManualFoodPage> {
    late User user;
    var storage = FirebaseStorage.instance;
    ImagePicker imagePicker = ImagePicker();

    @override
    void initState() {
      super.initState();
    }

    @override
    void dispose() {
      super.dispose();
    }

    Future selectImage() async {
      var image = await imagePicker.pickImage(source: ImageSource.camera);


    }

    _saveImageToFirebase() {
      var storageRef = storage.ref();

      if (user != null) {

      }


    }

    _saveProductToFirebase() {

    }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {

        },
        child: Icon(Icons.save)
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
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Name of Food"
                ),
                onChanged: (value) => {

                }

              ),
            ),

            SizedBox(height: 10),
            SizedBox(width: 350, child: TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Brand"
              ),
            )),
            SizedBox(height: 10),
            ElevatedButton(onPressed: () {

            }, child: Text("Take picture")),
            SizedBox(height: 10),
            SizedBox(
              width: 350,
              child: TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Amount of Calories (in Kcal)"
                ),
              )
            ),
            SizedBox(height: 10),
            SizedBox(
              width: 350,
              child: TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Amount of Fat (in Grams)"
                )
              )
            ),
            SizedBox(height: 10),
            SizedBox(
              width: 350,
              child: TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Amount of Salt (in Grams)"
                )
              )
            ),
            SizedBox(height: 10),
            SizedBox(
              width: 350,
              child: TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Amount of Saturated Fats (in Grams)"
                )
              )
            ),
            SizedBox(height: 10),
            SizedBox(
              width: 350,
              child: TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Amount of Sugars (in Grams)"
                )
              )
            ),
            SizedBox(height: 50)



          ],
        )
      )
    );
  }
}