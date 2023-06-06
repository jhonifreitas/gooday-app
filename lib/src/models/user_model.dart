import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:gooday/src/models/base_model.dart';

class UserModel extends BaseModel {
  final String authId;
  final String? name;
  final String? email;
  final String? phone;
  final String? image;
  final String? genre;
  final DateTime? dateBirth;
  final int goodies;
  final UserAnamnese? anamnese;
  final UserConfig? config;

  UserModel({
    this.authId = '',
    this.name,
    this.email,
    this.phone,
    this.image,
    this.genre,
    this.goodies = 0,
    this.dateBirth,
    this.anamnese,
    this.config,
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

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final base = BaseModel.fromJson(json);
    final dateBirth = json['dateBirth'];

    return UserModel(
      authId: json['authId'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      image: json['image'],
      genre: json['genre'],
      goodies: json['goodies'],
      dateBirth: dateBirth != null && dateBirth != ''
          ? (dateBirth as Timestamp).toDate()
          : null,
      anamnese: UserAnamnese.fromJson(json['anamnese'] ?? {}),
      config: UserConfig.fromJson(json['config'] ?? {}),
      id: base.id,
      createdAt: base.createdAt,
      updatedAt: base.updatedAt,
      deletedAt: base.deletedAt,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json['authId'] = authId;
    json['name'] = name;
    json['email'] = email;
    json['phone'] = phone;
    json['image'] = image;
    json['genre'] = genre;
    json['dateBirth'] = dateBirth;
    json['goodies'] = goodies;
    json['anamnese'] = anamnese;
    json['config'] = config?.toJson();
    return json;
  }
}

class UserAnamnese {
  double? height;
  double? weight;
  String? diabeteType;
  bool? insulin;
  String? insulinSlow;
  String? insulinFast;
  String? drug;

  UserAnamnese({
    this.height,
    this.weight,
    this.diabeteType,
    this.insulin,
    this.insulinSlow,
    this.insulinFast,
    this.drug,
  });

  UserAnamnese.fromJson(Map<String, dynamic> json)
      : this(
          height: json['height'],
          weight: json['weight'],
          diabeteType: json['diabeteType'],
          insulin: json['insulin'],
          insulinSlow: json['insulinSlow'],
          insulinFast: json['insulinFast'],
          drug: json['drug'],
        );

  Map<String, dynamic> toJson() {
    return {
      'height': height,
      'weight': weight,
      'diabeteType': diabeteType,
      'insulin': insulin,
      'insulinSlow': insulinSlow,
      'insulinFast': insulinFast,
      'drug': drug,
    };
  }
}

class UserConfig {
  UserConfigGoal? goal;
  UserConfigGlycemia? glycemia;
  UserConfigBetty? betty;

  UserConfig({
    this.goal,
    this.glycemia,
    this.betty,
  });

  UserConfig.fromJson(Map<String, dynamic> json)
      : this(
          goal: UserConfigGoal.fromJson(json['goal'] ?? {}),
          glycemia: UserConfigGlycemia.fromJson(json['glycemia'] ?? {}),
          betty: UserConfigBetty.fromJson(json['betty'] ?? {}),
        );

  Map<String, dynamic> toJson() {
    return {
      'goal': goal?.toJson(),
      'glycemia': glycemia?.toJson(),
      'betty': betty?.toJson(),
    };
  }
}

class UserConfigGoal {
  int? steps;
  int? distance;
  int? calories;
  int? activeMinutes;

  UserConfigGoal({
    this.steps = 0,
    this.distance = 0,
    this.calories = 0,
    this.activeMinutes = 0,
  });

  UserConfigGoal.fromJson(Map<String, dynamic> json)
      : this(
          steps: json['steps'],
          distance: json['distance'],
          calories: json['calories'],
          activeMinutes: json['activeMinutes'],
        );

  Map<String, dynamic> toJson() {
    return {
      'steps': steps,
      'distance': distance,
      'calories': calories,
      'activeMinutes': activeMinutes,
    };
  }
}

class UserConfigGlycemia {
  int? beforeMealMin;
  int? beforeMealNormal;
  int? beforeMealMax;
  int? afterMealMin;
  int? afterMealNormal;
  int? afterMealMax;
  int? beforeSleepMin;
  int? beforeSleepNormal;
  int? beforeSleepMax;

  UserConfigGlycemia({
    this.beforeMealMin = 0,
    this.beforeMealNormal = 0,
    this.beforeMealMax = 0,
    this.afterMealMin = 0,
    this.afterMealNormal = 0,
    this.afterMealMax = 0,
    this.beforeSleepMin = 0,
    this.beforeSleepNormal = 0,
    this.beforeSleepMax = 0,
  });

  UserConfigGlycemia.fromJson(Map<String, dynamic> json)
      : this(
          beforeMealMin: json['beforeMealMin'],
          beforeMealNormal: json['beforeMealNormal'],
          beforeMealMax: json['beforeMealMax'],
          afterMealMin: json['afterMealMin'],
          afterMealNormal: json['afterMealNormal'],
          afterMealMax: json['afterMealMax'],
          beforeSleepMin: json['beforeSleepMin'],
          beforeSleepNormal: json['beforeSleepNormal'],
          beforeSleepMax: json['beforeSleepMax'],
        );

  Map<String, dynamic> toJson() {
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

class UserConfigBetty {
  bool? lostWeight;
  bool? adequateFood;
  List<String> foodHelps;
  List<String> foodLikes;
  List<String> foodNoLikes;
  List<String> foodLimits;

  bool? doExercise;
  List<String> exerciseHelps;
  List<String> exercises;
  List<String> timeExercise;
  int? frequencyExercise;

  UserConfigBetty({
    this.lostWeight,
    this.adequateFood,
    this.foodHelps = const [],
    this.foodLikes = const [],
    this.foodNoLikes = const [],
    this.foodLimits = const [],
    this.doExercise,
    this.exerciseHelps = const [],
    this.exercises = const [],
    this.timeExercise = const [],
    this.frequencyExercise,
  });

  UserConfigBetty.fromJson(Map<String, dynamic> json)
      : this(
          lostWeight: json['lostWeight'],
          adequateFood: json['adequateFood'],
          foodHelps: (json['foodHelps'] as List<dynamic>).cast(),
          foodLikes: (json['foodLikes'] as List<dynamic>).cast(),
          foodNoLikes: (json['foodNoLikes'] as List<dynamic>).cast(),
          foodLimits: (json['foodLimits'] as List<dynamic>).cast(),
          doExercise: json['doExercise'],
          exerciseHelps: (json['exerciseHelps'] as List<dynamic>).cast(),
          exercises: (json['exercises'] as List<dynamic>).cast(),
          timeExercise: (json['timeExercise'] as List<dynamic>).cast(),
          frequencyExercise: json['frequencyExercise'],
        );

  Map<String, dynamic> toJson() {
    return {
      'lostWeight': lostWeight,
      'adequateFood': adequateFood,
      'foodHelps': foodHelps,
      'foodLikes': foodLikes,
      'foodNoLikes': foodNoLikes,
      'foodLimits': foodLimits,
      'doExercise': doExercise,
      'exerciseHelps': exerciseHelps,
      'exercises': exercises,
      'timeExercise': timeExercise,
      'frequencyExercise': frequencyExercise,
    };
  }
}
