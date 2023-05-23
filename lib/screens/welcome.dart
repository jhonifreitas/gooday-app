import 'dart:async';

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
  int _temperature = 10;
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

  void _openNotification() {}

  String get _timeLabel {
    String minute = _now.minute.toString();
    if (_now.minute < 10) minute = '0$minute';
    return '${_now.hour}:$minute';
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
          Padding(
            padding:
                const EdgeInsets.only(bottom: 22, top: 10, left: 15, right: 20),
            child: AppBar(
              centerTitle: false,
              backgroundColor: Colors.transparent,
              title:
                  SvgPicture.asset(width: 80, 'assets/images/logo-white.svg'),
              actions: [
                Text(
                  '$_temperature ºC | $_timeLabel',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
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
          _notificationBuild(),
          Expanded(
            child: Image.asset('assets/images/betty.png'),
          )
        ],
      ),
    );
  }

  Widget _notificationBuild() {
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
                            'Refeições',
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            '03:00',
                            style: TextStyle(color: Colors.white),
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
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
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
                              children: const [
                                Padding(
                                  padding: EdgeInsets.only(right: 10),
                                  child: Icon(
                                    Icons.fastfood,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'Meu progresso',
                                  style: TextStyle(color: Colors.white),
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
