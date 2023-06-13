import 'package:intl/intl.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:gooday/src/common/theme.dart';
import 'package:gooday/src/widgets/appbar.dart';
import 'package:gooday/src/models/alert_model.dart';
import 'package:gooday/src/pages/alert/form_page.dart';
import 'package:gooday/src/providers/user_provider.dart';
import 'package:gooday/src/services/api/alert_service.dart';

class AlertListPage extends StatefulWidget {
  const AlertListPage({required this.goToPage, super.key});

  final ValueChanged<int> goToPage;

  @override
  State<AlertListPage> createState() => _AlertListPageState();
}

class _AlertListPageState extends State<AlertListPage> {
  final _alertApi = AlertApiService();

  DateTime _date = DateTime.now();
  late Future<List<AlertModel>> _loadList;

  @override
  void initState() {
    _loadList = _loadData();
    super.initState();
  }

  String get _getDateFullLabel {
    final week = DateFormat('EEEE').format(_date);
    final month = DateFormat('MMMM').format(_date);
    return "$week, ${_date.day} de $month".toUpperCase();
  }

  String get _getDateLabel {
    final month = DateFormat('MMMM').format(_date);
    return "${_date.day} de $month";
  }

  Future<List<AlertModel>> _loadData() {
    final user = context.read<UserProvider>().data!;
    return _alertApi.getByDate(user.id!, _date);
  }

  Future<void> _openForm([AlertModel? alert]) async {
    final result = await showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              AlertFormPage(data: alert),
            ],
          ),
        );
      },
    );

    if (result != null) _reloadData();
  }

  void _reloadData() {
    setState(() {
      _loadList = _loadData();
    });
  }

  void _goToPrev() {
    setState(() {
      _date = _date.subtract(const Duration(days: 1));
    });
    _reloadData();
  }

  void _goToNext() {
    setState(() {
      _date = _date.add(const Duration(days: 1));
    });
    _reloadData();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
              child: FutureBuilder(
                future: _loadList,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: Text(
                        'Nenhum registro encontrado!\n'
                        'Cadastre uma alerta para adiciona-lo aqui.',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    padding: const EdgeInsets.only(
                        top: 20, bottom: 160, left: 20, right: 20),
                    itemBuilder: (context, index) {
                      final item = snapshot.data![index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Hoje '.toUpperCase(),
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                TextSpan(
                                  text: '| $_getDateLabel',
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                          _NotificationCard(data: item, onEdit: _openForm),
                        ],
                      );
                    },
                  );
                },
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
              backgroundColor: secondaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
                side: const BorderSide(width: 10, color: Colors.white),
              ),
              onPressed: _openForm,
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        )
      ],
    );
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({required this.data, required this.onEdit});

  final AlertModel data;
  final ValueChanged<AlertModel> onEdit;

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
                  const Text(
                    'Manhã',
                    style: TextStyle(
                      fontSize: 16,
                      color: primaryColor,
                    ),
                  ),
                  Text(
                    data.time,
                    style: const TextStyle(
                      fontSize: 16,
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  _NotificationCardListTile(data: data, onEdit: onEdit),
                  _NotificationCardListTile(data: data, onEdit: onEdit)
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
  const _NotificationCardListTile({required this.data, required this.onEdit});

  final AlertModel data;
  final ValueChanged<AlertModel> onEdit;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        data.title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
      ),
      subtitle: Text(
        data.message,
        style: const TextStyle(
          fontSize: 12,
          color: primaryColor,
        ),
      ),
      onTap: () => onEdit(data),
    );
  }
}
