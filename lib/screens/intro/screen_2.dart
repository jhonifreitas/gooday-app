import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';

class IntroScreen2 extends StatefulWidget {
  const IntroScreen2({super.key});

  @override
  State<IntroScreen2> createState() => _IntroScreen2State();
}

class _IntroScreen2State extends State<IntroScreen2> {
  void _goToNext() {
    Navigator.pushNamed(context, '/introducao/3');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset('assets/images/logo.svg'),
            const SizedBox(height: 20),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    'Somos profissionais com mais de 25 anos de experiência e renome '
                    'no cuidado do diabetes.',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    'Percebemos que pessoas com diabetes têm dificuldades em '
                    'gerenciar o diabetes e precisam de orientações que vão além da '
                    'consulta médica.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                Text(
                  'Nosso objetivo é fornecer essa assistência, auxiliando você na '
                  'sua alimentação, atividades fisícas, monitorização e bem-star.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToNext,
        backgroundColor: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        child: const Icon(Icons.arrow_forward, color: Colors.white),
      ),
    );
  }
}
