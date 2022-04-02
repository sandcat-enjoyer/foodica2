class Scan {
  String? code;
  Product? product;

  Scan({this.code, this.product});

  factory Scan.fromJson(Map<String, dynamic> parsedJson) {
    return Scan(
        code: parsedJson["code"],
        product: Product.fromJson(parsedJson['product']));
  }
}

class Product {
  var id;
  String? brand;
  String? category;
  String? productname;
  String? image;
  String? allergens;

  NutrientLevels? nutrientLevels;
  Nutriments nutriments;

  Product(
      {this.id,
      this.brand,
      this.category,
      this.productname,
      this.image,
      this.nutrientLevels,
      required this.nutriments,
      this.allergens});

  //still needs more attributes but starting out with this

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        brand: json["brands"],
        category: json["categories"],
        productname: json["product_name"],
        image: json["image_front_small_url"],
        nutrientLevels: NutrientLevels.fromJson(json["nutrient_levels"]),
        nutriments: Nutriments.fromJson(json["nutriments"]),
        allergens: json["allergens"]);
  }

  Map<String, dynamic> toJson() => {
        'brand': brand,
        'category': category,
        'productname': productname,
        'image': image,
        "nutrient_levels": nutrientLevels,
        "nutriments": nutriments,
        "allergens": allergens
      };
}

class NutrientLevels {
  String? fat;
  String? salt;
  String? saturatedFat;
  String? sugars;

  NutrientLevels({this.fat, this.salt, this.saturatedFat, this.sugars});

  factory NutrientLevels.fromJson(Map<String, dynamic> json) {
    return NutrientLevels(
        fat: json["fat"],
        salt: json["salt"],
        saturatedFat: json["saturated-fat"],
        sugars: json["sugars"]);
  }
}

class Nutriments {
  num? carbohydrates;
  num? carbohydratesPer100g;
  num? energyKcal;
  num? energyKcal100g;
  num? fat;
  num? fatPer100g;
  num? fiber;
  num? fiber100g;
  num? proteins;
  num? proteinsPer100g;
  num? salt;
  num? saltPer100g;
  num? saturatedFat;
  num? saturatedFatPer100g;
  num? sodium;
  num? sodiumPer100g;
  num? sugars;
  num? sugarsPer100g;

  Nutriments(
      {this.carbohydrates,
      this.carbohydratesPer100g,
      this.energyKcal,
      this.energyKcal100g,
      this.fat,
      this.fatPer100g,
      this.fiber,
      this.fiber100g,
      this.proteins,
      this.proteinsPer100g,
      this.salt,
      this.saltPer100g,
      this.saturatedFat,
      this.saturatedFatPer100g,
      this.sodium,
      this.sodiumPer100g,
      this.sugars,
      this.sugarsPer100g});

  factory Nutriments.fromJson(Map<String, dynamic> json) {
    return Nutriments(
        carbohydrates: json["carbohydrates"],
        carbohydratesPer100g: json["carbohydrates_100g"],
        energyKcal: json["energy-kcal"],
        energyKcal100g: json["energy-kcal_100g"],
        fat: json["fat"],
        fatPer100g: json["fat_100g"],
        fiber: json["fiber"],
        fiber100g: json["fiber_100g"],
        proteins: json["proteins"],
        proteinsPer100g: json["proteins_100g"],
        salt: json["salt"],
        saltPer100g: json["salt_100g"],
        saturatedFat: json["saturated-fat"],
        saturatedFatPer100g: json["saturated-fat_100g"],
        sugars: json["sugars"],
        sugarsPer100g: json["sugars_100g"],
        sodium: json["sodium"],
        sodiumPer100g: json["sodium_100g"]);
  }
}
