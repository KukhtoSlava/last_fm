import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:last_fm/data/repository.dart';
import 'package:last_fm/exceptions/exceptions.dart';
import 'package:last_fm/presentation/screens/preview/login_view.dart';
import 'package:rxdart/rxdart.dart';

class LoginPresenter extends BlocBase {
  Repository _repository;
  CompositeSubscription _compositeSubscription = new CompositeSubscription();
  var _statusSubject = new PublishSubject<StatusLoading>();
  String _name = "";
  String _password = "";
  LoginView _loginView;

  LoginPresenter(Repository repository) {
    this._repository = repository;
  }

  init(LoginView loginView) {
    this._loginView = loginView;
    _statusSubject.add(StatusLoading.none);
  }

  changedName(String name) {
    _name = name;
  }

  changedPassword(String password) {
    _password = password;
  }

  onLoginClicked() {
    if (_name == "" || _password == "") {
      _loginView.showToast("Empty Fields!");
      return;
    }
    _compositeSubscription.add(_repository
        .auth(_name, _password)
        .doOnListen(() => _handleDoOnListen())
        .flatMap((name) => _repository.saveUserName(name))
        .doOnData((data) => _statusSubject.add(StatusLoading.none))
        .listen((name) => _loginView.openMain(),
            onError: (e, s) => _handleError(e)));
  }

  _handleDoOnListen() {
    _loginView.hideKeyboard();
    _statusSubject.add(StatusLoading.loading);
  }

  _handleError(dynamic error) {
    String errorMessage;
    if (error is UnauthorizedException) {
      errorMessage = error.cause;
    } else {
      error.toString();
    }
    _statusSubject.add(StatusLoading.none);
    _loginView.setName(_name);
    _loginView.setPassword(_password);
    _loginView.showToast(errorMessage);
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
