import 'dart:async';

import 'package:intl/intl.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:gooday/src/widgets/appbar.dart';
import 'package:gooday/src/providers/user_provider.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final double _temperature = 10;
  DateTime _now = DateTime.now();

  Timer? _timer;

  String get _timeLabel {
    return DateFormat('H:mm').format(_now);
  }

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20, top: 10),
            child: AppBarCustom(
              titleCenter: false,
              brightness: Brightness.dark,
              title: Image.asset(width: 80, 'assets/images/logo-white.png'),
              suffix: Text(
                '$_temperature ºC | $_timeLabel',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20, left: 35, right: 35),
            child: Text.rich(
              TextSpan(
                text: 'Bom dia, ',
                children: [
                  TextSpan(
                    text:
                        '${context.watch<UserProvider>().data?.name?.split(' ')[0]}!',
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
          _WelcomeNotificationList(),
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Image.asset('assets/images/betty.png'),
            ),
          )
        ],
      ),
    );
  }
}

class _WelcomeNotificationList extends StatelessWidget {
  void _openNotification() {}

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 30),
        children: [
          SizedBox(
            width: 270,
            child: Card(
              elevation: 5,
              clipBehavior: Clip.hardEdge,
              margin: const EdgeInsets.all(8),
              color: const Color(0xFF056799),
              child: InkWell(
                onTap: _openNotification,
                splashColor: Colors.white.withAlpha(10),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  child: Column(
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
                            'Acabei de montar seu café da manhã!',
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
                                SvgPicture.asset(
                                  width: 20,
                                  'assets/icons/bell.svg',
                                  colorFilter: const ColorFilter.mode(
                                      Colors.white, BlendMode.srcIn),
                                ),
                                const SizedBox(width: 5),
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
