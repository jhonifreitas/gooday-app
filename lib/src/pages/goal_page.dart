import 'dart:io';
import 'dart:async';

import 'package:intl/intl.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';

import 'package:gooday/src/common/theme.dart';
import 'package:gooday/src/widgets/appbar.dart';
import 'package:gooday/src/models/goal_model.dart';

class GoalPage extends StatefulWidget {
  const GoalPage({super.key});

  @override
  State<GoalPage> createState() => _GoalPageState();
}

class _GoalPageState extends State<GoalPage> with TickerProviderStateMixin {
  DateTime _date = DateTime.now();
  DateTime _lastUpdate = DateTime.now();

  final _data = GoalModel();

  late final AnimationController _loaderCtrl = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 1),
  );
  late final Animation<double> _loaderAnimation = CurvedAnimation(
    parent: _loaderCtrl,
    curve: Curves.easeInOut,
  );

  String get _getDateLabel {
    final week = DateFormat('EEEE', 'pt_BR').format(_date);
    final month = DateFormat('MMMM', 'pt_BR').format(_date);
    return "$week, ${_date.day} de $month".toUpperCase();
  }

  int get _goalTotal {
    return 70;
  }

  String get _getStepLabel {
    return NumberFormat().format(_data.steps);
  }

  String get _getDistanceLabel {
    return NumberFormat().format(_data.distance);
  }

  String get _getCalorieLabel {
    return NumberFormat().format(_data.calories);
  }

  String get _getMinuteLabel {
    return NumberFormat().format(_data.minutes);
  }

  @override
  void dispose() {
    _loaderCtrl.dispose();
    super.dispose();
  }

  void _loadData() async {
    setState(() {
      _loaderCtrl.repeat();
    });

    await Future.delayed(const Duration(seconds: 5));

    setState(() {
      _lastUpdate = DateTime.now();
      _loaderCtrl.stop();
    });
  }

  void _goToPrev() {
    setState(() {
      _date = _date.add(const Duration(days: 1));
    });
  }

  void _goToNext() {
    setState(() {
      _date = _date.subtract(const Duration(days: 1));
    });
  }

  _goToDaily() {}

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
                        onPressed: _goToDaily,
                        child: const Text('Ver mais'),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  _GoalCard(
                    iconAssets: 'assets/icons/target.svg',
                    value: _goalTotal / 100,
                    textValue: '$_goalTotal%',
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
                    value: 1,
                    textValue: _getStepLabel,
                    text: 'passos',
                    suffix: const Text('5000',
                        style: TextStyle(fontSize: 12, color: Colors.grey)),
                    color: Colors.green,
                  ),
                  _GoalCard(
                    iconAssets: 'assets/icons/pin.svg',
                    value: 0.5,
                    textValue: _getDistanceLabel,
                    text: 'Km',
                    suffix: const Text('4',
                        style: TextStyle(fontSize: 12, color: Colors.grey)),
                    color: Colors.yellow,
                  ),
                  _GoalCard(
                    iconAssets: 'assets/icons/fire.svg',
                    value: 0.945,
                    textValue: _getCalorieLabel,
                    text: 'Calorias',
                    suffix: const Text('-1000',
                        style: TextStyle(fontSize: 12, color: Colors.grey)),
                    color: Colors.red,
                  ),
                  _GoalCard(
                    iconAssets: 'assets/icons/clock-race.svg',
                    value: 1,
                    textValue: _getMinuteLabel,
                    text: 'minutos ativos',
                    suffix: const Text('70',
                        style: TextStyle(fontSize: 12, color: Colors.grey)),
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
            loaderAnimation: _loaderAnimation,
            onLoad: _loadData,
            lastUpdate: _lastUpdate,
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
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
              ),
              margin: const EdgeInsets.only(right: 10),
              child: SvgPicture.asset(
                iconAssets,
                colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
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
                      color: color,
                      minHeight: 8,
                      value: value,
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
    required this.lastUpdate,
  });

  final DateTime lastUpdate;
  final VoidCallback onLoad;
  final Animation<double> loaderAnimation;

  String get _lastUpdateLabel {
    final month = DateFormat('MMMM', 'pt_BR').format(lastUpdate);
    final time = DateFormat('H:mm').format(lastUpdate);
    return "${lastUpdate.day} de $month, $time";
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.hardEdge,
      child: ListTile(
        onTap: onLoad,
        leading: Image.asset(
          Platform.isIOS
              ? 'assets/icons/apple-health.png'
              : 'assets/icons/google-fit.png',
          width: 40,
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
