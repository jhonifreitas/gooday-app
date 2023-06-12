import 'package:gooday/src/models/base_model.dart';

class FoodModel extends BaseModel {
  String name;
  String measure;
  num size;
  num cho;
  num calories;

  FoodModel({
    required this.name,
    required this.measure,
    required this.size,
    required this.cho,
    required this.calories,
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

  factory FoodModel.fromJson(Map<String, dynamic> json) {
    final base = BaseModel.fromJson(json);

    return FoodModel(
      name: json['name'],
      measure: json['measure'],
      cho: json['cho'],
      calories: json['calories'],
      size: json['size'],
      id: base.id,
      createdAt: base.createdAt,
      updatedAt: base.updatedAt,
      deletedAt: base.deletedAt,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json['name'] = name;
    json['measure'] = measure;
    json['cho'] = cho;
    json['calories'] = calories;
    json['size'] = size;
    return json;
  }
}
