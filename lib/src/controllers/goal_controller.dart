import 'package:flutter/material.dart';
import 'package:gooday/src/common/item.dart';
import 'package:gooday/src/models/user_model.dart';

class GoalController {
  final stepsCtrl = TextEditingController();
  final distanceCtrl = TextEditingController();
  final caloriesCtrl = TextEditingController();
  final exerciseTimeCtrl = TextEditingController();

  List<Item> stepList(DateTime dateBirth) {
    final now = DateTime.now();
    final age = now.year - dateBirth.year;

    if (age < 40) {
      return const [
        Item(id: '5000', name: '5 mil'),
        Item(id: '6000', name: '6 mil'),
        Item(id: '8500', name: '8.5 mil'),
      ];
    } else if (age < 50) {
      return (const [
        Item(id: '4000', name: '4 mil'),
        Item(id: '6000', name: '6 mil'),
        Item(id: '8000', name: '8 mil'),
      ]);
    } else if (age < 60) {
      return (const [
        Item(id: '4500', name: '3.5 mil'),
        Item(id: '5500', name: '5.5 mil'),
        Item(id: '7500', name: '7.5 mil'),
      ]);
    } else if (age < 70) {
      return (const [
        Item(id: '4000', name: '3 mil'),
        Item(id: '5000', name: '5 mil'),
        Item(id: '7000', name: '7 mil'),
      ]);
    } else if (age < 80) {
      return (const [
        Item(id: '2500', name: '2.5 mil'),
        Item(id: '4500', name: '4.5 mil'),
        Item(id: '6500', name: '6.5 mil'),
      ]);
    } else if (age > 90) {
      return (const [
        Item(id: '2000', name: '2 mil'),
        Item(id: '4000', name: '4 mil'),
        Item(id: '6000', name: '6 mil'),
      ]);
    }

    return [];
  }

  initData(UserModel user) {
    if (user.config?.goal?.steps != null) {
      stepsCtrl.text = user.config!.goal!.steps.toString();
    }
    if (user.config?.goal?.distance != null) {
      distanceCtrl.text = user.config!.goal!.distance.toString();
    }
    if (user.config?.goal?.calories != null) {
      caloriesCtrl.text = user.config!.goal!.calories.toString();
    }
    if (user.config?.goal?.exerciseTime != null) {
      exerciseTimeCtrl.text = user.config!.goal!.exerciseTime.toString();
    }
  }

  Map<String, int?> clearValues() {
    int steps = 0;
    int distance = 0;
    int calories = 0;
    int exerciseTime = 0;

    if (stepsCtrl.text.isNotEmpty) {
      steps = int.parse(stepsCtrl.text);
    }
    if (distanceCtrl.text.isNotEmpty) {
      distance = int.parse(distanceCtrl.text);
    }
    if (caloriesCtrl.text.isNotEmpty) {
      calories = int.parse(caloriesCtrl.text);
    }
    if (exerciseTimeCtrl.text.isNotEmpty) {
      exerciseTime = int.parse(exerciseTimeCtrl.text);
    }

    return {
      'steps': steps,
      'distance': distance,
      'calories': calories,
      'exerciseTime': exerciseTime,
    };
  }
}
