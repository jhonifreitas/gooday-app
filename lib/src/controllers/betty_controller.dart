import 'package:gooday/src/common/item.dart';
import 'package:gooday/src/models/user_model.dart';

class BettyController {
  // FOOD
  bool? lostWeightFoodCtrl;
  bool? adequateFoodCtrl;
  List<String> foodHelpsCtrl = [];
  List<String> foodLikesCtrl = [];
  List<String> foodNoLikesCtrl = [];
  List<String> foodLimitsCtrl = [];

  final List<Item> foodHelpList = const [
    Item(
      id: 'option-1',
      name: 'Oferecendo dicas gratuítas de alimentação saudável',
    ),
    Item(
      id: 'option-2',
      name: 'Oferecendo um curso de contagem de carboidratos',
    ),
    Item(
      id: 'option-3',
      name: 'Oferecendo um programa alimentar online personalizado para você',
    ),
    Item(
      id: 'option-4',
      name: 'Agendando uma consulta com uma nutricionista da nossa clínica '
          'digital',
    ),
  ];
  final List<Item> foodLimitList = const [
    Item(id: 'Glúten', name: 'Glúten'),
    Item(id: 'Ovos', name: 'Ovos'),
    Item(id: 'Lactose', name: 'Lactose'),
    Item(id: 'Frutos do mar', name: 'Frutos do mar'),
    Item(id: 'Vegano', name: 'Vegano'),
    Item(id: 'Vegetariano', name: 'Vegetariano'),
  ];
  final List<Item> foodList = const [
    Item(id: 'Arroz', name: 'Arroz', image: 'assets/images/rice.png'),
    Item(id: 'Feijão', name: 'Feijão', image: 'assets/images/bean.png'),
    Item(id: 'Peixe', name: 'Peixe', image: 'assets/images/fish.png'),
    Item(id: 'Carne', name: 'Carne', image: 'assets/images/beef.png'),
    Item(id: 'Ovos', name: 'Ovos', image: 'assets/images/egg.png'),
  ];

  // EXERCISE
  bool? doExerciseCtrl;
  List<String> exercisesCtrl = [];
  List<String> exerciseHelpsCtrl = [];

  final List<Item> exerciseHelpList = const [
    Item(
      id: 'option-1',
      name: 'Oferecendo dicas gratuítas de Atividades físicas',
    ),
    Item(
      id: 'option-2',
      name: 'Oferecendo aulas diárias com base no seu perfil',
    ),
    Item(
      id: 'option-3',
      name: 'Agendando uma consulta com um educador físico da nossa clínica '
          'digital para ele te ajudar a montar um programa personalizado de '
          'exercícios',
    ),
  ];
  final List<Item> exerciseList = const [
    Item(id: 'Corrida', name: 'Corrida', image: 'assets/images/run.png'),
    Item(id: 'Bicicleta', name: 'Bicicleta', image: 'assets/images/bike.png'),
    Item(id: 'Exportes', name: 'Exportes', image: 'assets/images/soccer.png'),
    Item(id: 'Pilates', name: 'Pilates', image: 'assets/images/pilates.png'),
  ];

  // HEALTH
  List<String> timeExerciseCtrl = [];
  int? frequencyExerciseCtrl;

  final List<Item> timeExerciseList = const [
    Item(id: '7:00-8:00', name: '7hr - 8hr'),
    Item(id: '12:00-13:00', name: '12hr - 13hr'),
    Item(id: '18:00-19:00', name: '18hr - 19hr'),
    Item(id: '21:00-22:00', name: '21hr - 22hr'),
  ];
  final List<Item> frequencyExerciseList = const [
    Item(id: '1', name: 'Diariamente'),
    Item(id: '2', name: 'A Cada 2 Dias'),
    Item(id: '3', name: 'A Cada 3 Dias'),
    Item(id: '7', name: 'Semanalmente'),
  ];

  initData(UserConfigBetty data) {
    if (data.lostWeight != null) lostWeightFoodCtrl = data.lostWeight;
    if (data.adequateFood != null) adequateFoodCtrl = data.adequateFood;
    if (data.foodHelps.isNotEmpty) foodHelpsCtrl = data.foodHelps;
    if (data.foodLikes.isNotEmpty) foodLikesCtrl = data.foodLikes;
    if (data.foodNoLikes.isNotEmpty) foodNoLikesCtrl = data.foodNoLikes;
    if (data.foodLimits.isNotEmpty) foodLimitsCtrl = data.foodLimits;
    if (data.doExercise != null) doExerciseCtrl = data.doExercise;
    if (data.exerciseHelps.isNotEmpty) exerciseHelpsCtrl = data.exerciseHelps;
    if (data.exercises.isNotEmpty) exercisesCtrl = data.exercises;
    if (data.timeExercise.isNotEmpty) timeExerciseCtrl = data.timeExercise;
    if (data.frequencyExercise != null) {
      frequencyExerciseCtrl = data.frequencyExercise;
    }
  }
}
