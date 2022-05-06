import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:openfoodfacts/model/Product.dart';

import '../models/scanned_product.dart';


class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key, required User user}) : _user = user, super(key: key);

  final User _user;

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late User user;
  List<ScannedProduct> productList = [];
  var productKeys = [];
  var products = {};
  ScrollController scrollController = ScrollController();
  int productLength = 0;
  final ref = FirebaseDatabase(
      databaseURL:
      "https://foodica-9743c-default-rtdb.europe-west1.firebasedatabase.app")
      .ref();
  _getHistoryFromFirebase() async {

    DatabaseEvent event = await ref.child("/products/").once();



    print(event.snapshot.value);


  }

  _buildHistory() {
    return FutureBuilder(
        future: ref.child("/products/").orderByKey().get(),
        builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
          if (snapshot.hasData) {
            productList.clear();
            var values = snapshot.data!.value as Map<dynamic, dynamic>;
            values.forEach((key, value) {
              print(value["product"]["productname"]);
              ScannedProduct newProduct = ScannedProduct(
                  productID: value["productId"],
                  productDetail: ProductDetail(
                    productname: value["product"]["productname"],
                    brand: value["product"]["brand"],
                    sugar: value["product"]["sugar"].toString(),
                    salt: value["product"]["salt"].toString(),
                    fat: value["product"]["fat"].toString(),
                    image: value["product"]["image"].toString(),
                    category: value["product"]["category"],
                    saturatedFat: value["product"]["saturatedFat"].toString(),
                    calories: value["product"]["calories"].toString(),
                    scanTime: DateTime.parse(value["product"]["scanTime"]),
                  )
              );
              productList.add(newProduct);
            });
            return ListView.builder(
                itemCount: productList.length,
                shrinkWrap: true,
                controller: scrollController,
                itemBuilder: (BuildContext context, int position) {
                  return Container(
                      child: Column(
                        children: [

                          Center(
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
                                                  Text(productList[position].productDetail?.productname ?? "",
                                                      style: TextStyle(
                                                          fontFamily: "Poppins",
                                                          fontSize: 20.0,
                                                          fontWeight: FontWeight.w800)),
                                                  SizedBox(height: 10.0),
                                                  Text("Category: " + productList[position].productDetail!.category!),
                                                  Text("Scanned on: " + productList[position].productDetail!.scanTime.toString()),
                                                  TextButton(onPressed: () {
                                                    debugPrint("Details about saved product");
                                                  }, child: Text("More information"))
                                                ],
                                              ))),
                                    ))
                              ],
                            ),
                          ),
                        ],
                      )
                  );


                });
          }
          else {
            return const Center(
                child: CircularProgressIndicator(color: Colors.red)
            );
          }
        }
    );
  }



  @override
  void initState() {
    super.initState();
    _getHistoryFromFirebase();
    print(products.toString());
  }

  @override
  void dispose() {
    super.dispose();
  }

  _printData() {
    for (int i = 0; i < productLength; i++ ) {
      print(productList[i]);
    }
  }


  @override
  Widget build(BuildContext context) {
_printData();
    return Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20.0),
            child: Column(
              children: [
                Container(
                    alignment: Alignment.center,
                    child: Text("History",
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.bold,
                            fontSize: 40
                        ))
                ),
                _buildHistory()
              ],
            )
          )
        )
    //      SingleChildScrollView(
    //         child: Column(
    //   children: <Widget>[
    //     Container(
    //       padding: const EdgeInsets.all(20.0),
    //       child: const Text("History",
    //           textAlign: TextAlign.center,
    //           style: TextStyle(
    //               fontWeight: FontWeight.bold,
    //               fontFamily: "Poppins",
    //               fontSize: 35)),
    //     ),
    //     Column(
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
    //                                   Text("Product 1",
    //                                       style: TextStyle(
    //                                           fontFamily: "Poppins",
    //                                           fontSize: 30.0,
    //                                           fontWeight: FontWeight.w800)),
    //                                   SizedBox(height: 10.0),
    //                                   Text("lorem ipsum lol",
    //                                       style: TextStyle(
    //                                           fontFamily: "Poppins",
    //                                           fontSize: 16.0,
    //                                           fontWeight: FontWeight.w600))
    //                                 ],
    //                               ))),
    //                     ))
    //               ],
    //             ),
    //           ),
    //         )
    //       ],
    //     )
    //   ],
    // )));
    );
  }
}
