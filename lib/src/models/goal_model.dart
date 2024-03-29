import 'package:gooday/src/models/base_model.dart';

class GoalModel extends BaseModel {
  String userId;
  num steps;
  num distance;
  num calories;
  num exerciseTime;

  GoalModel({
    required this.userId,
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
      userId: json['userId'],
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
    json['userId'] = userId;
    json['steps'] = steps;
    json['distance'] = distance;
    json['calories'] = calories;
    json['exerciseTime'] = exerciseTime;
    return json;
  }
}
