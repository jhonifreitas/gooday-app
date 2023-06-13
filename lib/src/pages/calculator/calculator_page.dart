import 'package:intl/intl.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';

import 'package:gooday/src/common/theme.dart';
import 'package:gooday/src/widgets/appbar.dart';
import 'package:gooday/src/widgets/timeline.dart';
import 'package:gooday/src/models/meal_model.dart';
import 'package:gooday/src/widgets/line_chart.dart';
import 'package:gooday/src/models/glycemia_model.dart';
import 'package:gooday/src/providers/user_provider.dart';
import 'package:gooday/src/services/api/meal_service.dart';
import 'package:gooday/src/services/api/glycemia_service.dart';
import 'package:gooday/src/pages/calculator/glycemia_page.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({required this.goToPage, super.key});

  final ValueChanged<int> goToPage;

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  final _mealApi = MealApiService();
  late Future<List<dynamic>> _loadList;
  final _glycemiaApi = GlycemiaApiService();

  List<LineChartBarData> _chartData = [];

  @override
  void initState() {
    _loadList = _loadData();
    super.initState();
  }

  Future<List<dynamic>> _loadData() async {
    final list = [];
    final user = context.read<UserProvider>().data!;

    final glycemias = await _glycemiaApi.getAll(user.id!);
    final meals = await _mealApi.getAll(user.id!);

    list.addAll(glycemias);
    list.addAll(meals);

    list.sort((a, b) => b.date.compareTo(a.date));

    _loadChart(list);

    return list;
  }

  void _loadChart(List<dynamic> list) {
    List<FlSpot> spots = [];

    for (final item in list) {
      double value = 0.0;
      final double month = (item.date as DateTime).month.toDouble();

      if (item is MealModel) {
        value = item.glycemia.toDouble();
      } else if (item is GlycemiaModel) {
        value = item.value.toDouble();
      }

      final index = spots.indexWhere((spot) => spot.x == month);
      if (index >= 0) {
        final exist = spots[index];
        spots[index] = FlSpot(month, value.toDouble() + exist.y);
      } else {
        spots.add(FlSpot(month, value.toDouble()));
      }
    }

    final chartData = [
      LineChartBarData(
        barWidth: 3,
        spots: spots,
        color: primaryColor,
        dotData: FlDotData(show: false),
      )
    ];

    setState(() {
      _chartData = chartData;
    });
  }

  void _openGlycemiaForm() async {
    final result = await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return const GlycemiaPage();
      },
    );
    if (result != null) _reloadData();
  }

  void _goToMealForm() async {
    final result = await context.push('/refeicao');
    if (result != null) _reloadData();
  }

  void _reloadData() {
    setState(() {
      _loadList = _loadData();
    });
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
    }

    return 'Glicemia';
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

      return '${choTotal}g Carbos | '
          '${caloriesTotal}kcal Calorias | '
          '$sizeTotal(g/ml) Peso';
    }

    return '';
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
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: Image.asset('assets/images/betty-intro.png',
                                width: 70),
                          ),
                          Padding(
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
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Material(
                clipBehavior: Clip.hardEdge,
                color: tertiaryColor,
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
              )
            ],
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 30, top: 30, bottom: 10),
          child: SizedBox(
            height: 150,
            child: LineChartCustom(lineBarsData: _chartData),
          ),
        ),
        Expanded(
          child: FutureBuilder(
            future: _loadList,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Nenhum registro encontrado!\n'
                    'Registre sua glicemia ou refeição para adiciona-la aqui.',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                );
              }

              return ListView.builder(
                itemCount: snapshot.data!.length,
                padding: const EdgeInsets.only(bottom: 60),
                itemBuilder: (context, index) {
                  final item = snapshot.data![index];
                  final prev = index > 0 ? snapshot.data![index - 1] : null;
                  final itemDate = _getDateLabel(item.date);
                  final prevDate =
                      prev != null ? _getDateLabel(prev.date) : null;

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
                              colorFilter: const ColorFilter.mode(
                                primaryColor,
                                BlendMode.srcIn,
                              ),
                            ),
                            Text(
                              _getTimeLabel(item.date),
                              style: const TextStyle(
                                fontSize: 12,
                                color: primaryColor,
                              ),
                            )
                          ],
                        ),
                        onPressed: () {},
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
