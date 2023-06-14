import 'package:flutter/material.dart';

import 'package:gooday/src/models/alert_model.dart';

class AlertController {
  final titleCtrl = TextEditingController();
  final messageCtrl = TextEditingController();
  final timeCtrl = TextEditingController();

  initData(AlertModel data) {
    titleCtrl.text = data.title;
    messageCtrl.text = data.message;
    timeCtrl.text = data.time;
  }
}
