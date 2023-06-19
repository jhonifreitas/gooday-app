import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:gooday/src/widgets/button.dart';
import 'package:gooday/src/models/drug_model.dart';
import 'package:gooday/src/services/api/drug_service.dart';

class DrugList extends StatefulWidget {
  const DrugList(
      {required this.selecteds, required this.onSelected, super.key});

  final List<String> selecteds;
  final void Function(String, bool) onSelected;

  @override
  State<DrugList> createState() => _DrugListState();
}

class _DrugListState extends State<DrugList> {
  final _drugApi = DrugApiService();
  late Future<List<DrugModel>> _loadData;

  @override
  void initState() {
    _loadData = _drugApi.getAll();
    super.initState();
  }

  void _onChanged(String id, bool? value) {
    if (value != null) {
      setState(() {
        widget.onSelected(id, value);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Align(
            alignment: Alignment.center,
            child: Text('Medicamentos',
                style: Theme.of(context).textTheme.titleMedium),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: FutureBuilder(
              future: _loadData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final drug = snapshot.data![index];

                    return CheckboxListTile(
                      title: Text(
                        drug.name,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.normal),
                      ),
                      value: widget.selecteds.any((val) => val == drug.name),
                      onChanged: (value) => _onChanged(drug.name, value),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: ButtonCustom(
              text: 'Confirmar',
              onPressed: () => context.pop(),
            ),
          ),
        ],
      ),
    );
  }
}
