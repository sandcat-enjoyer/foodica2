import 'package:http/http.dart' as http;
import '../models/product.dart';
import 'dart:convert';

class ProductApi {
  static String server = "world.openfoodfacts.org";

  static Future<Scan> fetchProduct(String barcode) async {
    var url = Uri.https(server, "/api/v0/product/" + barcode + ".json");
    print(url);

    final response = await http.get(url);
    print(response.body);
    if (response.statusCode == 200) {
      return Scan.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load product');
    }
  }
}
