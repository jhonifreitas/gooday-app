import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'package:gooday/src/common/theme.dart';
import 'package:gooday/src/providers/user_provider.dart';

class IntroOnePage extends StatefulWidget {
  const IntroOnePage({super.key});

  @override
  State<IntroOnePage> createState() => _IntroOnePageState();
}

class _IntroOnePageState extends State<IntroOnePage> {
  int _currentPage = 0;
  final _pageCtrl = PageController();

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _goToNext() {
    _pageCtrl.nextPage(
      curve: Curves.easeInOut,
      duration: const Duration(milliseconds: 500),
    );

    if (_currentPage == 1) {
      context.push('/introducao/2');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Image.asset('assets/images/logo-white.png', width: 120),
            ),
            Container(
              height: 300,
              padding: const EdgeInsets.only(bottom: 30),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(50)),
              ),
              child: Column(
                children: [
                  Align(
                    heightFactor: 0.1,
                    alignment: const Alignment(0, 1),
                    child: Image.asset('assets/images/betty-intro.png',
                        width: 200),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 30),
                    child: Row(
                      children: [
                        Icon(
                          size: 10,
                          color: primaryColor,
                          _currentPage == 0
                              ? Icons.circle
                              : Icons.circle_outlined,
                        ),
                        const SizedBox(width: 5),
                        Icon(
                          size: 10,
                          color: primaryColor,
                          _currentPage == 1
                              ? Icons.circle
                              : Icons.circle_outlined,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: PageView(
                      controller: _pageCtrl,
                      onPageChanged: _onPageChanged,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Olá, ${context.watch<UserProvider>().data?.name?.split(' ')[0]}!',
                                style: const TextStyle(
                                    color: primaryColor, fontSize: 20),
                              ),
                              const SizedBox(height: 10),
                              Text.rich(
                                const TextSpan(
                                  text: 'Sou ',
                                  children: [
                                    TextSpan(
                                      text: 'Betty',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: primaryColor,
                                      ),
                                    ),
                                    TextSpan(
                                        text: ', muito prazer. Serei sua '
                                            'colaboradora para auxilia-lo a '
                                            'gerenciar seu diabetes.')
                                  ],
                                ),
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Antes de qualquer coisa, quero lhe apresentar o Gooday.',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'Vamos começar?',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: AnimatedContainer(
                      height: 55,
                      width: _currentPage == 0
                          ? 55
                          : MediaQuery.of(context).size.width,
                      duration: const Duration(milliseconds: 500),
                      margin: const EdgeInsets.symmetric(horizontal: 30),
                      child: FilledButton(
                        onPressed: _goToNext,
                        child: _currentPage == 0
                            ? const Icon(Icons.arrow_forward)
                            : const Text('Avançar'),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
