import 'package:gooday/src/models/base_model.dart';

class GlycemiaModel extends BaseModel {
  num value;
  DateTime date;
  GlycemiaType type;

  GlycemiaModel({
    required this.type,
    required this.date,
    required this.value,
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

  factory GlycemiaModel.fromJson(Map<String, dynamic> json) {
    final base = BaseModel.fromJson(json);

    return GlycemiaModel(
      type: json['type'],
      date: json['date'],
      value: json['value'],
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
  onSleep
}
