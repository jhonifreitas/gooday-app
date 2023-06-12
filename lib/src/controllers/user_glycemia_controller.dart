import 'package:flutter/material.dart';

import 'package:gooday/src/models/user_model.dart';

class UserGlycemiaController {
  final beforeMealMinCtrl = TextEditingController();
  final beforeMealNormalCtrl = TextEditingController();
  final beforeMealMaxCtrl = TextEditingController();
  final afterMealMinCtrl = TextEditingController();
  final afterMealNormalCtrl = TextEditingController();
  final afterMealMaxCtrl = TextEditingController();
  final beforeSleepMinCtrl = TextEditingController();
  final beforeSleepNormalCtrl = TextEditingController();
  final beforeSleepMaxCtrl = TextEditingController();

  initData(UserModel user) {
    if (user.config?.glycemia != null) {
      beforeMealMinCtrl.text = user.config!.glycemia!.beforeMealMin!.toString();
      beforeMealNormalCtrl.text =
          user.config!.glycemia!.beforeMealNormal!.toString();
      beforeMealMaxCtrl.text = user.config!.glycemia!.beforeMealMax!.toString();
      afterMealMinCtrl.text = user.config!.glycemia!.afterMealMin!.toString();
      afterMealNormalCtrl.text =
          user.config!.glycemia!.afterMealNormal!.toString();
      afterMealMaxCtrl.text = user.config!.glycemia!.afterMealMax!.toString();
      beforeSleepMinCtrl.text =
          user.config!.glycemia!.beforeSleepMin!.toString();
      beforeSleepNormalCtrl.text =
          user.config!.glycemia!.beforeSleepNormal!.toString();
      beforeSleepMaxCtrl.text =
          user.config!.glycemia!.beforeSleepMax!.toString();
    }
  }

  Map<String, num> clearValues() {
    num beforeMealMin = 0;
    num beforeMealNormal = 0;
    num beforeMealMax = 0;
    num afterMealMin = 0;
    num afterMealNormal = 0;
    num afterMealMax = 0;
    num beforeSleepMin = 0;
    num beforeSleepNormal = 0;
    num beforeSleepMax = 0;

    if (beforeMealMinCtrl.text.isNotEmpty) {
      num.parse(beforeMealMinCtrl.text);
    }
    if (beforeMealNormalCtrl.text.isNotEmpty) {
      num.parse(beforeMealNormalCtrl.text);
    }
    if (beforeMealMaxCtrl.text.isNotEmpty) {
      num.parse(beforeMealMaxCtrl.text);
    }
    if (afterMealMinCtrl.text.isNotEmpty) {
      num.parse(afterMealMinCtrl.text);
    }
    if (afterMealNormalCtrl.text.isNotEmpty) {
      num.parse(afterMealNormalCtrl.text);
    }
    if (afterMealMaxCtrl.text.isNotEmpty) {
      num.parse(afterMealMaxCtrl.text);
    }
    if (beforeSleepMinCtrl.text.isNotEmpty) {
      num.parse(beforeSleepMinCtrl.text);
    }
    if (beforeSleepNormalCtrl.text.isNotEmpty) {
      num.parse(beforeSleepNormalCtrl.text);
    }
    if (beforeSleepMaxCtrl.text.isNotEmpty) {
      num.parse(beforeSleepMaxCtrl.text);
    }

    return {
      'beforeMealMin': beforeMealMin,
      'beforeMealNormal': beforeMealNormal,
      'beforeMealMax': beforeMealMax,
      'afterMealMin': afterMealMin,
      'afterMealNormal': afterMealNormal,
      'afterMealMax': afterMealMax,
      'beforeSleepMin': beforeSleepMin,
      'beforeSleepNormal': beforeSleepNormal,
      'beforeSleepMax': beforeSleepMax,
    };
  }
}
