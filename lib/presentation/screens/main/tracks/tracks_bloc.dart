import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:last_fm/data/enums/enums.dart';
import 'package:last_fm/data/models/response_toptracks.dart';
import 'package:last_fm/data/repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';

class TracksBloc extends BlocBase {
  Repository _repository;

  TracksBloc(repository) {
    this._repository = repository;
  }

  Observable<ResponseTopTracks> getTracks() => _repository.getTracks();

  Observable<Tuple2<String, Period>> getAdvantage() {
    return Observable.zip2(_repository.getUserName(), _repository.getPeriod(),
        (userName, period) => Tuple2(userName, period));
  }
}
