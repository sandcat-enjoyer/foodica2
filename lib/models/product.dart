class Product {
  var id;
  String brand;
  String category;
  String productname;
  String image;
  String nutriscore;

  Product(
      {this.id,
      this.brand,
      this.category,
      this.productname,
      this.image,
      this.nutriscore});

  //still needs more attributes but starting out with this

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      brand: json["brands"],
      category: json["categories"],
      productname: json["product_name"],
      image: json["image_front_small_url"],
      nutriscore: json["nutrition_grades_tags"],
    );
  }
}
