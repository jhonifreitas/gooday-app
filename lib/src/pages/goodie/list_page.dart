import 'package:intl/intl.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:gooday/src/common/theme.dart';
import 'package:gooday/src/widgets/appbar.dart';
import 'package:gooday/src/widgets/timeline.dart';
import 'package:gooday/src/models/goodie_model.dart';
import 'package:gooday/src/providers/user_provider.dart';
import 'package:gooday/src/services/api/goodie_service.dart';

class GoodieListPage extends StatefulWidget {
  const GoodieListPage({super.key});

  @override
  State<GoodieListPage> createState() => _GoodieListPageState();
}

class _GoodieListPageState extends State<GoodieListPage> {
  final _goodieApi = GoodieApiService();

  Future<List<GoodieModel>> _loadList() {
    final userId = context.read<UserProvider>().data!.id!;
    return _goodieApi.getAll(userId);
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
            child: FutureBuilder(
              future: _loadList(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 10),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final goodie = snapshot.data![index];
                      return _GoodieItem(
                        goodie: goodie,
                        isFirst: index == 0,
                        isLast: snapshot.data!.length - 1 == index,
                      );
                    },
                  );
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset('assets/icons/gift.svg', width: 150),
                      const SizedBox(height: 10),
                      const Text(
                        'Nenhum registro encontrado!',
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _GoodieItem extends StatelessWidget {
  const _GoodieItem({
    required this.goodie,
    required this.isFirst,
    required this.isLast,
  });

  final bool isFirst;
  final bool isLast;
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
      isFirst: isFirst,
      isLast: isLast,
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
