import 'package:gooday/src/models/base_model.dart';

class MealModel extends BaseModel {
  num glycemia;
  MealType type;
  DateTime date;
  String userId;
  List<MealFood> foods;

  MealModel({
    required this.userId,
    required this.glycemia,
    required this.type,
    required this.date,
    this.foods = const [],
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) : super(
          id: id,
          createdAt: createdAt,
          updatedAt: updatedAt,
          deletedAt: deletedAt,
        );

  factory MealModel.fromJson(Map<String, dynamic> json) {
    final base = BaseModel.fromJson(json);

    return MealModel(
      userId: json['userId'],
      glycemia: json['glycemia'],
      type: json['type'],
      date: json['date'],
      foods: json['foods'],
      id: base.id,
      createdAt: base.createdAt,
      updatedAt: base.updatedAt,
      deletedAt: base.deletedAt,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json['userId'] = userId;
    json['glycemia'] = glycemia;
    json['type'] = type;
    json['date'] = date;
    json['foods'] = foods;
    return json;
  }
}

class MealFood {
  String foodId;
  MealFoodType type;
  num value;

  MealFood({
    required this.foodId,
    required this.type,
    required this.value,
  });

  MealFood.fromJson(Map<String, dynamic> json)
      : this(
          foodId: json['foodId'],
          type: json['type'],
          value: json['value'],
        );

  Map<String, dynamic> toJson() {
    return {
      'foodId': foodId,
      'type': type,
      'value': value,
    };
  }
}

enum MealType { breakfast, lunch, dinner, snack }

enum MealFoodType { gram, spoon, portion }
