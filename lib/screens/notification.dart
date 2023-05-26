import 'package:intl/intl.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';

import 'package:gooday/components/appbar.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  DateTime _date = DateTime.now();

  String get _getDateFullLabel {
    final week = DateFormat('EEEE', 'pt_BR').format(_date);
    final month = DateFormat('MMMM', 'pt_BR').format(_date);
    return "$week, ${_date.day} de $month".toUpperCase();
  }

  String get _getDateLabel {
    final month = DateFormat('MMMM', 'pt_BR').format(_date);
    return "${_date.day} de $month";
  }

  void _onEdit() {}

  void _goToPrev() {
    setState(() {
      _date = _date.add(const Duration(days: 1));
    });
  }

  void _goToNext() {
    setState(() {
      _date = _date.subtract(const Duration(days: 1));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            AppBarCustom(
              prefix: SvgPicture.asset('assets/icons/bell.svg'),
              title: const Text('Lembrete de Medicamentos'),
              suffix: SvgPicture.asset(width: 20, 'assets/icons/coin.svg'),
            ),
            Container(
              decoration: BoxDecoration(color: Colors.grey.shade300),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: _goToPrev,
                    icon: const Icon(Icons.arrow_left),
                  ),
                  Text(_getDateFullLabel),
                  IconButton(
                    onPressed: _goToNext,
                    icon: const Icon(Icons.arrow_right),
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(
                    top: 20, bottom: 160, left: 20, right: 20),
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Hoje '.toUpperCase(),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        TextSpan(
                          text: '| $_getDateLabel',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                  _NotificationCard(),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          right: 20,
          bottom: 80,
          child: SizedBox(
            width: 70,
            height: 70,
            child: FloatingActionButton(
              backgroundColor: const Color(0xFFF7C006),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
                side: const BorderSide(width: 10, color: Colors.white),
              ),
              onPressed: _onEdit,
              child: SvgPicture.asset(
                width: 30,
                'assets/icons/edit-square.svg',
                colorFilter:
                    const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class _NotificationCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      clipBehavior: Clip.hardEdge,
      color: Colors.grey.shade200,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: 100,
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: const BoxDecoration(
                border: Border(
                  right: BorderSide(width: 1, color: Colors.grey),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'Manhã',
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Text(
                    '8:00',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  _NotificationCardListTile(),
                  _NotificationCardListTile()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _NotificationCardListTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text(
        'Medicamento A',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
      ),
      subtitle: Text(
        '1 Comprimido',
        style: TextStyle(
          fontSize: 12,
          color: Theme.of(context).primaryColor,
        ),
      ),
      trailing: Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Checkbox(
          value: false,
          onChanged: (value) {},
        ),
      ),
      onTap: () {},
    );
  }
}
