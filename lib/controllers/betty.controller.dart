import 'package:gooday/models/option.dart';

class BettyController {
  // FOOD
  bool? lostWeightFoodCtrl;
  bool? believeFoodCtrl;
  List<String> helpFoodCtrl = [];
  List<String> foodListCtrl = [];
  List<String> noFoodListCtrl = [];
  List<String> limitFoodCtrl = [];

  final List<Option> helpFoodList = const [
    Option(
      id: 'option-1',
      name: 'Oferecendo dicas gratuítas de alimentação saudável',
    ),
    Option(
      id: 'option-2',
      name: 'Oferecendo um curso de contagem de carboidratos',
    ),
    Option(
      id: 'option-3',
      name: 'Oferecendo um programa alimentar online personalizado para você',
    ),
    Option(
      id: 'option-4',
      name: 'Agendando uma consulta com uma nutricionista da nossa clínica '
          'digital',
    ),
  ];
  final List<Option> limitFoodList = const [
    Option(id: 'Glúten', name: 'Glúten'),
    Option(id: 'Ovos', name: 'Ovos'),
    Option(id: 'Lactose', name: 'Lactose'),
    Option(id: 'Frutos do mar', name: 'Frutos do mar'),
    Option(id: 'Vegano', name: 'Vegano'),
    Option(id: 'Vegetariano', name: 'Vegetariano'),
  ];
  final List<Option> foodList = const [
    Option(id: 'Arroz', name: 'Arroz', image: 'assets/images/rice.png'),
    Option(id: 'Feijão', name: 'Feijão', image: 'assets/images/bean.png'),
    Option(id: 'Peixe', name: 'Peixe', image: 'assets/images/fish.png'),
    Option(id: 'Carne', name: 'Carne', image: 'assets/images/beef.png'),
    Option(id: 'Ovos', name: 'Ovos', image: 'assets/images/egg.png'),
  ];

  // EXERCISE
  bool? doExerciseCtrl;
  List<String> helpExerciseCtrl = [];
  List<String> exerciseListCtrl = [];

  final List<Option> helpExerciseList = const [
    Option(
      id: 'option-1',
      name: 'Oferecendo dicas gratuítas de Atividades físicas',
    ),
    Option(
      id: 'option-2',
      name: 'Oferecendo aulas diárias com base no seu perfil',
    ),
    Option(
      id: 'option-3',
      name: 'Agendando uma consulta com um educador físico da nossa clínica '
          'digital para ele te ajudar a montar um programa personalizado de '
          'exercícios',
    ),
  ];
  final List<Option> exerciseList = const [
    Option(id: 'Corrida', name: 'Corrida', image: 'assets/images/run.png'),
    Option(id: 'Bicicleta', name: 'Bicicleta', image: 'assets/images/bike.png'),
    Option(id: 'Exportes', name: 'Exportes', image: 'assets/images/soccer.png'),
    Option(id: 'Pilates', name: 'Pilates', image: 'assets/images/pilates.png'),
  ];

  // HEALTH
  List<String> timeExerciseCtrl = [];
  List<String> frequencyExerciseCtrl = [];

  final List<Option> timeExerciseList = const [
    Option(id: '7:00-8:00', name: '7hr - 8hr'),
    Option(id: '12:00-13:00', name: '12hr - 13hr'),
    Option(id: '18:00-19:00', name: '18hr - 19hr'),
    Option(id: '21:00-22:00', name: '21hr - 22hr'),
  ];
  final List<Option> frequencyExerciseList = const [
    Option(id: 'dayli', name: 'Diariamente'),
    Option(id: 'weekly', name: 'Semanalmente'),
    Option(id: '2 days', name: 'A Cada 2 Dias'),
    Option(id: '3 days', name: 'A Cada 3 Dias'),
  ];
}
