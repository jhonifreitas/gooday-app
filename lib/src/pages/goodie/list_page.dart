import 'package:intl/intl.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:gooday/src/common/theme.dart';
import 'package:gooday/src/widgets/appbar.dart';
import 'package:gooday/src/widgets/timeline.dart';
import 'package:gooday/src/models/goodie_model.dart';
import 'package:gooday/src/providers/user_provider.dart';
import 'package:gooday/src/services/goodie_service.dart';

class GoodieListPage extends StatefulWidget {
  const GoodieListPage({super.key});

  @override
  State<GoodieListPage> createState() => _GoodieListPageState();
}

class _GoodieListPageState extends State<GoodieListPage> {
  final _goodieService = GoodieService();

  Future<List<GoodieModel>> _loadList() {
    return _goodieService.getByDate(DateTime.now());
  }

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
                  context.watch<UserProvider>().data?.goodies.toString() ?? '0',
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
            child: FutureBuilder<List<GoodieModel>>(
              future: _loadList(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final goodie = snapshot.data![index];
                      return _GoodieItem(goodie: goodie);
                    },
                  );
                }
                return const CircularProgressIndicator();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _GoodieItem extends StatelessWidget {
  const _GoodieItem({required this.goodie});

  final GoodieModel goodie;

  String get _titleLabel {
    if (goodie.type == GoodieType.profileComplete) {
      return 'Conta';
    } else if (goodie.type == GoodieType.used) {
      return 'Goodies';
    } else if (goodie.goal != null) {
      return NumberFormat().format(goodie.goal);
    }

    return '---';
  }

  String get _descriptionLabel {
    if (goodie.type == GoodieType.profileComplete) {
      return 'configurada';
    } else if (goodie.type == GoodieType.used) {
      return 'utilizados';
    }

    return 'passos';
  }

  String get _iconAssets {
    if (goodie.type == GoodieType.profileComplete) {
      return 'assets/icons/user.svg';
    } else if (goodie.type == GoodieType.used) {
      return 'assets/icons/gift.svg';
    }

    return 'assets/icons/shoe.svg';
  }

  String get _valueLabel {
    return NumberFormat().format(goodie.value);
  }

  String get _timeLabel {
    return DateFormat('HH:mm').format(goodie.createdAt!);
  }

  @override
  Widget build(BuildContext context) {
    return TimelineItem(
      isFirst: true,
      isLast: true,
      title: Text(
        _titleLabel,
        style: const TextStyle(fontSize: 16),
      ),
      subtitle: Text(
        _descriptionLabel,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey.shade600,
        ),
      ),
      prefix: Column(
        children: [
          SvgPicture.asset(
            _iconAssets,
            width: 25,
            colorFilter: const ColorFilter.mode(
              primaryColor,
              BlendMode.srcIn,
            ),
          ),
          Text(
            _timeLabel,
            style: const TextStyle(
              fontSize: 12,
              color: primaryColor,
            ),
          )
        ],
      ),
      suffix: Row(
        children: [
          Text(
            _valueLabel,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          SvgPicture.asset('assets/icons/coin.svg', width: 20)
        ],
      ),
    );
  }
}