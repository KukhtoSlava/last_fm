import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:last_fm/data/enums/enums.dart';
import 'package:last_fm/data/models/response_user.dart';
import 'package:last_fm/data/repository.dart';
import 'package:rxdart/rxdart.dart';

class MainBloc extends BlocBase {
  Repository _repository;
  BehaviorSubject<int> _periodSubject = BehaviorSubject<int>();

  MainBloc(repository) {
    this._repository = repository;
  }

  Observable<ResponseUser> getUserInfo() {
    return _repository.getUserInfo();
  }

  Observable<bool> logOut() {
    return _repository.removeUserData().asBroadcastStream();
  }

  Observable<bool> setPeriod(Period period) {
    return _repository.setPeriod(period);
  }

  Observable<String> getPeriodText() {
    return _periodSubject.flatMap((position) {
      if (position == 0) {
        return Observable.just("Scrobbles");
      } else {
        return _repository
            .getPeriod()
            .map((period) => PeriodHelper.getValue(period));
      }
    });
  }

  updateBar(int position) {
    _periodSubject.add(position);
  }

  @override
  void dispose() {
    _periodSubject.close();
    super.dispose();
  }
}
