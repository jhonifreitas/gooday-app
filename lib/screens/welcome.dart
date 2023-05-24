import 'dart:async';

import 'package:intl/intl.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';

import 'package:gooday/models/user.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  User? _user;
  double _temperature = 10;
  DateTime _now = DateTime.now();

  Timer? _timer;

  @override
  void initState() {
    _timer = Timer(const Duration(minutes: 1), () {
      setState(() {
        _now = DateTime.now();
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('assets/images/background.png'),
        ),
      ),
      child: Column(
        children: [
          _WelcomeAppBar(temperature: _temperature, time: _now),
          Padding(
            padding: const EdgeInsets.only(bottom: 20, left: 30, right: 30),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text.rich(
                TextSpan(
                  text: 'Bom dia, ',
                  children: [
                    TextSpan(
                      text: '${_user?.name}!',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          _WelcomeNotificationList(),
          Expanded(
            child: Image.asset('assets/images/betty.png'),
          )
        ],
      ),
    );
  }
}

class _WelcomeAppBar extends StatelessWidget {
  const _WelcomeAppBar({required this.temperature, required this.time});

  final DateTime time;
  final double temperature;

  String get _timeLabel {
    return DateFormat('H:mm').format(time);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22, top: 10, left: 15, right: 20),
      child: AppBar(
        centerTitle: false,
        backgroundColor: Colors.transparent,
        title: SvgPicture.asset(width: 80, 'assets/images/logo-white.svg'),
        actions: [
          Text(
            '$temperature ºC | $_timeLabel',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _WelcomeNotificationList extends StatelessWidget {
  void _openNotification() {}

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170,
      padding: const EdgeInsets.only(bottom: 20),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 22),
        children: [
          SizedBox(
            width: 270,
            child: Card(
              elevation: 5,
              clipBehavior: Clip.hardEdge,
              margin: const EdgeInsets.all(8),
              color: const Color(0xFF05699C),
              child: InkWell(
                onTap: _openNotification,
                splashColor: Colors.blue.withAlpha(30),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            'Medicamento',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          Text(
                            '03:00',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          )
                        ],
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          child: const Text(
                            'Acabei de montarl seu café da manhã!',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 5),
                                  child: SvgPicture.asset(
                                    width: 25,
                                    'assets/icons/bell.svg',
                                    colorFilter: const ColorFilter.mode(
                                        Colors.white, BlendMode.srcIn),
                                  ),
                                ),
                                const Text(
                                  'Lembretes',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                )
                              ],
                            ),
                            const Icon(
                              Icons.chevron_right,
                              color: Colors.white,
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
        ],
      ),
    );
  }
}
