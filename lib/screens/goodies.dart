import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';

import 'package:gooday/components/appbar.dart';
import 'package:gooday/components/timeline.dart';

class GoodiesScreen extends StatefulWidget {
  const GoodiesScreen({super.key});

  @override
  State<GoodiesScreen> createState() => _GoodiesScreenState();
}

class _GoodiesScreenState extends State<GoodiesScreen> {
  final int _total = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppBarCustom(
            title: const Text('Goodies'),
            suffix: SvgPicture.asset(width: 20, 'assets/icons/coin.svg'),
          ),
          Container(
            color: const Color(0xFFF7C006),
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Text(
                  _total.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                TimelineItem(
                  isFirst: true,
                  isLast: true,
                  title: const Text('1.000', style: TextStyle(fontSize: 16)),
                  subtitle: Text(
                    'Passos',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  prefix: Column(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/shoe.svg',
                        width: 25,
                        colorFilter: ColorFilter.mode(
                          Theme.of(context).primaryColor,
                          BlendMode.srcIn,
                        ),
                      ),
                      Text(
                        '8:00',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).primaryColor,
                        ),
                      )
                    ],
                  ),
                  suffix: Row(
                    children: [
                      Text(
                        '10',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      SvgPicture.asset('assets/icons/coin.svg', width: 20)
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
