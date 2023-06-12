import 'package:intl/intl.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'package:gooday/src/common/item.dart';
import 'package:gooday/src/common/theme.dart';
import 'package:gooday/src/widgets/button.dart';
import 'package:gooday/src/widgets/appbar.dart';
import 'package:gooday/src/models/meal_model.dart';
import 'package:gooday/src/models/food_model.dart';
import 'package:gooday/src/services/util_service.dart';
import 'package:gooday/src/providers/user_provider.dart';
import 'package:gooday/src/widgets/form/input_field.dart';
import 'package:gooday/src/services/api/food_service.dart';
import 'package:gooday/src/services/api/meal_service.dart';
import 'package:gooday/src/widgets/form/checkbox_field.dart';

class MealFormPage extends StatefulWidget {
  const MealFormPage({super.key});

  @override
  State<MealFormPage> createState() => _MealFormPageState();
}

class _MealFormPageState extends State<MealFormPage> {
  bool _showError = false;
  final _formKey = GlobalKey<FormState>();

  final FoodApiService _foodApi = FoodApiService();
  final MealApiService _mealApi = MealApiService();

  bool _toggleSearchList = false;
  final FocusNode _searchFocus = FocusNode();
  final _searchCtrl = TextEditingController();

  String? _typeCtrl;
  DateTime _dateCtrl = DateTime.now();
  final List<MealFood> _foodListCtrl = [];
  final _glycemiaCtrl = TextEditingController();

  List<FoodModel> _foodList = [];
  late Future<List<FoodModel>> _fetchFoodList;
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

  @override
  void initState() {
    super.initState();
    _fetchFoodList = _foodApi.getAll();
    _searchCtrl.addListener(() {
      setState(() {});
    });
  }

  String get _getDateFullLabel {
    final week = DateFormat('EEE').format(_dateCtrl);
    final month = DateFormat('MMM').format(_dateCtrl);
    final time = DateFormat('HH:mm').format(_dateCtrl);
    return "$week, ${_dateCtrl.day} de $month às $time".toUpperCase();
  }

  String get _getTotalCho {
    final total = _foodListCtrl.fold(
        0.0, (prev, value) => prev + (value.cho * value.quantity));
    final fomated = NumberFormat().format(total);
    return '${fomated}g';
  }

  String get _getTotalCalories {
    final total = _foodListCtrl.fold(
        0.0, (prev, value) => prev + (value.calories * value.quantity));
    final fomated = NumberFormat().format(total);
    return '${fomated}kcal';
  }

  String get _getTotalSize {
    final total = _foodListCtrl.fold(
        0.0, (prev, value) => prev + (value.size * value.quantity));
    final fomated = NumberFormat().format(total);
    return '$fomated(g/ml)';
  }

  List<FoodModel> get _getFoodList {
    final foods = _foodList
        .where((food) =>
            food.name.toLowerCase().contains(_searchCtrl.text.toLowerCase()))
        .toList();
    return foods;
  }

  String getChoLabel(MealFood item) {
    return NumberFormat().format(item.cho * item.quantity);
  }

  String getCaloriesLabel(MealFood item) {
    return NumberFormat().format(item.calories * item.quantity);
  }

  String getSizeLabel(MealFood item) {
    return NumberFormat().format(item.size * item.quantity);
  }

  bool _validator() {
    final isValid = _foodListCtrl.isNotEmpty && _typeCtrl != null;

    setState(() {
      _showError = true;
    });

    return _formKey.currentState!.validate() && isValid;
  }

  Future<void> _onSubmit() async {
    if (_validator()) {
      UtilService(context).loading('Salvando...');

      final userProvider = context.read<UserProvider>();
      final user = userProvider.data;

      for (final food in _foodListCtrl) {
        food.food = null;
      }

      final data = MealModel(
        userId: user!.id!,
        glycemia: num.parse(_glycemiaCtrl.text),
        type: MealType.values.firstWhere((value) => value.name == _typeCtrl),
        date: _dateCtrl,
        foods: _foodListCtrl,
      );

      await _mealApi.save(data);

      if (!mounted) return;

      context.pop();
      context.pop(data);
      UtilService(context).message('Refeição salva!');
    } else {
      UtilService(context).message('Verifique os campos destacados!');
    }
  }

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

  void _onToggleSearchList() {
    setState(() {
      _toggleSearchList = !_toggleSearchList;
    });
  }

  void _onFood(FoodModel value) {
    _searchFocus.unfocus();
    _searchCtrl.clear();

    final mealFood = MealFood(
      foodId: value.id!,
      quantity: 1,
      name: value.name,
      measure: value.measure,
      size: value.size,
      cho: value.cho,
      calories: value.calories,
      food: value,
    );

    _openFood(mealFood);
    _onToggleSearchList();
  }

  void _openFood(MealFood item) {
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

  void _onFoodSubmit(MealFood item) {
    final index =
        _foodListCtrl.indexWhere((food) => food.foodId == item.foodId);

    setState(() {
      if (index >= 0) {
        _foodListCtrl[index] = item;
      } else {
        _foodListCtrl.add(item);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: Column(
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
                    FutureBuilder(
                      future: _fetchFoodList,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          _foodList = snapshot.data!;
                        }

                        return Padding(
                          padding: const EdgeInsets.only(
                              bottom: 20, left: 30, right: 30),
                          child: TextFormField(
                            enabled: snapshot.connectionState ==
                                ConnectionState.done,
                            controller: _searchCtrl,
                            focusNode: _searchFocus,
                            onTap: _onToggleSearchList,
                            validator: (value) {
                              if (_foodListCtrl.isEmpty) {
                                return 'Selecione uma refeição';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              filled: true,
                              labelText: 'Pesquisar...',
                              suffixIcon: Icon(
                                snapshot.connectionState ==
                                        ConnectionState.waiting
                                    ? Icons.sync
                                    : Icons.search,
                              ),
                              fillColor: Colors.grey.shade200,
                              hintStyle: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.normal,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 20),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                        );
                      },
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
                                  isRequired: true,
                                  inputType: TextInputType.number,
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  'Tipo de refeição',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: _showError && _typeCtrl == null
                                        ? Theme.of(context).colorScheme.error
                                        : null,
                                  ),
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
                                                padding:
                                                    const EdgeInsets.all(10),
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
                                                style: const TextStyle(
                                                    fontSize: 12),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                  ],
                                ),
                                Visibility(
                                  visible: _showError && _typeCtrl == null,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Text(
                                      'Tipo de refeição é obrigatório!',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color:
                                            Theme.of(context).colorScheme.error,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                const Text('Refeição',
                                    style: TextStyle(fontSize: 18)),
                                const SizedBox(height: 10),
                                Visibility(
                                  visible: _foodListCtrl.isEmpty,
                                  child: const Text(
                                    'Procure pela sua refeição para adiciona-la aqui.',
                                    style:
                                        TextStyle(fontStyle: FontStyle.italic),
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
                                      '${getChoLabel(item)}g Carbos | '
                                      '${getCaloriesLabel(item)}kcal Calorias | '
                                      '${getSizeLabel(item)}(g/ml) Peso',
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
                                      '${getSizeLabel(item)}(g/ml)',
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
                            _getTotalCho,
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
              top: 190,
              left: 0,
              right: 0,
              bottom: 0,
              child: Material(
                color: Colors.grey.shade100,
                child: _FoodList(
                  foods: _getFoodList,
                  onSelected: _onFood,
                  selecteds: _foodListCtrl.map((item) => item.foodId).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FoodList extends StatelessWidget {
  const _FoodList({
    required this.foods,
    required this.selecteds,
    required this.onSelected,
  });

  final List<FoodModel> foods;
  final List<String> selecteds;
  final ValueChanged<FoodModel> onSelected;

  @override
  Widget build(BuildContext context) {
    if (foods.isEmpty) {
      return Center(
        child: Text(
          'Nenhum alimento encontrado!',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      );
    }

    return ListView.separated(
      itemCount: foods.length,
      padding: const EdgeInsets.only(bottom: 20),
      separatorBuilder: (context, index) => Divider(
        height: 1,
        indent: 30,
        endIndent: 30,
        color: Colors.grey.shade300,
      ),
      itemBuilder: (context, index) {
        final food = foods[index];

        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 30),
          onTap: () => onSelected(food),
          title: Text(
            food.name,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
          ),
          trailing: selecteds.any((id) => id == food.id)
              ? const Icon(Icons.check, color: Colors.green)
              : const Icon(Icons.chevron_right),
        );
      },
    );
  }
}

class _FoodEdit extends StatefulWidget {
  const _FoodEdit({required this.item, required this.onSubmit});

  final MealFood item;
  final ValueChanged<MealFood> onSubmit;

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
    _measureCtrl.text = widget.item.measure;

    if (widget.item.measure == 'custom') {
      _quantityCtrl.text = widget.item.size.toString();
    } else {
      _quantityCtrl.text = widget.item.quantity.toString();
    }

    _measureList = [
      Item(
        id: widget.item.food?.measure ?? '---',
        name: '${widget.item.food?.measure} (${widget.item.size} g/ml)',
      ),
      const Item(id: 'custom', name: 'Medida (g/ml)'),
    ];
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      final quantity = num.parse(_quantityCtrl.text);
      widget.item.measure = _measureCtrl.text;

      if (widget.item.measure == 'custom') {
        final choUnit = widget.item.food!.cho / widget.item.food!.size;
        final caloriesUnit =
            widget.item.food!.calories / widget.item.food!.size;

        widget.item.quantity = 1;
        widget.item.size = quantity;
        widget.item.cho = choUnit * quantity;
        widget.item.calories = caloriesUnit * quantity;
      } else {
        widget.item.quantity = quantity;
      }

      widget.onSubmit(widget.item);
      context.pop();
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
                label: 'Valor',
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
