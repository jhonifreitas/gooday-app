import 'dart:io';
import 'dart:async';

import 'package:gooday/src/services/util_service.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'package:gooday/src/common/theme.dart';
import 'package:gooday/src/widgets/appbar.dart';
import 'package:gooday/src/models/goal_model.dart';
import 'package:gooday/src/models/goodie_model.dart';
import 'package:gooday/src/services/goal_service.dart';
import 'package:gooday/src/services/health_service.dart';
import 'package:gooday/src/providers/user_provider.dart';
import 'package:gooday/src/services/goodie_service.dart';
import 'package:gooday/src/pages/goodie/congratulation_page.dart';

class GoalPage extends StatefulWidget {
  const GoalPage({super.key});

  @override
  State<GoalPage> createState() => _GoalPageState();
}

class _GoalPageState extends State<GoalPage> with TickerProviderStateMixin {
  final _goalService = GoalService();
  final _healthService = HealthService();
  final _goodieService = GoodieService();
  late final _userProvider = context.watch<UserProvider>();

  GoalModel? _data;
  bool _goalDone = false;
  DateTime _date = DateTime.now();

  late final AnimationController _loaderCtrl = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 1),
  );
  late final Animation<double> _loaderAnimation = CurvedAnimation(
    parent: _loaderCtrl,
    curve: Curves.easeInOut,
  );

  String get _getDateLabel {
    final week = DateFormat('EEEE').format(_date);
    final month = DateFormat('MMMM').format(_date);
    return "$week, ${_date.day} de $month".toUpperCase();
  }

  String get _getStepLabel {
    return NumberFormat().format(_data?.steps ?? 0);
  }

  String get _getDistanceLabel {
    return NumberFormat().format(_data?.distance ?? 0);
  }

  String get _getCalorieLabel {
    return NumberFormat().format(_data?.calories ?? 0);
  }

  String get _getMinuteLabel {
    return NumberFormat().format(_data?.exerciseTime ?? 0);
  }

  String get _getTotalLabel {
    final value = NumberFormat().format(_getTotalPercent * 100);
    return '$value%';
  }

  double get _getTotalPercent {
    final total = _getStepPercent +
        _getDistancePercent +
        _getCaloriePercent +
        _getMinutePercent;
    final result = total / 4;
    return result;
  }

  double get _getStepPercent {
    final total = _userProvider.data!.config!.goal!.steps;
    if (_data?.steps != null && total != null && total > 0) {
      if (_data!.steps >= total) return 1;
      return _data!.steps / total;
    }
    return 0;
  }

  double get _getDistancePercent {
    final total = _userProvider.data!.config!.goal!.distance;
    if (_data?.distance != null && total != null && total > 0) {
      if (_data!.distance >= total) return 1;
      return _data!.distance / total;
    }
    return 0;
  }

  double get _getCaloriePercent {
    final total = _userProvider.data!.config!.goal!.calories;
    if (_data?.calories != null && total != null && total > 0) {
      if (_data!.calories >= total) return 1;
      return _data!.calories / total;
    }
    return 0;
  }

  double get _getMinutePercent {
    final total = _userProvider.data!.config!.goal!.exerciseTime;
    if (_data?.exerciseTime != null && total != null && total > 0) {
      if (_data!.exerciseTime >= total) return 1;
      return _data!.exerciseTime / total;
    }
    return 0;
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _loaderCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final data = await _goalService.getByDate(_date);
    if (!mounted) return;
    setState(() {
      _data = data;
    });

    final goodies = await _goodieService.getByDate(_date);
    final goalDone =
        goodies.any((goodie) => goodie.type == GoodieType.goalDone);

    if (!mounted) return;
    setState(() {
      _goalDone = goalDone;
    });
  }

  Future<void> _fetchHealth() async {
    setState(() {
      _loaderCtrl.repeat();
    });

    try {
      // HEALTH
      final healthData = await _healthService.fetchData(_date);

      setState(() {
        if (_data == null) {
          _data = GoalModel(
            steps: healthData['steps']!,
            calories: healthData['calories']!,
            distance: healthData['distance']!,
            exerciseTime: healthData['exerciseTime']!,
          );
        } else {
          _data!.steps = healthData['steps']!;
          _data!.calories = healthData['calories']!;
          _data!.distance = healthData['distance']!;
          _data!.exerciseTime = healthData['exerciseTime']!;
        }
      });

      // UPDATE GOAL
      final goal = await _goalService.save(_data!);
      setState(() {
        _data = goal;
      });

      // ADD GOODIE
      if (_getStepPercent == 1 && !_goalDone) {
        _addGoodie();
      }
    } catch (e) {
      UtilService(context)
          .message('Não foi possível sincronizar.\nTente novamente!');
      debugPrint('HEALTH: ${e.toString()}');
    }

    setState(() {
      _loaderCtrl.stop();
    });
  }

  Future<void> _addGoodie() async {
    const goodies = 50;
    final goal = _userProvider.data?.config?.goal?.steps;
    final data = GoodieModel(value: goodies, goal: goal);
    await _goodieService.add(data);

    setState(() {
      _goalDone = true;
    });

    if (!mounted) return;

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: GoodieCongratulationPage(value: data.value),
        );
      },
    );
  }

  void _goToPrev() {
    setState(() {
      _date = _date.add(const Duration(days: 1));
    });
    _loadData();
  }

  void _goToNext() {
    setState(() {
      _date = _date.subtract(const Duration(days: 1));
    });
    _loadData();
  }

  void _goToConfig() {
    context.push('/config/metas');
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            AppBarCustom(
              prefix: SvgPicture.asset('assets/icons/heart.svg'),
              title: const Text('Registro de Atividades Físicas'),
              suffix: SvgPicture.asset('assets/icons/coin.svg', width: 20),
            ),
            Container(
              decoration: BoxDecoration(color: Colors.grey.shade300),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: _goToPrev, icon: const Icon(Icons.arrow_left)),
                  Text(_getDateLabel),
                  IconButton(
                      onPressed: _goToNext, icon: const Icon(Icons.arrow_right))
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(
                    top: 20, bottom: 150, left: 20, right: 20),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Objetivo Diário',
                          style: Theme.of(context).textTheme.titleMedium),
                      TextButton(
                        onPressed: _goToConfig,
                        child: const Text('Configurar'),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  _GoalCard(
                    iconAssets: 'assets/icons/target.svg',
                    value: _getTotalPercent,
                    textValue: _getTotalLabel,
                    text: 'concluído',
                    suffix:
                        SvgPicture.asset('assets/icons/gift.svg', width: 24),
                    color: primaryColor,
                  ),
                  Text('Visão Geral',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 10),
                  _GoalCard(
                    iconAssets: 'assets/icons/shoe.svg',
                    value: _getStepPercent,
                    textValue: _getStepLabel,
                    text: 'passos',
                    suffix: Text(
                      _userProvider.data?.config?.goal?.steps.toString() ?? '0',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    color: Colors.green,
                  ),
                  _GoalCard(
                    iconAssets: 'assets/icons/pin.svg',
                    value: _getDistancePercent,
                    textValue: _getDistanceLabel,
                    text: 'Km',
                    suffix: Text(
                      _userProvider.data?.config?.goal?.distance.toString() ??
                          '0',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    color: Colors.yellow,
                  ),
                  _GoalCard(
                    iconAssets: 'assets/icons/fire.svg',
                    value: _getCaloriePercent,
                    textValue: _getCalorieLabel,
                    text: 'Calorias',
                    suffix: Text(
                      '${_userProvider.data?.config?.goal?.calories ?? '0'}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    color: Colors.red,
                  ),
                  _GoalCard(
                    iconAssets: 'assets/icons/clock-race.svg',
                    value: _getMinutePercent,
                    textValue: _getMinuteLabel,
                    text: 'minutos ativos',
                    suffix: Text(
                      _userProvider.data?.config?.goal?.exerciseTime
                              .toString() ??
                          '0',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    color: Colors.purple,
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          bottom: 80,
          left: 10,
          right: 10,
          child: _GoalCardUpdate(
            onLoad: _fetchHealth,
            loaderAnimation: _loaderAnimation,
            lastUpdate: _data?.updatedAt ?? _data?.createdAt,
          ),
        )
      ],
    );
  }
}

class _GoalCard extends StatelessWidget {
  const _GoalCard({
    required this.iconAssets,
    required this.value,
    required this.textValue,
    required this.text,
    required this.suffix,
    required this.color,
  });

  final String iconAssets;
  final double value;
  final String textValue;
  final String text;
  final Widget suffix;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.grey.shade200,
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
              ),
              margin: const EdgeInsets.only(right: 10),
              child: SvgPicture.asset(
                iconAssets,
                colorFilter: ColorFilter.mode(
                  value == 1 ? Colors.green : color,
                  BlendMode.srcIn,
                ),
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text.rich(TextSpan(
                        children: [
                          TextSpan(
                            text: '$textValue ',
                            style: const TextStyle(fontSize: 20),
                          ),
                          TextSpan(text: text)
                        ],
                      )),
                      suffix
                    ],
                  ),
                  const SizedBox(height: 2),
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: LinearProgressIndicator(
                      minHeight: 8,
                      value: value,
                      color: value == 1 ? Colors.green : color,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _GoalCardUpdate extends StatelessWidget {
  const _GoalCardUpdate({
    required this.loaderAnimation,
    required this.onLoad,
    this.lastUpdate,
  });

  final DateTime? lastUpdate;
  final VoidCallback onLoad;
  final Animation<double> loaderAnimation;

  String get _lastUpdateLabel {
    if (lastUpdate != null) {
      final month = DateFormat('MMMM').format(lastUpdate!);
      final time = DateFormat('H:mm').format(lastUpdate!);
      return "${lastUpdate!.day} de $month, $time";
    }
    return 'Clique para sincronizar!';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.hardEdge,
      child: ListTile(
        onTap: onLoad,
        leading: Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: Platform.isIOS
                ? [BoxShadow(color: Colors.grey.shade400, blurRadius: 5)]
                : null,
          ),
          child: Image.asset(
            Platform.isIOS
                ? 'assets/icons/apple-health.png'
                : 'assets/icons/google-fit.png',
            width: 40,
          ),
        ),
        title: Text(
          Platform.isIOS ? 'App Saúde' : 'Google Fit',
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
        subtitle: Row(
          children: [
            const Icon(Icons.sync, size: 20),
            const SizedBox(width: 5),
            Text(
              _lastUpdateLabel,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            )
          ],
        ),
        trailing: Wrap(children: [
          RotationTransition(
            turns: loaderAnimation,
            child: const Icon(Icons.sync, color: primaryColor),
          ),
          const Icon(Icons.chevron_right)
        ]),
      ),
    );
  }
}
