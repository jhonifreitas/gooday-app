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
      if (user.config!.glycemia!.beforeMealMin != null) {
        beforeMealMinCtrl.text =
            user.config!.glycemia!.beforeMealMin!.toString();
      }
      if (user.config!.glycemia!.beforeMealNormal != null) {
        beforeMealNormalCtrl.text =
            user.config!.glycemia!.beforeMealNormal!.toString();
      }
      if (user.config!.glycemia!.beforeMealMax != null) {
        beforeMealMaxCtrl.text =
            user.config!.glycemia!.beforeMealMax!.toString();
      }
      if (user.config!.glycemia!.afterMealMin != null) {
        afterMealMinCtrl.text = user.config!.glycemia!.afterMealMin!.toString();
      }
      if (user.config!.glycemia!.afterMealNormal != null) {
        afterMealNormalCtrl.text =
            user.config!.glycemia!.afterMealNormal!.toString();
      }
      if (user.config!.glycemia!.afterMealMax != null) {
        afterMealMaxCtrl.text = user.config!.glycemia!.afterMealMax!.toString();
      }
      if (user.config!.glycemia!.beforeSleepMin != null) {
        beforeSleepMinCtrl.text =
            user.config!.glycemia!.beforeSleepMin!.toString();
      }
      if (user.config!.glycemia!.beforeSleepNormal != null) {
        beforeSleepNormalCtrl.text =
            user.config!.glycemia!.beforeSleepNormal!.toString();
      }
      if (user.config!.glycemia!.beforeSleepMax != null) {
        beforeSleepMaxCtrl.text =
            user.config!.glycemia!.beforeSleepMax!.toString();
      }
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
      beforeMealMin = num.parse(beforeMealMinCtrl.text);
    }
    if (beforeMealNormalCtrl.text.isNotEmpty) {
      beforeMealNormal = num.parse(beforeMealNormalCtrl.text);
    }
    if (beforeMealMaxCtrl.text.isNotEmpty) {
      beforeMealMax = num.parse(beforeMealMaxCtrl.text);
    }
    if (afterMealMinCtrl.text.isNotEmpty) {
      afterMealMin = num.parse(afterMealMinCtrl.text);
    }
    if (afterMealNormalCtrl.text.isNotEmpty) {
      afterMealNormal = num.parse(afterMealNormalCtrl.text);
    }
    if (afterMealMaxCtrl.text.isNotEmpty) {
      afterMealMax = num.parse(afterMealMaxCtrl.text);
    }
    if (beforeSleepMinCtrl.text.isNotEmpty) {
      beforeSleepMin = num.parse(beforeSleepMinCtrl.text);
    }
    if (beforeSleepNormalCtrl.text.isNotEmpty) {
      beforeSleepNormal = num.parse(beforeSleepNormalCtrl.text);
    }
    if (beforeSleepMaxCtrl.text.isNotEmpty) {
      beforeSleepMax = num.parse(beforeSleepMaxCtrl.text);
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
