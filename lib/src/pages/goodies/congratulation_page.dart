import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';

import 'package:gooday/src/common/theme.dart';

class GoodiesCongratulationPage extends StatelessWidget {
  const GoodiesCongratulationPage({required this.value, super.key});

  final int value;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Parabéns',
          style: TextStyle(
            color: primaryColor,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        SvgPicture.asset('assets/icons/gift-coin.svg', width: 150),
        const Text(
          'Você acaba de conquistar',
          style: TextStyle(color: primaryColor),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value.toString(),
              style: const TextStyle(
                color: primaryColor,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 10),
            SvgPicture.asset('assets/icons/coin.svg', width: 30),
            const SizedBox(width: 10),
            const Text(
              'coins',
              style: TextStyle(
                color: primaryColor,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
