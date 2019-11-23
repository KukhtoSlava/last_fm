import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:last_fm/data/repository.dart';
import 'package:rxdart/rxdart.dart';

class SplashBloc extends BlocBase {
  Repository _repository;

  SplashBloc(repository) {
    this._repository = repository;
  }

  Observable<String> getUserName() {
    return _repository.getUserName();
  }
}
