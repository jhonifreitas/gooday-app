import 'package:gooday/src/models/base_model.dart';

class GoodieModel extends BaseModel {
  int value;
  num? goal;
  GoodieType type;

  GoodieModel({
    this.value = 0,
    this.type = GoodieType.goalDone,
    this.goal,
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

  factory GoodieModel.fromJson(Map<String, dynamic> json) {
    final base = BaseModel.fromJson(json);

    return GoodieModel(
      type: json['type'],
      value: json['value'],
      goal: json['goal'],
      id: base.id,
      createdAt: base.createdAt,
      updatedAt: base.updatedAt,
      deletedAt: base.deletedAt,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json['type'] = type;
    json['value'] = value;
    json['goal'] = goal;
    return json;
  }
}

enum GoodieType { profileComplete, goalDone, used }
