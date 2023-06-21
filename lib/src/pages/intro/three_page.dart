import 'dart:io';

import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'package:gooday/src/common/theme.dart';
import 'package:gooday/src/widgets/button.dart';
import 'package:gooday/src/widgets/appbar.dart';

class IntroThreePage extends StatefulWidget {
  const IntroThreePage({this.hideConfigBetty = false, super.key});

  final bool hideConfigBetty;

  @override
  State<IntroThreePage> createState() => _IntroThreePageState();
}

class _IntroThreePageState extends State<IntroThreePage> {
  final _youtubeCtrl = YoutubePlayerController(initialVideoId: 'S_bnutPbyWc');

  void _openWebsite() async {
    final url = Uri.parse('https://gooday.care');
    launchUrl(url);
  }

  void _openFacebook() {
    final url = Uri.parse('https://www.facebook.com/gooday.care');
    launchUrl(url);
  }

  void _openTwitter() {
    final url = Uri.parse('https://twitter.com.br');
    launchUrl(url);
  }

  void _openInstagram() {
    final url = Uri.parse('https://www.instagram.com/gooday.care');
    launchUrl(url);
  }

  void _goToHome() {
    context.go('/');
  }

  void _goToBetty() {
    context.push('/config/betty/introducao');
  }

  @override
  Widget build(BuildContext context) {
    Widget actionBtn = Column(
      children: [
        ButtonCustom(
          text: 'Configurar Assistente Virtual',
          onPressed: _goToBetty,
        ),
        const SizedBox(height: 10),
        TextButton(
          onPressed: _goToHome,
          child: const Text('Configurar depois'),
        ),
      ],
    );

    if (widget.hideConfigBetty) {
      actionBtn = ButtonCustom(text: 'Concluir', onPressed: _goToHome);
    }

    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(bottom: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            AppBarCustom(
              title: Image.asset('assets/images/logo.png', width: 80),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text.rich(TextSpan(
                    text: 'De uma forma',
                    children: [
                      TextSpan(
                        text: ' fácil ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                          text: 'iremos ajudar você a gerenciar seu diabetes!')
                    ],
                    style: TextStyle(
                      fontSize: 16,
                      color: primaryColor,
                    ),
                  )),
                  const SizedBox(height: 10),
                  Text(
                    'Conheça os profissionais que garantem a segurança e eficácia do '
                    'Gooday para a sua saúde.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 20),
                  Visibility(
                    visible: Platform.isAndroid || Platform.isIOS,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: YoutubePlayer(
                        controller: _youtubeCtrl,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
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
                        style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll<Color>(primaryColor),
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
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: actionBtn,
            ),
          ],
        ),
      ),
    );
  }
}
