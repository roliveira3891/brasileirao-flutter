import 'package:brasileirao_flutter/models/time.dart';
import 'package:brasileirao_flutter/repositories/times_repository.dart';

class HomeController {
  TimesRepository timesRepository;

  List<Time> get tabela => timesRepository.times;

  HomeController() {
    timesRepository = TimesRepository();
  }
}
