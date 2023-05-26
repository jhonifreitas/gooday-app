import 'package:flutter/material.dart';

import 'package:gooday/models/user.dart';

class IntroScreen1 extends StatefulWidget {
  const IntroScreen1({super.key});

  @override
  State<IntroScreen1> createState() => _IntroScreen1State();
}

class _IntroScreen1State extends State<IntroScreen1> {
  User? _user;

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
      Navigator.pushNamed(context, '/introducao/2');
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
                          color: Theme.of(context).primaryColor,
                          _currentPage == 0
                              ? Icons.circle
                              : Icons.circle_outlined,
                        ),
                        const SizedBox(width: 5),
                        Icon(
                          size: 10,
                          color: Theme.of(context).primaryColor,
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
                                'Olá, ${_user?.name}!',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 20),
                              ),
                              const SizedBox(height: 10),
                              Text.rich(
                                TextSpan(
                                  text: 'Sou ',
                                  children: [
                                    TextSpan(
                                      text: 'Betty',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                    const TextSpan(
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
