import 'package:gooday/src/models/base_model.dart';

class GoalModel extends BaseModel {
  final int steps;
  final int distance;
  final int calories;
  final int minutes;

  GoalModel({
    this.steps = 0,
    this.distance = 0,
    this.calories = 0,
    this.minutes = 0,
  });
}
