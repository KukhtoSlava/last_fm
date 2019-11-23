import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:last_fm/data/models/response_user.dart';
import 'package:last_fm/data/repository.dart';
import 'package:rxdart/rxdart.dart';

class MainBloc extends BlocBase {
  Repository _repository;

  MainBloc(repository) {
    this._repository = repository;
  }

  Observable<ResponseUser> getUserInfo() {
    return _repository.getUserInfo();
  }

  Observable<bool> logOut() {
    return _repository.removeUserData().asBroadcastStream();
  }
}
