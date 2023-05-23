import 'package:flutter/material.dart';

import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'package:flutter_svg/svg.dart';
import 'package:gooday/components/button.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  int _step = 0;

  void _openWebsite() {}

  void _openFacebook() {}

  void _openTwitter() {}

  void _openInstagram() {}

  void _goToHome() {
    Navigator.pushNamed(context, '/');
  }

  void _goToNext() {
    setState(() {
      _step++;
    });
  }

  void _goToBack() {
    setState(() {
      _step--;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget stepBuild = _step1Build();

    if (_step == 1) {
      stepBuild = _step2Build();
    } else if (_step == 2) {
      stepBuild = _step3Build();
    }

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: _step == 0
            ? const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background.png'),
                  fit: BoxFit.cover,
                ),
              )
            : null,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: _headerBuild(),
            ),
            stepBuild,
            if (_step > 0) _footerBuild(),
          ],
        ),
      ),
    );
  }

  Widget _headerBuild() {
    if (_step == 1) {
      return Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: SizedBox(
              height: 25,
              child: FilledButton.tonal(
                style: const ButtonStyle(
                  padding: MaterialStatePropertyAll(
                    EdgeInsets.symmetric(horizontal: 10),
                  ),
                  backgroundColor: MaterialStatePropertyAll(
                    Color.fromRGBO(231, 231, 231, 1),
                  ),
                ),
                onPressed: _goToHome,
                child: const Text('Pular'),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: SvgPicture.asset('assets/images/logo.svg', width: 150),
          ),
        ],
      );
    } else if (_step == 2) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SvgPicture.asset(width: 100, 'assets/images/logo.svg'),
          SizedBox(
            height: 25,
            child: FilledButton.tonal(
              style: const ButtonStyle(
                padding: MaterialStatePropertyAll(
                  EdgeInsets.symmetric(horizontal: 10),
                ),
                backgroundColor: MaterialStatePropertyAll(
                  Color.fromRGBO(231, 231, 231, 1),
                ),
              ),
              onPressed: _goToHome,
              child: const Text('Pular'),
            ),
          ),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: SvgPicture.asset('assets/images/logo-white.svg', width: 120),
    );
  }

  Widget _footerBuild() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FloatingActionButton(
            tooltip: 'Voltar',
            heroTag: 'btn-back',
            elevation: 0,
            hoverElevation: 0,
            backgroundColor: Colors.white,
            shape: StadiumBorder(
              side: BorderSide(
                width: 1,
                color: Theme.of(context).primaryColor,
              ),
            ),
            onPressed: _goToBack,
            child: Icon(
              Icons.arrow_back,
              color: Theme.of(context).primaryColor,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 1; i < 3; i++)
                Icon(
                  i == _step
                      ? Icons.fiber_manual_record
                      : Icons.fiber_manual_record_outlined,
                  size: 12,
                  color: Theme.of(context).primaryColor,
                )
            ],
          ),
          FloatingActionButton(
            tooltip: 'Avançar',
            heroTag: 'btn-next',
            backgroundColor: Theme.of(context).primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            onPressed: _goToNext,
            child: Icon(
              Icons.arrow_forward,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _step1Build() {
    return Container(
      padding: const EdgeInsets.only(left: 40, right: 40, bottom: 40),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(50)),
      ),
      child: Column(
        children: [
          Align(
            heightFactor: 0.3,
            alignment: const Alignment(0, 1.5),
            child: Image.asset('assets/images/betty-intro.png', width: 200),
          ),
          Text(
            'Antes de qualquer coisa, quero lhe apresentar o Gooday.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Vamos começar?',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
          ButtonCustom(
            text: 'Avançar',
            onPressed: _goToNext,
          ),
        ],
      ),
    );
  }

  Widget _step2Build() {
    return Container(
      padding: const EdgeInsets.only(left: 40, right: 40, bottom: 40),
      child: Column(
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
              'gerenciar o diabetes e precisam de orientações que vão além da consulta médica.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Text(
            'Nosso objetivo é fornecer essa assistência, auxiliando você na '
            'sua alimentação, atividades fisícas, monitorização e bem-star.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _step3Build() {
    final youtubeCtrl = YoutubePlayerController(initialVideoId: 'S_bnutPbyWc');

    return Container(
      padding: const EdgeInsets.only(left: 40, right: 40, bottom: 40),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text.rich(TextSpan(
              text: 'De uma forma',
              children: const [
                TextSpan(
                  text: ' fácil e divertida ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: 'iremos ajudar você a gerenciar seu diabetes!')
              ],
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).primaryColor,
              ),
            )),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              'Conheça os profissionais que garantem a segurança e eficácia do '
              'Gooday para a sua saúde.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: YoutubePlayer(
                controller: youtubeCtrl,
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              'Quer saber mais?',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              'Acompanhe nossas redes sociais!',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Align(
              alignment: Alignment.topLeft,
              child: Wrap(
                spacing: 10,
                children: [
                  IconButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll<Color>(
                          Theme.of(context).primaryColor),
                    ),
                    tooltip: 'Website',
                    onPressed: _openWebsite,
                    icon: const Icon(
                      Icons.language,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    tooltip: 'Facebook',
                    onPressed: _openFacebook,
                    style: const ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll<Color>(Color(0xFF3B5998)),
                    ),
                    icon: SvgPicture.asset(
                      'assets/icons/facebook.svg',
                      width: 20,
                      colorFilter:
                          const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Twitter',
                    onPressed: _openTwitter,
                    style: const ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll<Color>(Color(0xFF00ACEE)),
                    ),
                    icon: SvgPicture.asset(
                      'assets/icons/twitter.svg',
                      width: 20,
                      colorFilter:
                          const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Instagram',
                    onPressed: _openInstagram,
                    style: const ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll<Color>(Color(0xFFDD2A7B)),
                    ),
                    icon: SvgPicture.asset(
                      'assets/icons/instagram.svg',
                      width: 20,
                      colorFilter:
                          const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
