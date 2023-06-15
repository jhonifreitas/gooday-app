import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:gooday/src/models/base_model.dart';

class UserModel extends BaseModel {
  String authId;
  String? name;
  String? email;
  String? phone;
  String? image;
  String? genre;
  DateTime? dateBirth;
  int goodies;
  UserAnamnese? anamnese;
  UserConfig? config;

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
    json['anamnese'] = anamnese?.toJson();
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
  List<String> drugs;

  UserAnamnese({
    this.height,
    this.weight,
    this.diabeteType,
    this.insulin,
    this.insulinSlow,
    this.insulinFast,
    this.drugs = const [],
  });

  UserAnamnese.fromJson(Map<String, dynamic> json)
      : this(
          height: json['height'],
          weight: json['weight'],
          diabeteType: json['diabeteType'],
          insulin: json['insulin'],
          insulinSlow: json['insulinSlow'],
          insulinFast: json['insulinFast'],
          drugs: (json['drugs'] as List<dynamic>? ?? []).cast(),
        );

  Map<String, dynamic> toJson() {
    return {
      'height': height,
      'weight': weight,
      'diabeteType': diabeteType,
      'insulin': insulin,
      'insulinSlow': insulinSlow,
      'insulinFast': insulinFast,
      'drugs': drugs,
    };
  }
}

class UserConfig {
  UserConfigGoal? goal;
  UserConfigGlycemia? glycemia;
  UserConfigInsulin? insulin;
  UserConfigBetty? betty;

  UserConfig({
    this.goal,
    this.glycemia,
    this.insulin,
    this.betty,
  });

  UserConfig.fromJson(Map<String, dynamic> json)
      : this(
          goal: json['goal'] != null
              ? UserConfigGoal.fromJson(json['goal'])
              : null,
          glycemia: json['glycemia'] != null
              ? UserConfigGlycemia.fromJson(json['glycemia'])
              : null,
          insulin: json['insulin'] != null
              ? UserConfigInsulin.fromJson(json['insulin'])
              : null,
          betty: json['betty'] != null
              ? UserConfigBetty.fromJson(json['betty'])
              : null,
        );

  Map<String, dynamic> toJson() {
    return {
      'goal': goal?.toJson(),
      'glycemia': glycemia?.toJson(),
      'insulin': insulin?.toJson(),
      'betty': betty?.toJson(),
    };
  }
}

class UserConfigGoal {
  num? steps;
  num? distance;
  num? calories;
  num? exerciseTime;

  UserConfigGoal({
    this.steps = 0,
    this.distance = 0,
    this.calories = 0,
    this.exerciseTime = 0,
  });

  UserConfigGoal.fromJson(Map<String, dynamic> json)
      : this(
          steps: json['steps'],
          distance: json['distance'],
          calories: json['calories'],
          exerciseTime: json['exerciseTime'],
        );

  Map<String, dynamic> toJson() {
    return {
      'steps': steps,
      'distance': distance,
      'calories': calories,
      'exerciseTime': exerciseTime,
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

class UserConfigInsulin {
  String? insulin;
  double? scale;
  List<UserConfigInsulinTime> times;

  UserConfigInsulin({
    required this.insulin,
    required this.scale,
    required this.times,
  });

  factory UserConfigInsulin.fromJson(Map<String, dynamic> json) {
    final timeCast = (json['times'] as List<dynamic>? ?? []).cast();
    final times =
        timeCast.map((e) => UserConfigInsulinTime.fromJson(e)).toList();

    return UserConfigInsulin(
      insulin: json['insulin'],
      scale: json['scale'],
      times: times,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'insulin': insulin,
      'scale': scale,
      'times': times.map((e) => e.toJson()).toList(),
    };
  }
}

class UserConfigInsulinTime {
  String startTime;
  String endTime;
  num fc;
  num ic;

  UserConfigInsulinTime({
    required this.startTime,
    required this.endTime,
    required this.fc,
    required this.ic,
  });

  UserConfigInsulinTime.fromJson(Map<String, dynamic> json)
      : this(
          startTime: json['startTime'],
          endTime: json['endTime'],
          fc: json['fc'],
          ic: json['ic'],
        );

  Map<String, dynamic> toJson() {
    return {
      'startTime': startTime,
      'endTime': endTime,
      'fc': fc,
      'ic': ic,
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
          foodHelps: (json['foodHelps'] as List<dynamic>? ?? []).cast(),
          foodLikes: (json['foodLikes'] as List<dynamic>? ?? []).cast(),
          foodNoLikes: (json['foodNoLikes'] as List<dynamic>? ?? []).cast(),
          foodLimits: (json['foodLimits'] as List<dynamic>? ?? []).cast(),
          doExercise: json['doExercise'],
          exerciseHelps: (json['exerciseHelps'] as List<dynamic>? ?? []).cast(),
          exercises: (json['exercises'] as List<dynamic>? ?? []).cast(),
          timeExercise: (json['timeExercise'] as List<dynamic>? ?? []).cast(),
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
