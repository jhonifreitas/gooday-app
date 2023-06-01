import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';

import 'package:gooday/src/common/theme.dart';
import 'package:gooday/src/widgets/appbar.dart';
import 'package:gooday/src/widgets/timeline.dart';
import 'package:gooday/src/pages/calculator/glycemia_page.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  void _openGlycemiaForm() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return const GlycemiaPage();
      },
    );
  }

  void _goToMealForm() {
    Navigator.pushNamed(context, '/refeicao');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppBarCustom(
          prefix: const Icon(Icons.calculate_outlined),
          title: const Text('Calculadora'),
          suffix: SvgPicture.asset(width: 20, 'assets/icons/coin.svg'),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Expanded(
                child: Material(
                  clipBehavior: Clip.hardEdge,
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    onTap: _goToMealForm,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Image.asset('assets/images/betty-intro.png',
                              width: 70),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: const [
                              // SvgPicture.asset('assets/icons/blood.svg'),
                              Text(
                                'Calcular',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                'Refeição',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Material(
                clipBehavior: Clip.hardEdge,
                color: tertiaryColor,
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  onTap: _openGlycemiaForm,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: const [
                        // SvgPicture.asset('assets/icons/meal.svg'),
                        Text(
                          'Registrar',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'Glicemia',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            height: 150,
            decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10)),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(bottom: 10, left: 20, right: 20),
          child: Text('Hoje', style: TextStyle(fontSize: 20)),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.only(bottom: 60),
            children: [
              TimelineItem(
                isFirst: true,
                isLast: true,
                title:
                    const Text('Café da manhã', style: TextStyle(fontSize: 16)),
                subtitle: Text(
                  '25,9 Carbs | 0,2g Gorduras | 0,4g Proteínas | '
                  '110,9kcal Calorias',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade600,
                  ),
                ),
                prefix: Column(
                  children: [
                    Icon(Icons.lunch_dining_outlined,
                        color: Theme.of(context).primaryColor),
                    Text(
                      '8:00',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).primaryColor,
                      ),
                    )
                  ],
                ),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}
