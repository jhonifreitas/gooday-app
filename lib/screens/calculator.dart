import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';

import 'package:gooday/components/appbar.dart';

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
    return Scaffold(
      body: Column(
        children: [
          AppBarCustom(
            prefix: const Icon(Icons.calculate_outlined),
            title: const Text('Calculadora'),
            suffix: SvgPicture.asset(width: 20, 'assets/icons/coin.svg'),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20),
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
                    ),
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
                const Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text('Hoje', style: TextStyle(fontSize: 20)),
                  ),
                ),
                Timeline(
                  steps: const [
                    Step(
                      title: Text('Café da manhã'),
                      content: Text('Ola'),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
