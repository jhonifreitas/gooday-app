import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:gooday/src/models/base_model.dart';
import 'package:gooday/src/models/food_model.dart';

class MealModel extends BaseModel {
  num glycemia;
  MealType type;
  DateTime date;
  String userId;
  bool favorite;
  List<MealFood> foods;

  MealModel({
    required this.userId,
    required this.glycemia,
    required this.type,
    required this.date,
    this.favorite = false,
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
    final foodCast = (json['foods'] as List<dynamic>).cast();
    final foods = foodCast.map((e) => MealFood.fromJson(e)).toList();

    return MealModel(
      userId: json['userId'],
      glycemia: json['glycemia'],
      favorite: json['favorite'],
      type: MealType.values
          .firstWhere((value) => value.name == (json['type'] as String)),
      date: (json['date'] as Timestamp).toDate(),
      foods: foods,
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
    json['favorite'] = favorite;
    json['type'] = type.name;
    json['date'] = date;
    json['foods'] = foods.map((e) => e.toJson()).toList();
    return json;
  }
}

class MealFood {
  String foodId;
  String name;
  String measure;
  num quantity;
  num size;
  num cho;
  num calories;
  FoodModel? food;

  MealFood({
    required this.foodId,
    required this.name,
    required this.measure,
    required this.quantity,
    required this.size,
    required this.cho,
    required this.calories,
    this.food,
  });

  MealFood.fromJson(Map<String, dynamic> json)
      : this(
          foodId: json['foodId'],
          name: json['name'],
          measure: json['measure'],
          quantity: json['quantity'],
          size: json['size'],
          cho: json['cho'],
          calories: json['calories'],
        );

  Map<String, dynamic> toJson() {
    return {
      'foodId': foodId,
      'name': name,
      'measure': measure,
      'quantity': quantity,
      'size': size,
      'cho': cho,
      'calories': calories,
    };
  }
}

enum MealType { breakfast, lunch, dinner, snack }
