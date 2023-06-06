import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:provider/provider.dart';
import 'package:gooday/src/common/theme.dart';
import 'package:gooday/src/widgets/appbar.dart';
import 'package:gooday/src/providers/user_provider.dart';

class BettyConfigPage extends StatefulWidget {
  const BettyConfigPage({super.key});

  @override
  State<BettyConfigPage> createState() => _BettyConfigPageState();
}

class _BettyConfigPageState extends State<BettyConfigPage> {
  bool _hint = false;

  @override
  void initState() {
    final bettyConfig = context.read<UserProvider>().data?.config?.betty;
    final hasConfig = bettyConfig != null &&
        (bettyConfig.lostWeight != null ||
            bettyConfig.adequateFood != null ||
            bettyConfig.foodHelps.isNotEmpty ||
            bettyConfig.foodLikes.isNotEmpty ||
            bettyConfig.foodNoLikes.isNotEmpty ||
            bettyConfig.foodLimits.isNotEmpty ||
            bettyConfig.doExercise != null ||
            bettyConfig.exerciseHelps.isNotEmpty ||
            bettyConfig.exercises.isNotEmpty ||
            bettyConfig.timeExercise.isNotEmpty ||
            bettyConfig.frequencyExercise != null);

    if (hasConfig) _onHint(true);

    super.initState();
  }

  void _onHint(bool value) {
    setState(() {
      _hint = value;
    });
  }

  void _goToFood() {
    context.push('/config/betty/alimentacao');
  }

  void _goToFitness() {
    context.push('/config/betty/exercicio');
  }

  void _goToHealth() {
    context.push('/config/betty/saude');
  }

  void _goToEducation() {
    context.push('/config/betty/educacao');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const AppBarCustom(title: Text('Configurar Assistente Virtual')),
          SwitchListTile(
            activeTrackColor: Colors.green,
            contentPadding: const EdgeInsets.symmetric(horizontal: 40),
            title: const Text(
              'Sugestões\nDiárias',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
            ),
            value: _hint,
            onChanged: _onHint,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: [
                const SizedBox(height: 10),
                const Text(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed '
                  'do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                  style: TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 10),
                const Divider(thickness: 2),
                const SizedBox(height: 10),
                AnimatedOpacity(
                  opacity: _hint ? 1 : .3,
                  duration: const Duration(milliseconds: 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Recomendações',
                          style: TextStyle(fontSize: 18)),
                      const SizedBox(height: 10),
                      Card(
                        elevation: 0,
                        clipBehavior: Clip.hardEdge,
                        color: Colors.grey.shade200,
                        child: ListTile(
                          onTap: _hint ? _goToFood : null,
                          leading: SvgPicture.asset(
                            width: 40,
                            'assets/icons/fruits.svg',
                          ),
                          title: const Text(
                            'Refeições',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          subtitle: const Text(
                            '0% Completo',
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          trailing: const Icon(Icons.chevron_right,
                              color: primaryColor),
                        ),
                      ),
                      Card(
                        elevation: 0,
                        clipBehavior: Clip.hardEdge,
                        color: Colors.grey.shade200,
                        child: ListTile(
                          onTap: _hint ? _goToFitness : null,
                          leading: SvgPicture.asset(
                            width: 40,
                            'assets/icons/fitness.svg',
                          ),
                          title: const Text(
                            'Atividades Físicas',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          subtitle: const Text(
                            '0% Completo',
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          trailing: const Icon(Icons.chevron_right,
                              color: primaryColor),
                        ),
                      ),
                      Card(
                        elevation: 0,
                        clipBehavior: Clip.hardEdge,
                        color: Colors.grey.shade200,
                        child: ListTile(
                          onTap: _hint ? _goToHealth : null,
                          leading: SvgPicture.asset(
                            width: 40,
                            'assets/icons/meditation.svg',
                          ),
                          title: const Text(
                            'Bem-Estar',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          subtitle: const Text(
                            '0% Completo',
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          trailing: const Icon(Icons.chevron_right,
                              color: primaryColor),
                        ),
                      ),
                      Card(
                        elevation: 0,
                        clipBehavior: Clip.hardEdge,
                        color: Colors.grey.shade200,
                        child: ListTile(
                          onTap: _hint ? _goToEducation : null,
                          leading: SvgPicture.asset(
                            width: 40,
                            'assets/icons/book.svg',
                          ),
                          title: const Text(
                            'Educação',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          subtitle: const Text(
                            '0% Completo',
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          trailing: const Icon(Icons.chevron_right,
                              color: primaryColor),
                        ),
                      )
                    ],
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
