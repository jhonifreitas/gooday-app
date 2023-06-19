import 'package:gooday/src/models/base_model.dart';

class DrugAlertModel extends BaseModel {
  String userId;
  List<String> drugs;
  int period;
  String time;

  DrugAlertModel({
    required this.userId,
    this.drugs = const [],
    this.period = 1,
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

  factory DrugAlertModel.fromJson(Map<String, dynamic> json) {
    final base = BaseModel.fromJson(json);

    return DrugAlertModel(
      userId: json['userId'],
      drugs: (json['drugs'] as List<dynamic>).cast(),
      period: json['period'],
      time: json['time'],
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
    json['drugs'] = drugs;
    json['period'] = period;
    json['time'] = time;
    return json;
  }
}
