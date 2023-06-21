import 'package:intl/intl.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';

import 'package:gooday/src/common/theme.dart';
import 'package:gooday/src/widgets/appbar.dart';
import 'package:gooday/src/widgets/timeline.dart';
import 'package:gooday/src/models/user_model.dart';
import 'package:gooday/src/models/meal_model.dart';
import 'package:gooday/src/widgets/line_chart.dart';
import 'package:gooday/src/models/insulin_model.dart';
import 'package:gooday/src/models/glycemia_model.dart';
import 'package:gooday/src/providers/user_provider.dart';
import 'package:gooday/src/services/api/meal_service.dart';
import 'package:gooday/src/services/api/insulin_service.dart';
import 'package:gooday/src/pages/calculator/insulin_page.dart';
import 'package:gooday/src/services/api/glycemia_service.dart';
import 'package:gooday/src/pages/calculator/glycemia_page.dart';

class CalculatorListPage extends StatefulWidget {
  const CalculatorListPage({required this.goToPage, super.key});

  final ValueChanged<int> goToPage;

  @override
  State<CalculatorListPage> createState() => _CalculatorListPageState();
}

class _CalculatorListPageState extends State<CalculatorListPage> {
  late final UserProvider _userProvider;

  final _mealApi = MealApiService();
  final _insulinApi = InsulinApiService();
  final _glycemiaApi = GlycemiaApiService();

  List<dynamic> _items = [];
  late Future<List<dynamic>> _loadList;

  int _filter = 7;
  List<LineChartBarData> _chartData = [];

  @override
  void initState() {
    _userProvider = Provider.of<UserProvider>(context, listen: false);
    _loadList = _loadData();
    super.initState();
  }

  Future<List<dynamic>> _loadData() async {
    final list = [];
    final user = _userProvider.data!;

    final end = DateTime.now();
    DateTime start = end.subtract(Duration(days: _filter));

    final glycemias = await _glycemiaApi.getByRangeDate(user.id!, start, end);
    final meals = await _mealApi.getByRangeDate(user.id!, start, end);
    final insulins = await _insulinApi.getByRangeDate(user.id!, start, end);

    list.addAll(glycemias);
    list.addAll(meals);
    list.addAll(insulins);

    list.sort((a, b) => b.date.compareTo(a.date));

    _loadChart(list);

    return list;
  }

  void _loadChart(List<dynamic> list) {
    List<FlSpot> spots = [];

    final items = list.where((item) => item is! InsulinModel);
    for (final item in items) {
      double value = 0.0;
      final dateTime = (item.date as DateTime);
      final double time = dateTime.millisecondsSinceEpoch.toDouble();

      if (item is MealModel) {
        value = item.glycemia.toDouble();
      } else if (item is GlycemiaModel) {
        value = item.value.toDouble();
      }

      final index = spots.indexWhere((spot) {
        final spotDateTime =
            DateTime.fromMillisecondsSinceEpoch(spot.x.toInt());
        return spotDateTime.day == dateTime.day &&
            spotDateTime.month == dateTime.month &&
            spotDateTime.year == dateTime.year;
      });
      if (index >= 0) {
        final exist = spots[index];
        spots[index] = FlSpot(time, value.toDouble() + exist.y);
      } else {
        spots.add(FlSpot(time, value.toDouble()));
      }
    }

    List<LineChartBarData> chartData = [];
    if (spots.isNotEmpty) {
      chartData.add(LineChartBarData(
        barWidth: 3,
        spots: spots,
        isCurved: true,
        color: primaryColor,
      ));
    }

    if (!mounted) return;

    setState(() {
      _chartData = chartData;
    });
  }

  void _goToMealForm([String? id]) async {
    String url = '/refeicao';

    if (id != null) url += '/$id';

    final result = await context.push(url);
    if (result != null) {
      _reloadData();

      if (id == null && result is MealModel) {
        _openInsulinForm(meal: result);
      }
    }
  }

  void _openGlycemiaForm([GlycemiaModel? data]) async {
    final result = await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return GlycemiaPage(data: data);
      },
    );
    if (result != null) _reloadData();
  }

  void _openInsulinForm({InsulinModel? data, MealModel? meal}) async {
    num? insulinActive;
    num? valueRecommended;

    if (data == null && _items.isNotEmpty) {
      num cho = 0;
      num calories = 0;
      num glycemia = 0;
      DateTime date = DateTime.now();

      meal ??= _items.firstWhere((item) => item is MealModel,
          orElse: () => null) as MealModel?;

      if (meal != null) {
        date = meal.date;
        glycemia = meal.glycemia;
        cho = meal.foods.fold(0.0, (prev, value) => prev + value.cho);
        calories = meal.foods.fold(0.0, (prev, value) => prev + value.calories);
      }

      final result = _insulinCalc(
          date: date, glycemia: glycemia, cho: cho, calories: calories);
      if (result.active > 0) insulinActive = result.active;
      if (result.recommended > 0) valueRecommended = result.recommended;
    }

    final result = await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return InsulinPage(
          data: data,
          insulinActive: insulinActive,
          valueRecommended: valueRecommended,
        );
      },
    );
    if (result != null) _reloadData();
  }

  InsulinCalc _insulinCalc({
    required DateTime date,
    required num glycemia,
    required num cho,
    required num calories,
  }) {
    final result = InsulinCalc();
    final now = DateTime.now();

    if (_userProvider.data?.config?.insulin != null &&
        _userProvider.data?.config?.glycemia != null) {
      final insulinConfig = _userProvider.data!.config!.insulin!;
      final glycemiaConfig = _userProvider.data!.config!.glycemia!;
      final duration = Duration(minutes: insulinConfig.duration);

      result.active = _items
          .where((item) =>
              item is InsulinModel && item.date.add(duration).isAfter(now))
          .fold(0.0, (prev, cur) {
        final item = (cur as InsulinModel);
        final endDate = item.date.add(duration);
        final valueInMin = item.value / insulinConfig.duration;
        final diff = endDate.difference(now);
        final value = valueInMin * diff.inMinutes;
        return prev + value;
      });

      final param = insulinConfig.params
          .cast<UserConfigInsulinParam?>()
          .firstWhere((param) {
        final startTime = int.parse(param!.startTime.replaceAll(':', ''));
        final endTime = int.parse(param.endTime.replaceAll(':', ''));
        final timeDate = int.parse('${date.hour}${date.minute}');

        return startTime >= timeDate && endTime <= timeDate;
      }, orElse: () => null);

      if (param != null && cho > 0 && glycemia > 0) {
        result.recommended = (cho / param.ic) - result.active;
        result.recommended +=
            (glycemia - glycemiaConfig.beforeMealNormal) / param.fc;
      }
    }

    return result;
  }

  void _onFilter(int? value) {
    if (value != null) {
      setState(() {
        _filter = value;
      });
      _reloadData();
    }
  }

  void _reloadData() {
    setState(() {
      _loadList = _loadData();
    });
  }

  void _onEdit(dynamic item) {
    if (item is GlycemiaModel) {
      _openGlycemiaForm(item);
    } else if (item is MealModel) {
      _goToMealForm(item.id);
    } else if (item is InsulinModel) {
      _openInsulinForm(data: item);
    }
  }

  String _getDateLabel(DateTime date) {
    final now = DateTime.now();

    if (now.month == date.month && now.year == date.year) {
      if (now.day == date.day) return 'Hoje';
      if (now.day - 1 == date.day) return 'Ontem';
    }

    final month = DateFormat('MMM').format(date);
    return '${date.day} de $month';
  }

  String _getTimeLabel(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }

  String _getTitle(dynamic item) {
    if (item is MealModel) {
      if (MealType.breakfast == item.type) {
        return 'Café da manhã';
      } else if (MealType.lunch == item.type) {
        return 'Almoço';
      } else if (MealType.dinner == item.type) {
        return 'Jantar';
      } else if (MealType.snack == item.type) {
        return 'Lanche';
      }
    } else if (item is GlycemiaModel) {
      return 'Glicemia';
    } else if (item is InsulinModel) {
      return 'Insulina';
    }

    return '---';
  }

  String _getDescription(dynamic item) {
    if (item is GlycemiaModel) {
      return '${item.value} (mg/dL)';
    } else if (item is MealModel) {
      final choTotal = item.foods.fold(0.0, (prev, value) => prev + value.cho);
      final caloriesTotal =
          item.foods.fold(0.0, (prev, value) => prev + value.calories);
      final sizeTotal =
          item.foods.fold(0.0, (prev, value) => prev + value.size);

      final choStr = NumberFormat().format(choTotal);
      final caloriesStr = NumberFormat().format(caloriesTotal);
      final sizeStr = NumberFormat().format(sizeTotal);
      final glycemiaStr = NumberFormat().format(item.glycemia);

      return '${choStr}g Carbos | '
          '${caloriesStr}kcal Calorias | '
          '$sizeStr(g/ml) Peso | '
          '$glycemiaStr(mg/dL) Glicemia';
    } else if (item is InsulinModel) {
      final valueStr = NumberFormat().format(item.value);
      return '$valueStr(uni)';
    }

    return '---';
  }

  String _getIcon(dynamic item) {
    if (item is MealModel) {
      if (MealType.breakfast == item.type) {
        return 'assets/icons/sandwich.svg';
      } else if (MealType.lunch == item.type) {
        return 'assets/icons/chicken.svg';
      } else if (MealType.dinner == item.type) {
        return 'assets/icons/cake.svg';
      } else if (MealType.snack == item.type) {
        return 'assets/icons/fruits.svg';
      }
    } else if (item is InsulinModel) {
      return 'assets/icons/syringe.svg';
    }

    return 'assets/icons/water.svg';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppBarCustom(
          prefix: SvgPicture.asset('assets/icons/calculator.svg'),
          title: const Text('Calculadora'),
          suffix: SvgPicture.asset(width: 20, 'assets/icons/coin.svg'),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Expanded(
                child: Material(
                  elevation: 10,
                  clipBehavior: Clip.hardEdge,
                  borderRadius: BorderRadius.circular(10),
                  child: Ink(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment(0.8, 1),
                        colors: [tertiaryColor, primaryColor],
                      ),
                    ),
                    child: InkWell(
                      onTap: _goToMealForm,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/meal.svg',
                              colorFilter: const ColorFilter.mode(
                                Colors.white,
                                BlendMode.srcIn,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Calcular',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            const Text(
                              'Refeição',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Material(
                elevation: 10,
                color: tertiaryColor,
                clipBehavior: Clip.hardEdge,
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  onTap: _openGlycemiaForm,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/water-plus.svg',
                          colorFilter: const ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Registrar',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        const Text(
                          'Glicemia',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Material(
                elevation: 10,
                color: secondaryColor,
                clipBehavior: Clip.hardEdge,
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  onTap: _openInsulinForm,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/syringe.svg',
                          height: 40,
                          colorFilter: const ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Aplicar',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        const Text(
                          'Insulina',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                blurRadius: 10,
                offset: const Offset(0, 5),
                color: Colors.grey.shade400,
              )
            ],
          ),
          child: CupertinoSlidingSegmentedControl<int>(
            groupValue: _filter,
            thumbColor: primaryColor,
            backgroundColor: Colors.white,
            children: {
              1: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  '24h',
                  style: TextStyle(
                      color: _filter == 1 ? Colors.white : primaryColor),
                ),
              ),
              7: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  '7 dias',
                  style: TextStyle(
                      color: _filter == 7 ? Colors.white : primaryColor),
                ),
              ),
              14: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  '14 dias',
                  style: TextStyle(
                      color: _filter == 14 ? Colors.white : primaryColor),
                ),
              ),
              30: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  '30 dias',
                  style: TextStyle(
                      color: _filter == 30 ? Colors.white : primaryColor),
                ),
              ),
            },
            onValueChanged: _onFilter,
          ),
        ),
        Visibility(
          visible: _chartData.isNotEmpty,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10, left: 20, right: 20),
            child: SizedBox(
              height: 180,
              child: LineChartCustom(lineBarsData: _chartData),
            ),
          ),
        ),
        Expanded(
          child: FutureBuilder(
            future: _loadList,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Nenhum registro encontrado!\n'
                    'Registre sua glicemia ou refeição para adiciona-la aqui.',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                );
              }

              _items = snapshot.data!;
              return ListView.builder(
                itemCount: snapshot.data!.length,
                padding: const EdgeInsets.only(bottom: 60),
                itemBuilder: (context, index) {
                  final item = snapshot.data![index];
                  final prev = index > 0 ? snapshot.data![index - 1] : null;
                  final itemDate = _getDateLabel(item.date);
                  final prevDate =
                      prev != null ? _getDateLabel(prev.date) : null;

                  Color iconColor = primaryColor;

                  if (item is MealModel && item.favorite) {
                    iconColor = secondaryColor;
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Visibility(
                        visible: prevDate != itemDate,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            itemDate,
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                      TimelineItem(
                        isFirst: index == 0,
                        isLast: snapshot.data!.length - 1 == index,
                        title: Text(_getTitle(item),
                            style: const TextStyle(fontSize: 16)),
                        subtitle: Text(
                          _getDescription(item),
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        prefix: Column(
                          children: [
                            SvgPicture.asset(
                              height: 30,
                              _getIcon(item),
                              colorFilter: ColorFilter.mode(
                                iconColor,
                                BlendMode.srcIn,
                              ),
                            ),
                            Text(
                              _getTimeLabel(item.date),
                              style: TextStyle(
                                fontSize: 12,
                                color: iconColor,
                              ),
                            )
                          ],
                        ),
                        onPressed: () => _onEdit(item),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
