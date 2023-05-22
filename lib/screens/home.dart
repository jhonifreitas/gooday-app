import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:gooday/models/user.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  User? _user;
  int _temperature = 10;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    Timer(const Duration(seconds: 1), () {
      setState(() {
        _now = DateTime.now();
      });
    });
    super.initState();
  }

  void _openNotification() {}

  void _goToPage(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  String get _timeLabel {
    String minute = _now.minute.toString();
    if (_now.minute < 10) minute = '0$minute';
    return '${_now.hour}:$minute';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  bottom: 22, top: 30, left: 30, right: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SvgPicture.asset(width: 80, 'assets/images/logo-white.svg'),
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
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _goToPage,
        currentIndex: _selectedIndex,
        showSelectedLabels: false,
        selectedItemColor: const Color(0xFFF7C006),
        unselectedItemColor: Theme.of(context).primaryColor,
        items: const [
          BottomNavigationBarItem(
              label: 'Ínicio', icon: Icon(Icons.home), tooltip: 'Ínicio'),
          BottomNavigationBarItem(
              label: 'Calculadora',
              icon: Icon(Icons.calculate),
              tooltip: 'Calculadora'),
          BottomNavigationBarItem(
              label: 'Metas', icon: Icon(Icons.ads_click), tooltip: 'Metas'),
          BottomNavigationBarItem(
              label: 'Notificações',
              icon: Icon(Icons.notifications),
              tooltip: 'Notificações'),
          BottomNavigationBarItem(
              label: 'Perfil', icon: Icon(Icons.face), tooltip: 'Perfil'),
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
