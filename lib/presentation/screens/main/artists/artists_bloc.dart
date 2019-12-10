import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:last_fm/data/enums/enums.dart';
import 'package:last_fm/data/models/response_topartists.dart';
import 'package:last_fm/data/repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';

class ArtistsBloc extends BlocBase {
  Repository _repository;

  ArtistsBloc(repository) {
    this._repository = repository;
  }

  Observable<ResponseTopArtists> getArtists() => _repository.getArtists();

  Observable<Tuple2<String, Period>> getAdvantage() {
    return Observable.zip2(_repository.getUserName(), _repository.getPeriod(),
            (userName, period) => Tuple2(userName, period));
  }
}
