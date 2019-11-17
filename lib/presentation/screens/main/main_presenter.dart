import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:last_fm/data/models/response_user.dart';
import 'package:last_fm/data/repository.dart';
import 'package:last_fm/presentation/screens/main/main_view.dart';
import 'package:rxdart/rxdart.dart';

class MainPresenter extends BlocBase {
  MainView _mainView;
  Repository _repository;
  CompositeSubscription compositeSubscription = CompositeSubscription();

  MainPresenter(repository) {
    this._repository = repository;
  }

  init(MainView mainView) {
    this._mainView = mainView;
  }

  Observable<ResponseUser> getUserInfo() {
    return _repository.getUserInfo();
  }

  logOutClicked() {
    compositeSubscription.add(_repository
        .removeUserData()
        .asBroadcastStream()
        .listen((item) =>_mainView.openSplash()));
  }

  @override
  void dispose() {
    compositeSubscription.dispose();
    super.dispose();
  }
}
