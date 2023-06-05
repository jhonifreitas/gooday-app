import 'package:gooday/src/models/base_model.dart';

class GoodieModel extends BaseModel {
  final GoodieType type;
  final int value;

  GoodieModel({
    this.type = GoodieType.goalDone,
    this.value = 0,
  });
}

enum GoodieType { profileComplete, goalDone, used }
