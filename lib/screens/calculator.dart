import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';

import 'package:gooday/components/appbar.dart';
import 'package:gooday/components/timeline.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  void _openGlycemiaForm() {}

  void _goToMealForm() {
    Navigator.pushNamed(context, '/calculadora/refeicao');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                    onTap: _openGlycemiaForm,
                    child: Padding(
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
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Material(
                clipBehavior: Clip.hardEdge,
                color: const Color(0xFF41BBD9),
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
        Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.only(bottom: 10, left: 20, right: 20),
          child: const Text('Hoje', style: TextStyle(fontSize: 20)),
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
