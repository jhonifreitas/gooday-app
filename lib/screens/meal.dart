import 'package:flutter/cupertino.dart';
import 'package:gooday/components/button.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';

import 'package:gooday/models/option.dart';
import 'package:gooday/components/appbar.dart';
import 'package:gooday/components/form_field.dart';

class MealFormScreen extends StatefulWidget {
  const MealFormScreen({super.key});

  @override
  State<MealFormScreen> createState() => _MealFormScreenState();
}

class _MealFormScreenState extends State<MealFormScreen> {
  bool _toggleSearchList = false;

  String? _typeCtrl;
  List<Option> _mealListCtrl = [];
  DateTime _dateCtrl = DateTime.now();
  final _glycemiaCtrl = TextEditingController();

  final List<Option> _typeList = const [
    Option(id: 'breakfast', name: 'Café', image: 'assets/icons/sandwich.svg'),
    Option(id: 'lunch', name: 'Almoço', image: 'assets/icons/chicken.svg'),
    Option(id: 'dinner', name: 'Jantar', image: 'assets/icons/cake.svg'),
    Option(id: 'snack', name: 'Lanche', image: 'assets/icons/fruits.svg'),
  ];

  final List<Option> _mealList = const [
    Option(id: 'option-1', name: 'Opção 1'),
    Option(id: 'option-2', name: 'Opção 2'),
  ];

  String get _getDateFullLabel {
    final week = DateFormat('EEE', 'pt_BR').format(_dateCtrl);
    final month = DateFormat('MMMM', 'pt_BR').format(_dateCtrl);
    return "$week, ${_dateCtrl.day} de $month".toUpperCase();
  }

  void _onSubmit() {}

  void _onDateTime() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return Container(
          height: 300,
          color: Colors.white,
          padding: const EdgeInsets.all(20),
          child: CupertinoDatePicker(
            initialDateTime: _dateCtrl,
            maximumDate: DateTime.now(),
            mode: CupertinoDatePickerMode.date,
            dateOrder: DatePickerDateOrder.dmy,
            use24hFormat: true,
            onDateTimeChanged: (DateTime newDate) {
              setState(() => _dateCtrl = newDate);
            },
          ),
        );
      },
    );
  }

  void _onType(String id) {
    setState(() {
      _typeCtrl = id;
    });
  }

  void _onSearch(Option value) {
    setState(() {
      _mealListCtrl.add(value);
    });
    _onToggleSearchList();
  }

  void _onToggleSearchList() {
    setState(() {
      _toggleSearchList = !_toggleSearchList;
    });
  }

  void _onMealEdit(Option item) {}

  void _openMealEdit(Option item) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return _MealEdit(item: item, onSubmit: _onMealEdit);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Column(
                children: [
                  AppBarCustom(
                    title: Material(
                      clipBehavior: Clip.hardEdge,
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                        onTap: _onDateTime,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          child: Text(_getDateFullLabel),
                        ),
                      ),
                    ),
                    suffix: IconButton(
                      icon: const Icon(Icons.calendar_today_outlined),
                      onPressed: _onDateTime,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(bottom: 20, left: 30, right: 30),
                    child: Material(
                      clipBehavior: Clip.hardEdge,
                      borderRadius: BorderRadius.circular(30),
                      child: InkWell(
                        onTap: _onToggleSearchList,
                        child: Ink(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Procurar refeição',
                                style: TextStyle(color: Colors.grey.shade700),
                              ),
                              const Icon(Icons.search, size: 20)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Material(
                  color: Colors.grey.shade100,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(top: 10, bottom: 220),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FormFieldCustom(
                                label: 'Informe sua glicemia',
                                placeholder: '000 mg/dL',
                                controller: _glycemiaCtrl,
                                inputType: TextInputType.number,
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'Tipo de refeição',
                                style: TextStyle(fontSize: 18),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  for (var item in _typeList)
                                    Material(
                                      color: Colors.transparent,
                                      clipBehavior: Clip.hardEdge,
                                      borderRadius: BorderRadius.circular(10),
                                      child: InkWell(
                                        onTap: () => _onType(item.id),
                                        child: Column(
                                          children: [
                                            Ink(
                                              padding: const EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade300,
                                                gradient: _typeCtrl == item.id
                                                    ? const LinearGradient(
                                                        begin:
                                                            Alignment.topLeft,
                                                        end: Alignment
                                                            .bottomRight,
                                                        stops: [0.1, 0.5],
                                                        colors: [
                                                          Color(0xFF41BBD9),
                                                          Color(0xFF115AA8),
                                                        ],
                                                      )
                                                    : null,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: SvgPicture.asset(
                                                item.image!,
                                                width: 50,
                                                colorFilter: _typeCtrl ==
                                                        item.id
                                                    ? const ColorFilter.mode(
                                                        Colors.white,
                                                        BlendMode.srcIn)
                                                    : null,
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              item.name,
                                              style:
                                                  const TextStyle(fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                ],
                              ),
                              const SizedBox(height: 20),
                              const Text('Refeição',
                                  style: TextStyle(fontSize: 18)),
                              const SizedBox(height: 10),
                              Visibility(
                                visible: _mealListCtrl.isEmpty,
                                child: const Text(
                                  'Procure pela sua refeição para adiciona-la aqui',
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: _mealListCtrl.isNotEmpty,
                          child: Column(
                            children: [
                              for (var item in _mealListCtrl)
                                ListTile(
                                  minLeadingWidth: 20,
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 30),
                                  onTap: () => _openMealEdit(item),
                                  title: Text(
                                    item.name,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  subtitle: Text(
                                    '25,9 Carbs | 0,2g Gorduras | 0,4g Proteínas | '
                                    '110,9kcal Calorias',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  leading: SvgPicture.asset(
                                    'assets/icons/edit-square.svg',
                                    width: 20,
                                    colorFilter: ColorFilter.mode(
                                      Theme.of(context).primaryColor,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  trailing: Text(
                                    '80g',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0.05, 0.5],
                  colors: [
                    Color(0xFF41BBD9),
                    Color(0xFF115AA8),
                  ],
                ),
                borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
              ),
              child: Column(
                children: [
                  const Text(
                    'Nutrientes',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: const [
                          Text(
                            'Carbos',
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            'Og',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: const [
                          Text(
                            'Proteínas',
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            'Og',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: const [
                          Text(
                            'Gorduras',
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            'Og',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: const [
                          Text(
                            'Calorias',
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            'Okcal',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _onSubmit,
                      style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                          Color(0xFFF7C006),
                        ),
                      ),
                      child: Text(
                        'Salvar Refeição',
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: _toggleSearchList,
            child: Positioned(
              top: 120,
              left: 0,
              right: 0,
              bottom: 0,
              child: Material(
                color: Colors.grey.shade100,
                child: _MealList(onSelected: _onSearch, items: _mealList),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MealList extends StatelessWidget {
  const _MealList({
    required this.onSelected,
    required this.items,
  });

  final List<Option> items;
  final ValueChanged<Option> onSelected;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Column(
          children: [
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 30),
              onTap: () => onSelected(item),
              title: Text(
                item.name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
              trailing: const Icon(Icons.chevron_right),
            ),
            Divider(
              height: 1,
              indent: 30,
              endIndent: 30,
              color: Colors.grey.shade300,
            ),
          ],
        );
      },
    );
  }
}

class _MealEdit extends StatefulWidget {
  const _MealEdit({required this.item, required this.onSubmit});

  final Option item;
  final ValueChanged<Option> onSubmit;

  @override
  State<_MealEdit> createState() => _MealEditState();
}

class _MealEditState extends State<_MealEdit> {
  final _quantityCtrl = TextEditingController();

  void _onSubmit() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              widget.item.name,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Text('Quantidade', style: TextStyle(fontSize: 16)),
          ),
          const SizedBox(height: 10),
          GridView.count(
            primary: false,
            shrinkWrap: true,
            crossAxisCount: 2,
            childAspectRatio: 4,
            children: [
              ListTile(
                onTap: () {},
                minLeadingWidth: 0,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                title: const Text(
                  'Gramas (g)',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
                ),
                leading: Checkbox(
                  value: false,
                  onChanged: (value) {},
                ),
              ),
              ListTile(
                onTap: () {},
                minLeadingWidth: 0,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                title: const Text(
                  'Colher de Sopa (20g)',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
                ),
                leading: Checkbox(
                  value: false,
                  onChanged: (value) {},
                ),
              ),
              ListTile(
                onTap: () {},
                minLeadingWidth: 0,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                title: const Text(
                  'Porção de 100g',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
                ),
                leading: Checkbox(
                  value: false,
                  onChanged: (value) {},
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: FormFieldCustom(
              placeholder: '000',
              controller: _quantityCtrl,
              inputType: TextInputType.number,
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: ButtonCustom(
              text: 'Salvar',
              onPressed: _onSubmit,
            ),
          )
        ],
      ),
    );
  }
}
