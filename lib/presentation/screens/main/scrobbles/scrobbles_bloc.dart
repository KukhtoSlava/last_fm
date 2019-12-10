import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:last_fm/data/enums/enums.dart';
import 'package:last_fm/data/models/response_recenttracks.dart';
import 'package:last_fm/data/repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';

class ScrobblesBloc extends BlocBase {
  Repository _repository;

  ScrobblesBloc(repository) {
    this._repository = repository;
  }

  Observable<ResponseRecentTracks> getRecentTracks() =>
      _repository.getRecentTracks();

  Observable<Tuple2<String, Period>> getAdvantage() {
    return Observable.zip2(_repository.getUserName(), _repository.getPeriod(),
        (userName, period) => Tuple2(userName, period));
  }
}
