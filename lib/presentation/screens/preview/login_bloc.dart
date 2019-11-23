import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:last_fm/data/repository.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc extends BlocBase {
  Repository _repository;
  var _statusSubject = new PublishSubject<StatusLoading>();

  LoginBloc(Repository repository) {
    this._repository = repository;
  }

  Observable<bool> login(String name, String password) {
    return _repository
        .auth(name, password)
        .doOnListen(() => _statusSubject.add(StatusLoading.loading))
        .flatMap((name) => _repository.saveUserName(name))
        .doOnData((data) => _statusSubject.add(StatusLoading.none))
        .doOnError(
            (dynamic e, dynamic s) => _statusSubject.add(StatusLoading.none));
  }

  Observable<StatusLoading> getStatus() {
    return _statusSubject;
  }

  @override
  void dispose() {
    _statusSubject.close();
    super.dispose();
  }
}

enum StatusLoading { none, loading }
