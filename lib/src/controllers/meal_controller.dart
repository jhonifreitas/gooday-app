import 'package:flutter/material.dart';

import 'package:gooday/src/common/item.dart';
import 'package:gooday/src/models/meal_model.dart';

class MealController {
  final typeCtrl = TextEditingController();
  final glycemiaCtrl = TextEditingController();
  List<MealFood> foodListCtrl = [];
  DateTime dateCtrl = DateTime.now().subtract(
    Duration(minutes: DateTime.now().minute % 5),
  );

  final List<Item> typeList = [
    Item(
      id: MealType.breakfast.name,
      name: 'Café',
      image: 'assets/icons/sandwich.svg',
    ),
    Item(
      id: MealType.lunch.name,
      name: 'Almoço',
      image: 'assets/icons/chicken.svg',
    ),
    Item(
      id: MealType.dinner.name,
      name: 'Jantar',
      image: 'assets/icons/cake.svg',
    ),
    Item(
      id: MealType.snack.name,
      name: 'Lanche',
      image: 'assets/icons/fruits.svg',
    ),
  ];

  initData(MealModel data) {
    typeCtrl.text = data.type.name;
    glycemiaCtrl.text = data.glycemia.toString();
    dateCtrl = data.date;
    foodListCtrl = data.foods;
  }

  MealType clearType() {
    return MealType.values.firstWhere((value) => value.name == typeCtrl.text);
  }

  num clearGlycemia() {
    return num.parse(glycemiaCtrl.text);
  }
}
