import 'package:flutter/material.dart';
import 'package:foodica/models/product.dart';
import 'package:foodica/models/product_api.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key, required this.barcode}) : super(key: key);
  final String barcode;

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Product scannedProduct = new Product();

  @override
  void initState() {
    super.initState();
    _getProduct(widget.barcode);
  }

  void _getProduct(String barcode) {
    ProductApi.fetchProduct(barcode).then((result) {
      setState(() {
        debugPrint("In set state");
        debugPrint(result.toString());
        debugPrint(result.code);
        debugPrint(result.product!.productname);
        debugPrint(result.product!.brand);
        debugPrint(result.product!.image);
        debugPrint(scannedProduct.toString());
        scannedProduct.productname = result.product!.productname;
        scannedProduct.brand = result.product!.brand;
        scannedProduct.category = result.product!.category;
        scannedProduct.image = result.product!.image;
        scannedProduct.nutriments?.salt = result.product!.nutriments?.salt;
        scannedProduct.nutriments?.saturatedFat =
            result.product!.nutriments?.saturatedFat;
        scannedProduct.nutriments?.sugars = result.product!.nutriments?.sugars;
        debugPrint(scannedProduct.toString());
      });
    });
  }

  Widget? _buildPage() {
    if (scannedProduct.productname == "") {
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
            Text(widget.barcode),
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
                            width: 250.0,
                            height: 150.0,
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
                                                  fontSize: 25.0,
                                                  fontWeight: FontWeight.w600)),
                                          const SizedBox(height: 10.0),
                                          Text(scannedProduct.productname ?? "",
                                              style: const TextStyle(
                                                  fontFamily: "Poppins",
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w500))
                                        ],
                                      ))),
                            ))
                      ],
                    ),
                  ),
                )
              ],
            ),
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
                            width: 250.0,
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
                                          Text("Allergens",
                                              style: TextStyle(
                                                  fontFamily: "Poppins",
                                                  fontSize: 25.0,
                                                  fontWeight: FontWeight.w600)),
                                          SizedBox(height: 10.0),
                                          Text("Possible allergens",
                                              style: TextStyle(
                                                  fontFamily: "Poppins",
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w500))
                                        ],
                                      ))),
                            ))
                      ],
                    ),
                  ),
                )
              ],
            ),
            /* Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Center(
                    child: Wrap(
                      spacing: 20,
                      runSpacing: 20.0,
                      children: <Widget>[
                        SizedBox(
                            width: 250.0,
                            height: 150.0,
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
                                                  fontWeight: FontWeight.w600)),
                                          const SizedBox(height: 10.0),
                                          Text(
                                              scannedProduct.nutriments!
                                                      .saturatedFat ??
                                                  "",
                                              style: const TextStyle(
                                                  fontFamily: "Poppins",
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w500))
                                        ],
                                      ))),
                            ))
                      ],
                    ),
                  ),
                )
              ],
            ), */
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
                            width: 250.0,
                            height: 150.0,
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
                                                  fontWeight: FontWeight.w600)),
                                          const SizedBox(height: 10.0),
                                          Text(
                                              scannedProduct.nutriments?.salt ??
                                                  "",
                                              style: const TextStyle(
                                                  fontFamily: "Poppins",
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w500))
                                        ],
                                      ))),
                            ))
                      ],
                    ),
                  ),
                )
              ],
            ),
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
                            width: 250.0,
                            height: 150.0,
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
                                                  fontSize: 25.0,
                                                  fontWeight: FontWeight.w600)),
                                          const SizedBox(height: 10.0),
                                          Text(
                                              scannedProduct.nutriments?.fat ??
                                                  "",
                                              style: const TextStyle(
                                                  fontFamily: "Poppins",
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w500))
                                        ],
                                      ))),
                            ))
                      ],
                    ),
                  ),
                )
              ],
            ),
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
                            width: 250.0,
                            height: 150.0,
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
                                                  fontSize: 25.0,
                                                  fontWeight: FontWeight.w600)),
                                          const SizedBox(height: 10.0),
                                          Text(
                                              scannedProduct
                                                      .nutriments?.sugars ??
                                                  "",
                                              style: const TextStyle(
                                                  fontFamily: "Poppins",
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w500))
                                        ],
                                      ))),
                            ))
                      ],
                    ),
                  ),
                )
              ],
            ),
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
