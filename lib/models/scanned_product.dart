import 'package:Foodica/models/scanned_product.dart';

class ScannedProduct {
  String? productID;
  ProductDetail? productDetail;

  ScannedProduct({
    this.productID,
    this.productDetail
});
  
  factory ScannedProduct.fromJson(Map<String, dynamic> json) {
    return ScannedProduct(
      productID: json[0],
      productDetail: ProductDetail.fromJson(json)
    );
  }
}

class ProductDetail {
  List<String>? allergens;
  String? code;
  String? referenceId;
  String? brand;
  String? calories;
  String? category;
  String? fat;
  String? image;
  String? productname;
  String? salt;
  String? saturatedFat;
  String? sugar;
  DateTime? scanTime;

  ProductDetail(
      {this.allergens,
        this.code,
      this.brand,
      this.referenceId,
      this.calories,
      this.category,
      this.fat,
      this.image,
      this.productname,
      this.salt,
      this.saturatedFat,
      this.scanTime,
      this.sugar});

  factory ProductDetail.fromJson(Map<String, dynamic> json) {
    return ProductDetail(
        allergens: null,
        code: json["code"] ?? "",
        brand: json["brand"] ?? "",
        calories: json["calories"] ?? "",
        category: json["category"] ?? "",
        fat: json["fat"] ?? "",
        image: json["image"] ?? "",
        productname: json["productname"] ?? "",
        salt: json["salt"] ?? "",
        saturatedFat: json["saturatedFat"] ?? "",
        sugar: json["sugar"] ?? "",
        scanTime: json["scanTime"] ?? DateTime.now() // temp fix
        );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'allergens': allergens,
        'brand': brand,
        'category': category,
        'fat': fat,
        'image': image,
        'productname': productname,
        'salt': salt,
        'saturatedFat': saturatedFat,
        'sugar': sugar,
        'scanTime': scanTime
      };

}
