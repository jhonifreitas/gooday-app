import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';

import 'package:gooday/src/common/theme.dart';
import 'package:gooday/src/pages/welcome_page.dart';
import 'package:gooday/src/pages/goal/goal_page.dart';
import 'package:gooday/src/widgets/circle_notch.dart';
import 'package:gooday/src/pages/notification_page.dart';
import 'package:gooday/src/pages/profile/profile_page.dart';
import 'package:gooday/src/pages/calculator/calculator_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  int _currentPage = 0;
  final _bottomBarSpace = 20.0;
  final _circleNotchRadius = 25.0;
  final _pageCtrl = PageController();

  final btnCalculateKey = GlobalKey();
  final btnNotificationKey = GlobalKey();

  late final AnimationController _positionCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 300),
  )..addListener(() => setState(() {}));
  late Animation<double> _positionAnimation =
      Tween(begin: 0.0, end: _circleNotchRadius + _bottomBarSpace)
          .animate(_positionCtrl);

  @override
  void initState() {
    super.initState();
    _positionCtrl.forward();
  }

  @override
  void dispose() {
    _positionCtrl.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });

    setPosition();
  }

  void setPosition() {
    final size = MediaQuery.of(context).size;
    RenderBox btnCalculateBox =
        btnCalculateKey.currentContext!.findRenderObject() as RenderBox;
    Offset btnCalculatePosition = btnCalculateBox.localToGlobal(Offset.zero);
    RenderBox btnNotificationBox =
        btnNotificationKey.currentContext!.findRenderObject() as RenderBox;
    Offset btnNotificationPosition =
        btnNotificationBox.localToGlobal(Offset.zero);

    double position = _circleNotchRadius + _bottomBarSpace;

    if (_currentPage == 1) {
      position = btnCalculatePosition.dx + 25;
    } else if (_currentPage == 2) {
      position = size.width / 2;
    } else if (_currentPage == 3) {
      position = btnNotificationPosition.dx + 25;
    } else if (_currentPage == 4) {
      position = size.width - _circleNotchRadius - _bottomBarSpace;
    }

    _positionAnimation = Tween(begin: _positionAnimation.value, end: position)
        .animate(_positionCtrl);

    _positionCtrl.reset();
    _positionCtrl.forward();
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
        children: [
          WelcomePage(goToPage: _goToPage),
          CalculatorPage(goToPage: _goToPage),
          GoalPage(goToPage: _goToPage),
          NotificationPage(goToPage: _goToPage),
          ProfilePage(goToPage: _goToPage)
        ],
      ),
      bottomNavigationBar: CustomPaint(
        painter: CircleNotch(
          bgColor: Colors.white,
          position: _positionAnimation.value,
          circleRadius: _circleNotchRadius,
          circleColor: primaryColor,
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _HomeBottomButton(
                icon: 'assets/icons/home.svg',
                active: _currentPage == 0,
                onPressed: () => _goToPage(0),
              ),
              _HomeBottomButton(
                key: btnCalculateKey,
                icon: 'assets/icons/calculator.svg',
                active: _currentPage == 1,
                onPressed: () => _goToPage(1),
              ),
              _HomeBottomButton(
                icon: 'assets/icons/heart.svg',
                active: _currentPage == 2,
                onPressed: () => _goToPage(2),
              ),
              _HomeBottomButton(
                key: btnNotificationKey,
                icon: 'assets/icons/bell.svg',
                active: _currentPage == 3,
                onPressed: () => _goToPage(3),
              ),
              _HomeBottomButton(
                icon: 'assets/icons/user.svg',
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
  final String icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 50,
      child: IconButton(
        onPressed: onPressed,
        icon: SvgPicture.asset(
          icon,
          height: 25,
          colorFilter: ColorFilter.mode(
            active ? Colors.white : primaryColor,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}
