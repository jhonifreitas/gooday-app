import 'package:gooday/src/models/base_model.dart';

class GoodieModel extends BaseModel {
  String userId;
  int value;
  num? goal;
  GoodieType type;

  GoodieModel({
    required this.userId,
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
    final typeStr = json['type'] as String;
    final type =
        GoodieType.values.singleWhere((value) => value.name == typeStr);

    return GoodieModel(
      userId: json['userId'],
      type: type,
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
    json['userId'] = userId;
    json['type'] = type.name;
    json['value'] = value;
    json['goal'] = goal;
    return json;
  }
}

enum GoodieType { profileComplete, goalDone, used }
