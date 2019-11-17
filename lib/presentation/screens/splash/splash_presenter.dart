import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:last_fm/data/repository.dart';
import 'package:last_fm/presentation/screens/splash/splash_view.dart';
import 'package:rxdart/rxdart.dart';

class SplashPresenter extends BlocBase {
  CompositeSubscription _compositeSubscription = CompositeSubscription();
  SplashView _splashView;

  Repository _repository;

  SplashPresenter(repository) {
    this._repository = repository;
  }

  init(SplashView splashView) {
    this._splashView = splashView;
    _compositeSubscription.add(_repository
        .getUserName()
        .delay(Duration(seconds: 2))
        .listen((name) => _handleName(name)));
  }

  _handleName(String name) {
    if (name == "") {
      _splashView.openLogin();
    } else {
      _splashView.openMain();
    }
  }

  @override
  void dispose() {
    _compositeSubscription.dispose();
    super.dispose();
  }
}
