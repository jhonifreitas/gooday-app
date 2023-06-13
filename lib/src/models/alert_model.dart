import 'package:gooday/src/models/base_model.dart';

class AlertModel extends BaseModel {
  String userId;
  String title;
  String message;
  String time;

  AlertModel({
    required this.userId,
    this.title = '',
    this.message = '',
    this.time = '',
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

  factory AlertModel.fromJson(Map<String, dynamic> json) {
    final base = BaseModel.fromJson(json);

    return AlertModel(
      userId: json['userId'],
      title: json['title'],
      message: json['message'],
      time: json['time'],
      id: base.id,
      createdAt: base.createdAt,
      updatedAt: base.updatedAt,
      deletedAt: base.deletedAt,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    print('opa');
    final json = super.toJson();
    json['userId'] = userId;
    json['title'] = title;
    json['message'] = message;
    json['time'] = time;
    return json;
  }
}
