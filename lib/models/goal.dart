import 'package:gooday/models/base.dart';

class Goal extends Base {
  final int steps;
  final int distance;
  final int calories;
  final int minutes;

  const Goal(
      {this.steps = 0, this.distance = 0, this.calories = 0, this.minutes = 0});
}
