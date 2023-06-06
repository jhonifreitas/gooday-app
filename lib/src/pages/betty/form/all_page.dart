import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'package:gooday/src/common/theme.dart';
import 'package:gooday/src/models/user_model.dart';
import 'package:gooday/src/services/util_service.dart';
import 'package:gooday/src/providers/user_provider.dart';
import 'package:gooday/src/pages/betty/form/food_page.dart';
import 'package:gooday/src/pages/betty/form/health_page.dart';
import 'package:gooday/src/controllers/betty_controller.dart';
import 'package:gooday/src/pages/betty/form/fitness_page.dart';
import 'package:gooday/src/pages/betty/form/education_page.dart';

class BettyFormAllPage extends StatefulWidget {
  const BettyFormAllPage({super.key});

  @override
  State<BettyFormAllPage> createState() => _BettyFormAllPageState();
}

class _BettyFormAllPageState extends State<BettyFormAllPage> {
  final _bettyCtrl = BettyController();
  final _pageCtrl = PageController();

  int _currentPage = 0;

  Future<void> _onSubmit() async {
    UtilService(context).loading('Salvando...');

    final userProvider = context.read<UserProvider>();
    final config = userProvider.data!.config!.toJson();

    Map<String, dynamic> data = {
      'lostWeight': _bettyCtrl.lostWeightFoodCtrl,
      'adequateFood': _bettyCtrl.adequateFoodCtrl,
      'foodHelps': _bettyCtrl.foodHelpsCtrl,
      'foodLikes': _bettyCtrl.foodLikesCtrl,
      'foodNoLikes': _bettyCtrl.foodNoLikesCtrl,
      'foodLimits': _bettyCtrl.foodLimitsCtrl,
      'doExercise': _bettyCtrl.doExerciseCtrl,
      'exerciseHelps': _bettyCtrl.exerciseHelpsCtrl,
      'exercises': _bettyCtrl.exercisesCtrl,
      'timeExercise': _bettyCtrl.timeExerciseCtrl,
      'frequencyExercise': _bettyCtrl.frequencyExerciseCtrl,
    };

    config['betty'] = data;
    await userProvider.update({'config': config});

    if (!mounted) return;

    context.pop();
    context.go('/');
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
              BettyFormFoodPage(bettyCtrl: _bettyCtrl),
              BettyFormFitnessPage(bettyCtrl: _bettyCtrl),
              BettyFormHealthPage(bettyCtrl: _bettyCtrl),
              BettyFormEducationPage(bettyCtrl: _bettyCtrl),
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
                            child: SvgPicture.asset(
                              iconAssets,
                              width: 30,
                              colorFilter: const ColorFilter.mode(
                                primaryColor,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                        const WidgetSpan(child: SizedBox(width: 5)),
                        TextSpan(
                          text: title,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Recomendações Diárias'.toUpperCase(),
                    style: const TextStyle(color: primaryColor),
                  )
                ],
              ),
              Image.asset('assets/images/betty-avatar.png', width: 90)
            ],
          ),
          Visibility(
            visible: description != null,
            child: Column(
              children: [
                const SizedBox(height: 10),
                Text(
                  description ?? "",
                  style: const TextStyle(
                    fontSize: 12,
                    color: primaryColor,
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

  List<Widget> dots() {
    final List<Widget> dots = [];

    for (var i = 0; i < 4; i++) {
      if (i > 0) dots.add(const SizedBox(width: 3));
      dots.add(Icon(step == i ? Icons.circle : Icons.circle_outlined,
          color: primaryColor, size: 8));
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
            color: primaryColor,
            style: IconButton.styleFrom(
              padding: const EdgeInsets.all(15),
              shape: CircleBorder(
                side: BorderSide(
                  width: 1,
                  color: onPrev != null ? primaryColor : Colors.grey,
                ),
              ),
            ),
            icon: const Icon(Icons.arrow_back),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: dots(),
            ),
          ),
          IconButton(
            onPressed: onNext,
            color: Colors.white,
            style: IconButton.styleFrom(
              backgroundColor: primaryColor,
              padding: const EdgeInsets.all(15),
            ),
            icon: Icon(step < 3 ? Icons.arrow_forward : Icons.check),
          ),
        ],
      ),
    );
  }
}
