import 'dart:io';
import 'dart:async';

import 'package:intl/intl.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';

import 'package:gooday/models/goal.dart';
import 'package:gooday/components/appbar.dart';

class GoalScreen extends StatefulWidget {
  const GoalScreen({super.key});

  @override
  State<GoalScreen> createState() => _GoalScreenState();
}

class _GoalScreenState extends State<GoalScreen> {
  bool _loading = false;
  DateTime _date = DateTime.now();
  DateTime _lastUpdate = DateTime.now();

  Goal _data = Goal();

  String get _getDateLabel {
    final week = DateFormat('EEEE', 'pt_BR').format(_date);
    final month = DateFormat('MMMM', 'pt_BR').format(_date);
    return "$week, ${_date.day} de $month".toUpperCase();
  }

  String get _lastUpdateLabel {
    final month = DateFormat('MMMM', 'pt_BR').format(_lastUpdate);
    final time = DateFormat('H:mm').format(_lastUpdate);
    return "${_lastUpdate.day} de $month, $time";
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

  void _loadData() async {
    setState(() {
      _loading = true;
    });

    await Future.delayed(const Duration(seconds: 5));

    setState(() {
      _loading = false;
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
        SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.only(bottom: 130),
            child: Column(
              children: [
                AppBarCustom(
                  prefix: SvgPicture.asset('assets/icons/heart.svg'),
                  title: const Text('Registro de Atividades Físicas'),
                  suffix: SvgPicture.asset('assets/icons/coin.svg', width: 20),
                ),
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(color: Colors.grey.shade300),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: _goToPrev,
                          icon: const Icon(Icons.arrow_left)),
                      Text(_getDateLabel),
                      IconButton(
                          onPressed: _goToNext,
                          icon: const Icon(Icons.arrow_right))
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
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
                      ),
                      _cardGoal(
                        'assets/icons/target.svg',
                        _goalTotal / 100,
                        '$_goalTotal%',
                        'concluído',
                        SvgPicture.asset('assets/icons/gift.svg', width: 24),
                        Theme.of(context).primaryColor,
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text('Visão Geral',
                              style: Theme.of(context).textTheme.titleMedium),
                        ),
                      ),
                      _cardGoal(
                        'assets/icons/shoe.svg',
                        1,
                        _getStepLabel,
                        'passos',
                        const Text('5000',
                            style: TextStyle(fontSize: 12, color: Colors.grey)),
                        Colors.green,
                      ),
                      _cardGoal(
                        'assets/icons/pin.svg',
                        0.5,
                        _getDistanceLabel,
                        'Km',
                        const Text('4',
                            style: TextStyle(fontSize: 12, color: Colors.grey)),
                        Colors.yellow,
                      ),
                      _cardGoal(
                        'assets/icons/fire.svg',
                        0.945,
                        _getCalorieLabel,
                        'Calorias',
                        const Text('-1000',
                            style: TextStyle(fontSize: 12, color: Colors.grey)),
                        Colors.red,
                      ),
                      _cardGoal(
                        'assets/icons/clock-race.svg',
                        1,
                        _getMinuteLabel,
                        'minutos ativos',
                        const Text('70',
                            style: TextStyle(fontSize: 12, color: Colors.grey)),
                        Colors.purple,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(bottom: 80, left: 10, right: 10, child: _card())
      ],
    );
  }

  Widget _cardGoal(String iconAssets, double value, String textValue,
      String text, Widget suffix, Color color) {
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
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Row(
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
                  ),
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

  Widget _card() {
    return Card(
      elevation: 10,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.hardEdge,
      child: ListTile(
        onTap: _loadData,
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
            const Padding(
              padding: EdgeInsets.only(right: 5),
              child: Icon(Icons.sync, size: 20),
            ),
            Text(
              _lastUpdateLabel,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            )
          ],
        ),
        trailing: Wrap(children: [
          Icon(Icons.sync, color: Theme.of(context).primaryColor),
          const Icon(Icons.chevron_right)
        ]),
      ),
    );
  }
}
