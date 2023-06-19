import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:gooday/src/common/theme.dart';
import 'package:gooday/src/widgets/appbar.dart';
import 'package:gooday/src/pages/alert/form_page.dart';
import 'package:gooday/src/models/drug_alert_model.dart';
import 'package:gooday/src/providers/user_provider.dart';
import 'package:gooday/src/services/api/drug_alert_service.dart';

class AlertListPage extends StatefulWidget {
  const AlertListPage({required this.goToPage, super.key});

  final ValueChanged<int> goToPage;

  @override
  State<AlertListPage> createState() => _AlertListPageState();
}

class _AlertListPageState extends State<AlertListPage> {
  final _alertApi = DrugAlertApiService();

  late Future<List<DrugAlertModel>> _loadList;

  @override
  void initState() {
    _loadList = _loadData();
    super.initState();
  }

  Future<List<DrugAlertModel>> _loadData() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = userProvider.data!;
    return _alertApi.getAll(user.id!);
  }

  Future<void> _openForm([DrugAlertModel? alert]) async {
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: AlertFormPage(data: alert),
              ),
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
                      return _NotificationCard(data: item, onEdit: _openForm);
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

  final DrugAlertModel data;
  final ValueChanged<DrugAlertModel> onEdit;

  String get _getPeriodLabel {
    if (data.period == 1) {
      return 'Diário';
    } else if (data.period == 2) {
      return 'A cada 2 dias';
    } else if (data.period == 3) {
      return 'A cada 3 dias';
    } else if (data.period == 5) {
      return 'A cada 5 dias';
    } else if (data.period == 7) {
      return 'Semanal';
    }

    return '---';
  }

  @override
  Widget build(BuildContext context) {
    List<_NotificationCardListTile> drugs = [];

    for (final drug in data.drugs) {
      final item = _NotificationCardListTile(drug: drug);
      drugs.add(item);
    }

    return Card(
      elevation: 0,
      clipBehavior: Clip.hardEdge,
      color: Colors.grey.shade200,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        onTap: () => onEdit(data),
        splashColor: Colors.black.withAlpha(10),
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
                      _getPeriodLabel,
                      style: const TextStyle(
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
                  children: drugs,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _NotificationCardListTile extends StatelessWidget {
  const _NotificationCardListTile({required this.drug});

  final String drug;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        drug,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }
}
