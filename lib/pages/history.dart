import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/scanned_product.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key, required User user})
      : _user = user,
        super(key: key);

  final User _user;

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late User user;
  DateTime selectedDate = DateTime.now();
  List<ScannedProduct> productList = [];
  var productKeys = [];
  var products = {};
  ScrollController scrollController = ScrollController();
  int productLength = 0;
  final ref = FirebaseDatabase(
          databaseURL:
              "https://foodica-9743c-default-rtdb.europe-west1.firebasedatabase.app")
      .ref();

  final DateFormat formatter = DateFormat("dd/M/yyyy");

  buildCupertinoDatePicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext builder) {
          return Container(
            height: MediaQuery.of(context).copyWith().size.height / 3,
            color: Colors.white,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              onDateTimeChanged: (picked) {
                if (picked != null && picked != selectedDate)
                  setState(() {
                    selectedDate = picked;
                  });
              },
              initialDateTime: selectedDate,
              minimumYear: 2000,
              maximumYear: 2025,
            ),
          );
        });
  }

  _setThemeForDatePicker() {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;

    if (isDarkMode) {
      return ThemeData.dark();
    } else {
      return ThemeData.light();
    }
  }

  buildMaterialDatePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      initialEntryMode: DatePickerEntryMode.calendar,
      initialDatePickerMode: DatePickerMode.day,
      cancelText: 'Cancel',
      confirmText: 'Select',
      errorFormatText: 'Enter valid date',
      errorInvalidText: 'Enter date in valid range',
      fieldLabelText: 'Date',
      fieldHintText: 'Month/Date/Year',
      builder: (context, child) {
        return Theme(data: _setThemeForDatePicker(), child: child!);
      },
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
    _dateFormatter(selectedDate);
  }

  String _dateFormatter(DateTime tm) {
    DateTime today = DateTime.now();
    Duration oneDay = const Duration(days: 1);
    Duration twoDay = const Duration(days: 2);
    String month;
    switch (tm.month) {
      case 1:
        month = "January";
        break;
      case 2:
        month = "February";
        break;
      case 3:
        month = "March";
        break;
      case 4:
        month = "April";
        break;
      case 5:
        month = "May";
        break;
      case 6:
        month = "June";
        break;
      case 7:
        month = "July";
        break;
      case 8:
        month = "August";
        break;
      case 9:
        month = "September";
        break;
      case 10:
        month = "October";
        break;
      case 11:
        month = "November";
        break;
      case 12:
        month = "December";
        break;
      default:
        month = "Unknown";
        break;
    }

    Duration difference = today.difference(tm);

    if (difference.compareTo(oneDay) < 1) {
      return "Today";
    } else if (difference.compareTo(twoDay) < 1) {
      return "Yesterday";
    } else {
      return "${tm.day} $month ${tm.year}";
    }
  }

  _buildHistory() {
    return FutureBuilder(
        future:
            ref.child("/users/" + user.uid + "/products/").orderByKey().get(),
        builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
          if (snapshot.hasData) {
            productList.clear();
            print(snapshot.data!.value);
            if (snapshot.data!.value != null) {
              var values = snapshot.data!.value as Map<dynamic, dynamic>;
              values.forEach((key, value) {
                print(value["product"]["productname"]);
                ScannedProduct newProduct = ScannedProduct(
                    productID: value["productId"],
                    productDetail: ProductDetail(
                      productname: value["product"]["productname"],
                      code: value["product"]["code"],
                      brand: value["product"]["brand"],
                      sugar: value["product"]["sugar"].toString(),
                      salt: value["product"]["salt"].toString(),
                      fat: value["product"]["fat"].toString(),
                      image: value["product"]["image"].toString(),
                      category: value["product"]["category"],
                      saturatedFat: value["product"]["saturatedFat"].toString(),
                      calories: value["product"]["calories"].toString(),
                      scanTime: DateTime.parse(value["product"]["scanTime"]),
                    ));
                productList.add(newProduct);
              });
            }

            if (productList.isEmpty) {
              return Column(
                children: [
                  SizedBox(height: 10),
                  Icon(
                    Icons.warning,
                    color: Colors.yellow,
                    size: 96,
                  ),
                  Text(
                    "No products scanned",
                    style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "Start scanning products to see them appear on this screen.",
                      style: TextStyle(fontFamily: "Poppins", fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              );
            } else {
              return ListView.builder(
                  itemCount: productList.length,
                  shrinkWrap: true,
                  controller: scrollController,
                  itemBuilder: (BuildContext context, int position) {
                    Widget? _checkImageUrl() {
                      if (productList[position].productDetail?.image == "" ||
                          productList[position].productDetail?.image == "0") {
                        return null;
                      } else {
                        return CachedNetworkImage(
                          imageUrl: productList[position].productDetail!.image!,
                          width: 100,
                        );
                      }
                    }

                    _checkIfCategoryIsEmpty() {
                      if (productList[position].productDetail!.category == "") {
                        return "Category: Unknown";
                      } else {
                        return "Category: " +
                            productList[position].productDetail!.category!;
                      }
                    }

                    return Container(
                        child: Column(
                      children: [
                        Center(
                          child: Wrap(
                            spacing: 20,
                            runSpacing: 20.0,
                            children: <Widget>[
                              SizedBox(
                                  width: 350.0,
                                  child: Card(
                                    elevation: 2.0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0)),
                                    child: Center(
                                        child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: <Widget>[
                                                SizedBox(height: 10.0),
                                                Text(
                                                    productList[position]
                                                            .productDetail
                                                            ?.productname ??
                                                        "",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontFamily: "Poppins",
                                                        fontSize: 20.0,
                                                        fontWeight:
                                                            FontWeight.w800)),
                                                SizedBox(height: 10.0),
                                                _checkImageUrl() ??
                                                    SizedBox(height: 0),
                                                Text(
                                                  _checkIfCategoryIsEmpty(),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontFamily: "Poppins",
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                SizedBox(height: 10),
                                                Text(
                                                    "Brand: " +
                                                        productList[position]
                                                            .productDetail!
                                                            .brand!,
                                                    style: TextStyle(
                                                        fontFamily: "Poppins",
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w500)),
                                                SizedBox(height: 10),
                                                Text(
                                                    "Scanned on: " +
                                                        formatter
                                                            .format(productList[
                                                                    position]
                                                                .productDetail!
                                                                .scanTime!)
                                                            .toString(),
                                                    style: TextStyle(
                                                        fontFamily: "Poppins",
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w500)),
                                                SizedBox(height: 10),
                                                // TextButton(onPressed: () {
                                                //   debugPrint(productList[position].productDetail!.code ?? "Not Found");
                                                //   Navigator.of(context).push(MaterialPageRoute(builder: (context) => DetailPage(barcode: productList[position].productDetail!.code ?? "", user: user, isFromScan: false,)));
                                                // }, child: Text("More information", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold))),
                                                // TextButton(
                                                //   onPressed: () {
                                                //     showDialog(context: context, builder: (context) {
                                                //       return AlertDialog(
                                                //         shape: const RoundedRectangleBorder(
                                                //           borderRadius: BorderRadius.all(Radius.circular(20))
                                                //         ),
                                                //         title: const Text("Delete Product",
                                                //         style: TextStyle(
                                                //           fontFamily: "Poppins",
                                                //           fontWeight: FontWeight.bold
                                                //         )),
                                                //         content: StatefulBuilder(
                                                //           builder: (context, SBsetState) {
                                                //             return Text("Are you sure you want to delete this product from your history?");
                                                //           },
                                                //         ),
                                                //         actions: [
                                                //           TextButton(onPressed: () {
                                                //             Navigator.pop(context);

                                                //           }, child: Text("Delete", style: TextStyle(fontFamily: "Poppins", color: Colors.red))),
                                                //           TextButton(onPressed: () {
                                                //             Navigator.pop(context);
                                                //           }, child: Text("Cancel", style: TextStyle(fontFamily: "Poppins")))
                                                //         ],

                                                //       );
                                                //     });
                                                //   },
                                                //   child: Text("Delete Product", style: TextStyle(
                                                //     fontFamily: "Poppins", color: Colors.red
                                                //   ))
                                                // )
                                              ],
                                            ))),
                                  )),
                              SizedBox(height: 5),
                            ],
                          ),
                        ),
                      ],
                    ));
                  });
            }
          } else {
            return const Center(
                child: CircularProgressIndicator(color: Colors.redAccent));
          }
        });
  }

  @override
  void initState() {
    super.initState();
    user = widget._user;
    print(products.toString());
  }

  @override
  void dispose() {
    super.dispose();
  }

  _printData() {
    for (int i = 0; i < productLength; i++) {
      print(productList[i]);
    }
  }

  @override
  Widget build(BuildContext context) {
    _printData();
    return Scaffold(
        body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
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
                                fontSize: 40))),
                    _buildHistory()
                  ],
                )))
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
