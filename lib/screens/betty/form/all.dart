import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:gooday/screens/betty/form/food.dart';
import 'package:gooday/screens/betty/form/health.dart';
import 'package:gooday/screens/betty/form/fitness.dart';
import 'package:gooday/screens/betty/form/education.dart';

class BettyFormAllScreen extends StatefulWidget {
  const BettyFormAllScreen({super.key});

  @override
  State<BettyFormAllScreen> createState() => _BettyFormAllScreenState();
}

class _BettyFormAllScreenState extends State<BettyFormAllScreen> {
  final _pageCtrl = PageController();
  int _currentPage = 0;

  void _onSubmit() {
    Navigator.pushNamed(context, '/');
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  void _goToBack() {
    _pageCtrl.previousPage(
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  void _goToNext() {
    if (_currentPage == 3) {
      _onSubmit();
    } else {
      _pageCtrl.nextPage(
          duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageCtrl,
            onPageChanged: _onPageChanged,
            children: [
              BettyFormFoodScreen(onSubmit: _onSubmit),
              BettyFormFitnessScreen(onSubmit: _onSubmit),
              BettyFormHealthScreen(onSubmit: _onSubmit),
              BettyFormEducationScreen(onSubmit: _onSubmit),
            ],
          ),
          Positioned(
            left: 30,
            right: 30,
            bottom: 20,
            child: _BettyButtonFooter(
              step: _currentPage,
              onPrev: _currentPage > 0 ? _goToBack : null,
              onNext: _goToNext,
            ),
          ),
        ],
      ),
    );
  }
}

class BettyRecommendDayli extends StatelessWidget {
  const BettyRecommendDayli({
    required this.title,
    required this.iconAssets,
    this.description,
    super.key,
  });

  final String title;
  final String iconAssets;
  final String? description;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 30, left: 40, right: 40),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 3, color: Colors.grey.shade200),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        WidgetSpan(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: SvgPicture.asset(iconAssets, width: 40),
                          ),
                        ),
                        const WidgetSpan(child: SizedBox(width: 5)),
                        TextSpan(
                            text: title,
                            style: Theme.of(context).textTheme.titleLarge),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Recomendações Diárias'.toUpperCase(),
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  )
                ],
              ),
              Image.asset('assets/images/betty-avatar.png', width: 100)
            ],
          ),
          Visibility(
            visible: description != null,
            child: Column(
              children: [
                const SizedBox(height: 10),
                Text(
                  description ?? "",
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BettyButtonFooter extends StatelessWidget {
  const _BettyButtonFooter({
    required this.step,
    required this.onNext,
    this.onPrev,
  });

  final int step;
  final VoidCallback onNext;
  final VoidCallback? onPrev;

  List<Widget> dots(BuildContext context) {
    final List<Widget> dots = [];

    for (var i = 0; i < 4; i++) {
      if (i > 0) dots.add(const SizedBox(width: 3));
      dots.add(Icon(step == i ? Icons.circle : Icons.circle_outlined,
          color: Theme.of(context).primaryColor, size: 8));
    }

    return dots;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [BoxShadow(blurRadius: 10, color: Colors.grey.shade300)],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: onPrev,
            color: Theme.of(context).primaryColor,
            style: IconButton.styleFrom(
              padding: const EdgeInsets.all(15),
              shape: CircleBorder(
                side: BorderSide(
                  width: 1,
                  color: onPrev != null
                      ? Theme.of(context).primaryColor
                      : Colors.grey,
                ),
              ),
            ),
            icon: const Icon(Icons.arrow_back),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: dots(context),
            ),
          ),
          IconButton(
            onPressed: onNext,
            color: Colors.white,
            style: IconButton.styleFrom(
              padding: const EdgeInsets.all(15),
              backgroundColor: Theme.of(context).primaryColor,
            ),
            icon: Icon(step < 3 ? Icons.arrow_forward : Icons.check),
          ),
        ],
      ),
    );
  }
}
