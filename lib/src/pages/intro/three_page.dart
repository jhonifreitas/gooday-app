import 'dart:io';

import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'package:gooday/src/widgets/button.dart';

class IntroThreePage extends StatefulWidget {
  const IntroThreePage({super.key});

  @override
  State<IntroThreePage> createState() => _IntroThreePageState();
}

class _IntroThreePageState extends State<IntroThreePage> {
  final _youtubeCtrl = YoutubePlayerController(initialVideoId: 'S_bnutPbyWc');

  void _openWebsite() async {
    final url = Uri.parse('https://google.com.br');
    launchUrl(url);
  }

  void _openFacebook() {
    final url = Uri.parse('https://facebook.com.br');
    launchUrl(url);
  }

  void _openTwitter() {
    final url = Uri.parse('https://twitter.com.br');
    launchUrl(url);
  }

  void _openInstagram() {
    final url = Uri.parse('https://instagram.com.br');
    launchUrl(url);
  }

  void _goToBack() {
    Navigator.pop(context);
  }

  void _goToHome() {
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
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
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: _goToBack,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(TextSpan(
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
                const SizedBox(height: 10),
                Text(
                  'Conheça os profissionais que garantem a segurança e eficácia do '
                  'Gooday para a sua saúde.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 10),
                Visibility(
                  visible: Platform.isAndroid || Platform.isIOS,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: YoutubePlayer(
                      controller: _youtubeCtrl,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Quer saber mais?',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  'Acompanhe nossas redes sociais!',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 10),
                Wrap(
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
                        colorFilter: const ColorFilter.mode(
                            Colors.white, BlendMode.srcIn),
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
                        colorFilter: const ColorFilter.mode(
                            Colors.white, BlendMode.srcIn),
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
                        colorFilter: const ColorFilter.mode(
                            Colors.white, BlendMode.srcIn),
                      ),
                    ),
                  ],
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
