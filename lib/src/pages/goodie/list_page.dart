import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';

import 'package:gooday/src/common/theme.dart';
import 'package:gooday/src/widgets/appbar.dart';
import 'package:gooday/src/widgets/timeline.dart';

class GoodieListPage extends StatefulWidget {
  const GoodieListPage({super.key});

  @override
  State<GoodieListPage> createState() => _GoodieListPageState();
}

class _GoodieListPageState extends State<GoodieListPage> {
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
            color: secondaryColor,
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
                        colorFilter: const ColorFilter.mode(
                          primaryColor,
                          BlendMode.srcIn,
                        ),
                      ),
                      const Text(
                        '8:00',
                        style: TextStyle(
                          fontSize: 12,
                          color: primaryColor,
                        ),
                      )
                    ],
                  ),
                  suffix: Row(
                    children: [
                      const Text(
                        '10',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
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
