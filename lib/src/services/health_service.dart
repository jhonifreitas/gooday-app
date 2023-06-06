import 'dart:io';

import 'package:health/health.dart';

class HealthService {
  final _health = HealthFactory();

  List<HealthDataType> get _types {
    final list = [
      HealthDataType.STEPS, // Passos
      HealthDataType.ACTIVE_ENERGY_BURNED, // Calorias queimadas
    ];

    if (Platform.isAndroid) {
      list.add(HealthDataType.MOVE_MINUTES); // Minutos de movimento
      list.add(HealthDataType.DISTANCE_DELTA); // Distancia em metros
    } else if (Platform.isIOS) {
      list.add(HealthDataType.EXERCISE_TIME); // Minutos de exercicio
      list.add(HealthDataType
          .DISTANCE_WALKING_RUNNING); // Distancia caminhado em metros
    }

    return list;
  }

  Future<Map<String, num>> fetchData(DateTime date) async {
    List<HealthDataAccess> permissions = [];
    final start = DateTime(date.year, date.month, date.day, 0, 0, 0);
    final end = start.add(const Duration(days: 1));

    for (final _ in _types) {
      permissions.add(HealthDataAccess.READ);
    }

    bool requested =
        await _health.requestAuthorization(_types, permissions: permissions);

    if (!requested) throw 'Request Denied!';

    final points = await _health.getHealthDataFromTypes(start, end, _types);

    num steps = 0;
    num distance = 0;
    num calories = 0;
    num exerciseTime = 0;

    for (var point in points) {
      if (point.type == HealthDataType.STEPS) {
        steps += num.parse(point.value.toString());
      } else if (point.type == HealthDataType.ACTIVE_ENERGY_BURNED) {
        calories += num.parse(point.value.toString());
      } else if (point.type == HealthDataType.DISTANCE_DELTA ||
          point.type == HealthDataType.DISTANCE_WALKING_RUNNING) {
        distance += num.parse(point.value.toString());
      } else if (point.type == HealthDataType.MOVE_MINUTES ||
          point.type == HealthDataType.EXERCISE_TIME) {
        exerciseTime += num.parse(point.value.toString());
      }
    }

    return {
      'steps': steps,
      'distance': distance,
      'calories': calories,
      'exerciseTime': exerciseTime,
    };
  }
}
