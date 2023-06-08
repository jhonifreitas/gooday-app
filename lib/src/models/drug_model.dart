import 'package:gooday/src/models/base_model.dart';

class DrugModel extends BaseModel {
  String name;

  DrugModel({
    required this.name,
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

  factory DrugModel.fromJson(Map<String, dynamic> json) {
    final base = BaseModel.fromJson(json);

    return DrugModel(
      name: json['name'],
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
    return json;
  }
}
