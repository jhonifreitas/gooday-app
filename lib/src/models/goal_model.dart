import 'package:gooday/src/models/base_model.dart';

class GoalModel extends BaseModel {
  num steps;
  num distance;
  num calories;
  num exerciseTime;

  GoalModel({
    this.steps = 0,
    this.distance = 0,
    this.calories = 0,
    this.exerciseTime = 0,
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

  factory GoalModel.fromJson(Map<String, dynamic> json) {
    final base = BaseModel.fromJson(json);

    return GoalModel(
      steps: json['steps'],
      distance: json['distance'],
      calories: json['calories'],
      exerciseTime: json['exerciseTime'],
      id: base.id,
      createdAt: base.createdAt,
      updatedAt: base.updatedAt,
      deletedAt: base.deletedAt,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json['steps'] = steps;
    json['distance'] = distance;
    json['calories'] = calories;
    json['exerciseTime'] = exerciseTime;
    return json;
  }
}
