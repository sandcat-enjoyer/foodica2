import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:fl_chart/fl_chart.dart';
import 'package:Foodica/models/scanned_product.dart';
import '../models/scanned_product.dart';

class CalorieDetailPage extends StatefulWidget {
  const CalorieDetailPage({Key? key, required User user})
      : _user = user,
        super(key: key);

  final User _user;
  @override
  _CalorieDetailPageState createState() => _CalorieDetailPageState();
}

class _CalorieDetailPageState extends State<CalorieDetailPage> {
  DateTime selectedDate = DateTime.now();
  num _fatValue = 0;
  num _sugarValue = 0;
  late User user;
  num _saturatedFatValue = 0;
  num _calorieValue = 0;
  BouncingScrollPhysics bouncingScrollPhysics = BouncingScrollPhysics();
  ScrollController scrollController = ScrollController();
  num _saltValue = 0;
  List<PieChartSectionData> sections = [];
  DataSnapshot? snapshot;
  _selectDate(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    assert(theme.platform != null);
    switch (theme.platform) {
      case TargetPlatform.android:
        return buildMaterialDatePicker(context);
      case TargetPlatform.iOS:
        return buildCupertinoDatePicker(context);
      default:
        return buildMaterialDatePicker(context);
    }
  }

  List<ScannedProduct> products = [];

  DatabaseReference database = FirebaseDatabase(
          databaseURL:
              "https://foodica-9743c-default-rtdb.europe-west1.firebasedatabase.app")
      .ref();

  _resetOnReload() {
    _fatValue = 0;
    _saltValue = 0;
    _saturatedFatValue = 0;
    _sugarValue = 0;
    _calorieValue = 0;
    sections = [];
  }

  _getData() {
    return FutureBuilder(
        future: database
            .child("/users/" + user.uid + "/products")
            .orderByKey()
            .get(),
        builder: (BuildContext context, AsyncSnapshot<DataSnapshot> snapshot) {
          if (snapshot.hasData) {
            products.clear();
            _resetOnReload();
            var values = snapshot.data!.value as Map<dynamic, dynamic>;
            values.forEach((key, value) {
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
                  ));
              if (newProduct.productDetail?.scanTime?.day == selectedDate.day) {
                products.add(newProduct);
              }
            });

            return ListView.builder(
                itemCount: 1,
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                controller: scrollController,
                itemBuilder: (BuildContext context, int pos) {
                  return SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Container(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Container(
                                  alignment: Alignment.topLeft,
                                  child: Text("Details",
                                      style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold))),
                              SizedBox(height: 10),
                              Container(
                                  alignment: Alignment.topLeft,
                                  child: Text(_dateFormatter(selectedDate),
                                      style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22))),
                              _buildChart(),
                              Container(
                                  child: Center(
                                      child: Wrap(
                                runSpacing: 20.0,
                                children: <Widget>[
                                  Row(
                                    children: [
                                      Center(
                                        child: Container(
                                          width: 350.0,
                                          height: 200.0,
                                          alignment: Alignment.center,
                                          child: Card(
                                            elevation: 2.0,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8.0)),
                                            child: Center(
                                                child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                children: <Widget>[
                                                  const SizedBox(
                                                    height: 10.0,
                                                  ),
                                                  const Icon(
                                                    Icons.run_circle,
                                                    size: 60,
                                                  ),
                                                  const Text(
                                                    "Calories Consumed",
                                                    style: TextStyle(
                                                        fontFamily: "Poppins",
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 23.0),
                                                  ),
                                                  const SizedBox(
                                                    height: 5.0,
                                                  ),
                                                  Text(
                                                    _calorieValue
                                                            .toStringAsFixed(
                                                                2) +
                                                        " Kcal",
                                                    style: const TextStyle(
                                                      fontFamily: "Poppins",
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 20.0,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        width: 160.0,
                                        height: 200.0,
                                        alignment: Alignment.centerLeft,
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
                                                const SizedBox(
                                                  height: 10.0,
                                                ),
                                                const Icon(
                                                  Icons.run_circle,
                                                  size: 60,
                                                ),
                                                const Text(
                                                  "Fat",
                                                  style: TextStyle(
                                                      fontFamily: "Poppins",
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 23.0),
                                                ),
                                                const SizedBox(
                                                  height: 5.0,
                                                ),
                                                Text(
                                                  _fatValue.toStringAsFixed(2) +
                                                      "g",
                                                  style: const TextStyle(
                                                    fontFamily: "Poppins",
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 20.0,
                                                  ),
                                                )
                                              ],
                                            ),
                                          )),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Container(
                                        width: 160.0,
                                        height: 200.0,
                                        alignment: Alignment.centerRight,
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
                                                const SizedBox(
                                                  height: 10.0,
                                                ),
                                                const Icon(
                                                  Icons.run_circle,
                                                  size: 60,
                                                ),
                                                const Text(
                                                  "Salt",
                                                  style: TextStyle(
                                                      fontFamily: "Poppins",
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 23.0),
                                                ),
                                                const SizedBox(
                                                  height: 5.0,
                                                ),
                                                Text(
                                                  _saltValue
                                                          .toStringAsFixed(2) +
                                                      "g",
                                                  style: const TextStyle(
                                                    fontFamily: "Poppins",
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 20.0,
                                                  ),
                                                )
                                              ],
                                            ),
                                          )),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Container(
                                        width: 160.0,
                                        height: 200,
                                        alignment: Alignment.centerRight,
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
                                                const SizedBox(
                                                  height: 10.0,
                                                ),
                                                const Icon(
                                                  Icons.run_circle,
                                                  size: 60,
                                                ),
                                                const Text(
                                                  "Saturated\nFat",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontFamily: "Poppins",
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 23.0),
                                                ),
                                                const SizedBox(
                                                  height: 5.0,
                                                ),
                                                Text(
                                                  _saturatedFatValue
                                                          .toStringAsFixed(2) +
                                                      "g",
                                                  style: const TextStyle(
                                                    fontFamily: "Poppins",
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 20.0,
                                                  ),
                                                )
                                              ],
                                            ),
                                          )),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Container(
                                        width: 160.0,
                                        height: 200.0,
                                        alignment: Alignment.centerRight,
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
                                                const SizedBox(
                                                  height: 10.0,
                                                ),
                                                const Icon(
                                                  Icons.run_circle,
                                                  size: 60,
                                                ),
                                                const Text(
                                                  "Sugar",
                                                  style: TextStyle(
                                                      fontFamily: "Poppins",
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 23.0),
                                                ),
                                                const SizedBox(
                                                  height: 5.0,
                                                ),
                                                Text(
                                                  _sugarValue
                                                          .toStringAsFixed(2) +
                                                      "g",
                                                  style: const TextStyle(
                                                    fontFamily: "Poppins",
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 20.0,
                                                  ),
                                                )
                                              ],
                                            ),
                                          )),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              )))
                            ],
                          )));
                });
          } else {
            return const Center(
                child: CircularProgressIndicator(color: Colors.red));
          }
        });
  }

  _buildChart() {
    if (products.length == 0) {
      return Column(
        children: [
          SizedBox(height: 10),
          Icon(
            Icons.warning_outlined,
            size: 72,
          ),
          Center(
              child: Text("No available data for this day",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.bold,
                      fontSize: 35))),
          SizedBox(height: 10)
        ],
      );
    } else {
      products.forEach((element) {
        _fatValue += double.parse(element.productDetail!.fat ?? "0");
        _saltValue += double.parse(element.productDetail!.salt ?? "0");
        _calorieValue += double.parse(element.productDetail!.calories ?? "0");
        _sugarValue += double.parse(element.productDetail!.sugar ?? "0");
        _saturatedFatValue +=
            double.parse(element.productDetail!.saturatedFat ?? "0");
      });
      PieChartSectionData _fat = PieChartSectionData(
          color: Colors.red,
          value: _fatValue.toDouble(),
          title: "Fat",
          radius: 90,
          titleStyle: TextStyle(
            fontFamily: "Poppins",
          ));
      PieChartSectionData _sugar = PieChartSectionData(
          color: Colors.blue,
          value: _sugarValue.toDouble(),
          title: "Sugar",
          radius: 90,
          titleStyle: TextStyle(
            fontFamily: "Poppins",
          ));
      PieChartSectionData _salt = PieChartSectionData(
          color: Colors.green,
          value: _saltValue.toDouble(),
          title: "Salt",
          radius: 90,
          titleStyle: TextStyle(
            fontFamily: "Poppins",
          ));
      PieChartSectionData _saturatedFat = PieChartSectionData(
          color: Colors.orange,
          value: _saturatedFatValue.toDouble(),
          title: "Saturated Fat",
          radius: 90,
          titleStyle: TextStyle(
            fontFamily: "Poppins",
          ));
      sections.add(_fat);
      sections.add(_sugar);
      sections.add(_salt);
      sections.add(_saturatedFat);
      return SizedBox(
          width: 400,
          height: 400,
          child: Column(children: <Widget>[
            AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                  sections: sections,
                  borderData: FlBorderData(show: false),
                  centerSpaceRadius: 90,
                  sectionsSpace: 9,
                ),
              ),
            ),
          ]));
    }
  }

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
    //need to set a fitting light theme since it's just default now
    //but leaving it like this for now
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

  @override
  void initState() {
    super.initState();
    user = widget._user;
    products.clear();

    sections.clear();
  }

  @override
  void dispose() {
    super.dispose();
    products.clear();
    sections.clear();
  }

  @override
  Widget build(BuildContext context) {
    products.clear();
    return Scaffold(
        appBar: AppBar(
            title: const Text("Details",
                style: TextStyle(
                    fontFamily: "Poppins", fontWeight: FontWeight.bold)),
            actions: [
              IconButton(
                onPressed: () => _selectDate(context),
                icon: const Icon(Icons.calendar_month_outlined),
              )
            ]),
        body: SingleChildScrollView(
            physics: BouncingScrollPhysics(), child: _getData()));
  }
}
