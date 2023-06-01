import 'package:flutter/material.dart';

import 'package:gooday/src/pages/goal_page.dart';
import 'package:gooday/src/pages/welcome_page.dart';
import 'package:gooday/src/widgets/circle_notch.dart';
import 'package:gooday/src/pages/notification_page.dart';
import 'package:gooday/src/pages/profile/profile_page.dart';
import 'package:gooday/src/pages/calculator/calculator_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentPage = 0;
  late Offset _positionPage;
  double circleNotchRadius = 30;
  final _pageCtrl = PageController();

  final btnCalculateKey = GlobalKey();
  final btnNotificationKey = GlobalKey();

  @override
  void initState() {
    _positionPage = Offset(circleNotchRadius + 15, 0);
    super.initState();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });

    setPosition();
  }

  void setPosition() {
    double space = 15;
    final size = MediaQuery.of(context).size;
    RenderBox btnCalculateBox =
        btnCalculateKey.currentContext!.findRenderObject() as RenderBox;
    Offset btnCalculatePosition = btnCalculateBox.localToGlobal(Offset.zero);
    RenderBox btnNotificationBox =
        btnNotificationKey.currentContext!.findRenderObject() as RenderBox;
    Offset btnNotificationPosition =
        btnNotificationBox.localToGlobal(Offset.zero);

    setState(() {
      if (_currentPage == 0) {
        _positionPage = Offset(circleNotchRadius + space, 0);
      } else if (_currentPage == 1) {
        _positionPage = Offset(btnCalculatePosition.dx + 25, 0);
      } else if (_currentPage == 2) {
        _positionPage = Offset(size.width / 2, 0);
      } else if (_currentPage == 3) {
        _positionPage = Offset(btnNotificationPosition.dx + 25, 0);
      } else if (_currentPage == 4) {
        _positionPage = Offset(size.width - circleNotchRadius - space, 0);
      }
    });
  }

  void _goToPage(int index) {
    _pageCtrl.animateToPage(
      index,
      curve: Curves.easeInOut,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: PageView(
        controller: _pageCtrl,
        onPageChanged: _onPageChanged,
        children: const [
          WelcomePage(),
          CalculatorPage(),
          GoalPage(),
          NotificationPage(),
          ProfilePage()
        ],
      ),
      bottomNavigationBar: CustomPaint(
        painter: CircleNotch(
          bgColor: Colors.white,
          position: _positionPage,
          radius: circleNotchRadius,
          circleColor: Theme.of(context).primaryColor,
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _HomeBottomButton(
                icon: Icons.home_outlined,
                active: _currentPage == 0,
                onPressed: () => _goToPage(0),
              ),
              _HomeBottomButton(
                key: btnCalculateKey,
                icon: Icons.calculate_outlined,
                active: _currentPage == 1,
                onPressed: () => _goToPage(1),
              ),
              _HomeBottomButton(
                icon: Icons.favorite_border_outlined,
                active: _currentPage == 2,
                onPressed: () => _goToPage(2),
              ),
              _HomeBottomButton(
                key: btnNotificationKey,
                icon: Icons.notifications_outlined,
                active: _currentPage == 3,
                onPressed: () => _goToPage(3),
              ),
              _HomeBottomButton(
                icon: Icons.person_outlined,
                active: _currentPage == 4,
                onPressed: () => _goToPage(4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeBottomButton extends StatelessWidget {
  const _HomeBottomButton({
    required this.icon,
    required this.onPressed,
    this.active = false,
    super.key,
  });

  final bool active;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 50,
      child: AnimatedAlign(
        duration: const Duration(milliseconds: 300),
        alignment: active ? const Alignment(0, -5) : Alignment.center,
        child: IconButton(
          onPressed: onPressed,
          icon: Icon(
            icon,
            color: active ? Colors.white : Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }
}
