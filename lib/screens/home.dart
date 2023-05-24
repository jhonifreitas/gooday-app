import 'package:flutter/material.dart';

import 'package:gooday/screens/goal.dart';
import 'package:gooday/screens/profile.dart';
import 'package:gooday/screens/welcome.dart';
import 'package:gooday/screens/calculator.dart';
import 'package:gooday/screens/notification.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentScreen = 0;
  final List<Widget> _screens = const [
    WelcomeScreen(),
    CalculatorScreen(),
    GoalScreen(),
    NotificationScreen(),
    ProfileScreen()
  ];

  void _changePage(int index) {
    setState(() {
      _currentScreen = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        _screens[_currentScreen],
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            decoration: BoxDecoration(
              boxShadow: _currentScreen > 0
                  ? [BoxShadow(blurRadius: 10, color: Colors.grey.shade300)]
                  : null,
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: BottomNavigationBar(
                onTap: _changePage,
                currentIndex: _currentScreen,
                elevation: 0,
                showSelectedLabels: false,
                selectedItemColor: const Color(0xFFF7C006),
                unselectedItemColor: Theme.of(context).primaryColor,
                items: const [
                  BottomNavigationBarItem(
                      label: 'Ínicio',
                      icon: Icon(Icons.home_outlined),
                      tooltip: 'Ínicio'),
                  BottomNavigationBarItem(
                      label: 'Calculadora',
                      icon: Icon(Icons.calculate_outlined),
                      tooltip: 'Calculadora'),
                  BottomNavigationBarItem(
                      label: 'Metas',
                      icon: Icon(Icons.favorite_border_outlined),
                      tooltip: 'Metas'),
                  BottomNavigationBarItem(
                      label: 'Alertas',
                      icon: Icon(Icons.notifications_outlined),
                      tooltip: 'Alertas'),
                  BottomNavigationBarItem(
                      label: 'Perfil',
                      icon: Icon(Icons.person_outline),
                      tooltip: 'Perfil'),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
