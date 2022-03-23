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

  NutrientLevels? nutrientLevels;
  Nutriments? nutriments;

  Product(
      {this.id,
      this.brand,
      this.category,
      this.productname,
      this.image,
      this.nutrientLevels,
      this.nutriments});

  //still needs more attributes but starting out with this

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        brand: json["brands"],
        category: json["categories"],
        productname: json["product_name"],
        image: json["image_front_small_url"],
        nutrientLevels: NutrientLevels.fromJson(json["nutrient_levels"]));
  }

  Map<String, dynamic> toJson() => {
        'brand': brand,
        'category': category,
        'productname': productname,
        'image': image,
        "nutrient_levels": nutrientLevels
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
  String? carbohydrates;
  String? carbohydratesPer100g;
  String? carbohydratesServing;
  String? energyKcal;
  String? energyKcal100g;
  String? energyKcalServing;
  String? fat;
  String? fatPer100g;
  String? fatServing;
  String? fiber;
  String? fiber100g;
  String? fiberServing;
  String? proteins;
  String? proteinsPer100g;
  String? proteinsServing;
  String? salt;
  String? saltPer100g;
  String? saltServing;
  String? saturatedFat;
  String? saturatedFatPer100g;
  String? saturatedFatServing;
  String? sodium;
  String? sodiumPer100g;
  String? sodiumServing;
  String? sugars;
  String? sugarsPer100g;
  String? sugarsServing;

  Nutriments(
      {this.carbohydrates,
      this.carbohydratesPer100g,
      this.carbohydratesServing,
      this.energyKcal,
      this.energyKcal100g,
      this.energyKcalServing,
      this.fat,
      this.fatPer100g,
      this.fatServing,
      this.fiber,
      this.fiber100g,
      this.fiberServing,
      this.proteins,
      this.proteinsPer100g,
      this.proteinsServing,
      this.salt,
      this.saltPer100g,
      this.saltServing,
      this.saturatedFat,
      this.saturatedFatPer100g,
      this.saturatedFatServing,
      this.sodium,
      this.sodiumPer100g,
      this.sodiumServing,
      this.sugars,
      this.sugarsPer100g,
      this.sugarsServing});

  factory Nutriments.fromJson(Map<String, dynamic> json) {
    return Nutriments(
        carbohydrates: json["carbohydrates"],
        carbohydratesPer100g: json["carbohydrates_100g"],
        carbohydratesServing: json["carbohydrates_serving"],
        energyKcal: json["energy-kcal"],
        energyKcal100g: json["energy-kcal_100g"],
        energyKcalServing: json["energy-kcal_serving"],
        fat: json["fat"],
        fatPer100g: json["fat_100g"],
        fatServing: json["fat_serving"],
        fiber: json["fiber"],
        fiber100g: json["fiber_100g"],
        fiberServing: json["fiber_serving"],
        proteins: json["proteins"],
        proteinsPer100g: json["proteins_100g"],
        proteinsServing: json["proteins_serving"],
        salt: json["salt"],
        saltPer100g: json["salt_100g"],
        saltServing: json["salt_serving"],
        saturatedFat: json["saturated-fat"],
        saturatedFatPer100g: json["saturated-fat_100g"],
        saturatedFatServing: json["saturated-fat_serving"],
        sugars: json["sugars"],
        sugarsPer100g: json["sugars_100g"],
        sugarsServing: json["sugars_serving"]);
  }
}
