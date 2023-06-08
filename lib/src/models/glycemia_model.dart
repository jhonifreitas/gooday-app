import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gooday/src/models/base_model.dart';

class GlycemiaModel extends BaseModel {
  String userId;
  num value;
  DateTime date;
  GlycemiaType type;

  GlycemiaModel({
    required this.userId,
    this.type = GlycemiaType.afterBreakfast,
    DateTime? date,
    this.value = 0,
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  })  : date = date ?? DateTime.now(),
        super(
          id: id,
          createdAt: createdAt,
          updatedAt: updatedAt,
          deletedAt: deletedAt,
        );

  factory GlycemiaModel.fromJson(Map<String, dynamic> json) {
    final base = BaseModel.fromJson(json);
    final typeStr = json['type'] as String;
    final type =
        GlycemiaType.values.singleWhere((value) => value.name == typeStr);

    return GlycemiaModel(
      userId: json['userId'],
      type: type,
      value: json['value'],
      date: (json['date'] as Timestamp).toDate(),
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
    json['date'] = date;
    json['value'] = value;
    return json;
  }
}

enum GlycemiaType {
  beforeBreakfast,
  afterBreakfast,
  beforeLunch,
  afterLunch,
  beforeDinner,
  afterDinner,
  sleep
}
