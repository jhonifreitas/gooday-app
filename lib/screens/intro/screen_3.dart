import 'package:flutter/material.dart';
import 'package:gooday/components/button.dart';

import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'package:flutter_svg/svg.dart';

class IntroScreen3 extends StatefulWidget {
  const IntroScreen3({super.key});

  @override
  State<IntroScreen3> createState() => _IntroScreen3State();
}

class _IntroScreen3State extends State<IntroScreen3> {
  final _youtubeCtrl = YoutubePlayerController(initialVideoId: 'S_bnutPbyWc');

  void _openWebsite() {}

  void _openFacebook() {}

  void _openTwitter() {}

  void _openInstagram() {}

  void _goToBack() {
    Navigator.pop(context);
  }

  void _goToHome() {
    Navigator.pushNamed(context, '/');
  }

  void _goToBetty() {
    Navigator.pushNamed(context, '/betty');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(bottom: 20),
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _goToBack,
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text.rich(TextSpan(
                    text: 'De uma forma',
                    children: const [
                      TextSpan(
                        text: ' fácil ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                          text: 'iremos ajudar você a gerenciar seu diabetes!')
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
                    // child: YoutubePlayer(
                    //   controller: _youtubeCtrl,
                    // ),
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
                            backgroundColor: MaterialStatePropertyAll<Color>(
                                Color(0xFF3B5998)),
                          ),
                          icon: SvgPicture.asset(
                            'assets/icons/facebook.svg',
                            width: 20,
                            colorFilter: const ColorFilter.mode(
                                Colors.white, BlendMode.srcIn),
                          ),
                        ),
                        IconButton(
                          tooltip: 'Twitter',
                          onPressed: _openTwitter,
                          style: const ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll<Color>(
                                Color(0xFF00ACEE)),
                          ),
                          icon: SvgPicture.asset(
                            'assets/icons/twitter.svg',
                            width: 20,
                            colorFilter: const ColorFilter.mode(
                                Colors.white, BlendMode.srcIn),
                          ),
                        ),
                        IconButton(
                          tooltip: 'Instagram',
                          onPressed: _openInstagram,
                          style: const ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll<Color>(
                                Color(0xFFDD2A7B)),
                          ),
                          icon: SvgPicture.asset(
                            'assets/icons/instagram.svg',
                            width: 20,
                            colorFilter: const ColorFilter.mode(
                                Colors.white, BlendMode.srcIn),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            Column(
              children: [
                ButtonCustom(
                  text: 'Configurar Assistente Virtual',
                  onPressed: _goToBetty,
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: _goToHome,
                  child: const Text('Configurar depois'),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
