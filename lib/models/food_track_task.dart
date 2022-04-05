import 'package:json_annotation/json_annotation.dart';

import '../utils/uuid.dart';

@JsonSerializable()
class FoodTrackTask {
  String id;
  String foodName;
  num calories;
  num carbs;
  num fat;
  num protein;
  String mealTime;
  DateTime createdOn;
  num grams;

  FoodTrackTask({
    required this.foodName,
    required this.calories,
    required this.carbs,
    required this.protein,
    required this.fat,
    required this.mealTime,
    required this.createdOn,
    required this.grams,
    String? id,
  }) : this.id = id ?? Uuid().generateV4();
}
