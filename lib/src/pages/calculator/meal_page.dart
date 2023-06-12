import 'package:intl/intl.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import 'package:gooday/src/common/item.dart';
import 'package:gooday/src/common/theme.dart';
import 'package:gooday/src/widgets/button.dart';
import 'package:gooday/src/widgets/appbar.dart';
import 'package:gooday/src/models/meal_model.dart';
import 'package:gooday/src/models/food_model.dart';
import 'package:gooday/src/services/util_service.dart';
import 'package:gooday/src/widgets/form/input_field.dart';
import 'package:gooday/src/services/api/food_service.dart';
import 'package:gooday/src/widgets/form/checkbox_field.dart';

class MealFormPage extends StatefulWidget {
  const MealFormPage({super.key});

  @override
  State<MealFormPage> createState() => _MealFormPageState();
}

class _MealFormPageState extends State<MealFormPage> {
  String? _searchCtrl;
  bool _toggleSearchList = false;

  String? _typeCtrl;
  DateTime _dateCtrl = DateTime.now();
  final List<FoodModel> _foodListCtrl = [];
  final _glycemiaCtrl = TextEditingController();

  final List<Item> _typeList = [
    Item(
        id: MealType.breakfast.name,
        name: 'Café',
        image: 'assets/icons/sandwich.svg'),
    Item(
        id: MealType.lunch.name,
        name: 'Almoço',
        image: 'assets/icons/chicken.svg'),
    Item(
        id: MealType.dinner.name,
        name: 'Jantar',
        image: 'assets/icons/cake.svg'),
    Item(
        id: MealType.snack.name,
        name: 'Lanche',
        image: 'assets/icons/fruits.svg'),
  ];

  String get _getDateFullLabel {
    final week = DateFormat('EEE').format(_dateCtrl);
    final month = DateFormat('MMM').format(_dateCtrl);
    final time = DateFormat('HH:mm').format(_dateCtrl);
    return "$week, ${_dateCtrl.day} de $month às $time".toUpperCase();
  }

  String get _getTotalCHO {
    final total = _foodListCtrl.fold(0.0, (prev, food) => prev + food.cho);
    final fomated = NumberFormat().format(total);
    return '${fomated}g';
  }

  String get _getTotalCalories {
    final total = _foodListCtrl.fold(0.0, (prev, food) => prev + food.calories);
    final fomated = NumberFormat().format(total);
    return '${fomated}kcal';
  }

  String get _getTotalSize {
    final total =
        _foodListCtrl.fold(0.0, (prev, food) => prev + (food.size ?? 0));
    final fomated = NumberFormat().format(total);
    return '$fomated(g/ml)';
  }

  Future<void> _onSubmit() async {}

  void _onDateTime() {
    UtilService(context).dateTimePicker(
      initialDateTime: _dateCtrl,
      maximumDate: DateTime.now(),
      mode: CupertinoDatePickerMode.dateAndTime,
      onChange: (dateTime) => setState(() => _dateCtrl = dateTime),
    );
  }

  void _onType(String id) {
    setState(() {
      _typeCtrl = id;
    });
  }

  void _onFood(FoodModel value) {
    _openFood(value);
    _onToggleSearchList();
  }

  void _onSearch(String? value) {
    setState(() {
      _searchCtrl = value;
    });
  }

  void _onToggleSearchList() {
    setState(() {
      _toggleSearchList = !_toggleSearchList;
    });
  }

  void _onFoodSubmit(FoodModel item) {
    final index = _foodListCtrl.indexWhere((food) => food.id == item.id);

    setState(() {
      if (index >= 0) {
        _foodListCtrl[index] = item;
      } else {
        _foodListCtrl.add(item);
      }
    });
  }

  void _openFood(FoodModel item) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              _FoodEdit(item: item, onSubmit: _onFoodSubmit),
            ],
          ),
        );
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
                    child: TextField(
                      onChanged: _onSearch,
                      onTap: _onToggleSearchList,
                      decoration: InputDecoration(
                        filled: true,
                        hintText: 'Pesquisar...',
                        suffix: const Icon(Icons.search),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        border: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey.shade300, width: 1),
                          borderRadius: BorderRadius.circular(30),
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
                              InputField(
                                label: 'Glicemia',
                                hint: '000 mg/dL',
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
                                  for (final item in _typeList)
                                    Material(
                                      color: Colors.transparent,
                                      clipBehavior: Clip.hardEdge,
                                      borderRadius: BorderRadius.circular(10),
                                      child: InkWell(
                                        onTap: () => _onType(item.id),
                                        child: Column(
                                          children: [
                                            Ink(
                                              height: 55,
                                              padding: const EdgeInsets.all(10),
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
                                                          tertiaryColor,
                                                          primaryColor,
                                                        ],
                                                      )
                                                    : null,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: SvgPicture.asset(
                                                item.image!,
                                                width: 40,
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
                                visible: _foodListCtrl.isEmpty,
                                child: const Text(
                                  'Procure pela sua refeição para adiciona-la aqui.',
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: _foodListCtrl.isNotEmpty,
                          child: Column(
                            children: [
                              for (final item in _foodListCtrl)
                                ListTile(
                                  minLeadingWidth: 20,
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 30),
                                  onTap: () => _openFood(item),
                                  title: Text(
                                    item.name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: primaryColor,
                                    ),
                                  ),
                                  subtitle: Text(
                                    '${item.cho}g Carbos | '
                                    '${item.calories}kcal Calorias | '
                                    '${item.size}(g/ml) Peso',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  leading: SvgPicture.asset(
                                    'assets/icons/edit-square.svg',
                                    width: 20,
                                    colorFilter: const ColorFilter.mode(
                                      primaryColor,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  trailing: Text(
                                    '${item.size ?? 0}(g/ml)',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: primaryColor,
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
                  colors: [tertiaryColor, primaryColor],
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
                        children: [
                          const Text(
                            'Carbos',
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            _getTotalCHO,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Text(
                            'Calorias',
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            _getTotalCalories,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Text(
                            'Peso',
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            _getTotalSize,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _onSubmit,
                      style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(secondaryColor),
                      ),
                      child: const Text(
                        'Salvar Refeição',
                        style: TextStyle(
                          fontSize: 16,
                          color: primaryColor,
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
              top: 180,
              left: 0,
              right: 0,
              bottom: 0,
              child: Material(
                color: Colors.grey.shade100,
                child:
                    _FoodList(onSelected: _onFood, search: _searchCtrl ?? ''),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FoodList extends StatefulWidget {
  const _FoodList({required this.onSelected, required this.search});

  final String search;
  final ValueChanged<FoodModel> onSelected;

  @override
  State<_FoodList> createState() => _FoodListState();
}

class _FoodListState extends State<_FoodList> {
  final _foodApi = FoodApiService();

  Future<List<FoodModel>> _loadData() async {
    List<FoodModel> foods = await _foodApi.getAll();
    return foods;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadData(),
      builder: (context, snapshot) {
        List<FoodModel> items = snapshot.data ?? [];
        items = items
            .where((val) =>
                val.name.toLowerCase().contains(widget.search.toLowerCase()))
            .toList();

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData && items.isEmpty) {
          return const Center(child: Text('Nenhum alimento encontrado!'));
        }

        return ListView.builder(
          itemCount: items.length,
          padding: const EdgeInsets.only(bottom: 20),
          itemBuilder: (context, index) {
            final item = items[index];
            return Column(
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 30),
                  onTap: () => widget.onSelected(item),
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
      },
    );
  }
}

class _FoodEdit extends StatefulWidget {
  const _FoodEdit({required this.item, required this.onSubmit});

  final FoodModel item;
  final ValueChanged<FoodModel> onSubmit;

  @override
  State<_FoodEdit> createState() => _FoodEditState();
}

class _FoodEditState extends State<_FoodEdit> {
  final _formKey = GlobalKey<FormState>();
  final _quantityCtrl = TextEditingController();
  final _measureCtrl = TextEditingController();

  List<Item> _measureList = [];

  @override
  void initState() {
    super.initState();
    _measureCtrl.text = 'usual';
    _quantityCtrl.text = '1';
    _measureList = [
      Item(
          id: 'usual',
          name: '${widget.item.measure} (${widget.item.size} g/ml)'),
      const Item(id: 'custom', name: 'Medida (g/ml)'),
    ];
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      // final quantity = num.parse(_quantityCtrl.text);
      widget.item.measure = _measureCtrl.text;

      if (widget.item.measure == 'usual') {
        // widget.item.size = widget.item.sizeUnit ?? 0 * quantity;
        // widget.item.cho = widget.item.cho * quantity;
        // widget.item.calories = widget.item.calories * quantity;
      } else if (widget.item.measure == 'custom') {
        // widget.item.size = widget.item.sizeUnit ?? 0 * quantity;
        // widget.item.cho = widget.item.cho * quantity;
        // widget.item.calories = widget.item.calories * quantity;
      }

      context.pop(widget.item);
    } else {
      UtilService(context).message('Verifique os campos destacados!');
    }
  }

  void _onMeasure(String measure, bool selected) {
    setState(() {
      if (selected) {
        _measureCtrl.text = measure;
      } else {
        _measureCtrl.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.always,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                widget.item.name,
                style: const TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text('Quantidade', style: TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 10),
            Wrap(
              children: [
                for (final item in _measureList)
                  SizedBox(
                    width: (MediaQuery.of(context).size.width) / 2,
                    child: CheckboxField(
                      isRequired: _measureCtrl.text.isEmpty,
                      selected: _measureCtrl.text == item.id,
                      onSelected: (value) => _onMeasure(item.id, value),
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      text: item.name,
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: InputField(
                hint: '000',
                isRequired: true,
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
      ),
    );
  }
}
