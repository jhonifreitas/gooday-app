import 'package:flutter/material.dart';

import 'package:gooday/src/models/alert_model.dart';

class AlertController {
  final titleCtrl = TextEditingController();
  final messageCtrl = TextEditingController();
  final timeCtrl = TextEditingController();

  initData(AlertModel data) {
    if (data.title != null) titleCtrl.text = data.title!;
    if (data.message != null) messageCtrl.text = data.message!;
    if (data.time != null) timeCtrl.text = data.time!;
  }
}
