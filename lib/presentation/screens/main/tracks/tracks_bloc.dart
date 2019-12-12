import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:last_fm/data/enums/enums.dart';
import 'package:last_fm/data/models/response_toptracks.dart';
import 'package:last_fm/data/repository.dart';
import 'package:rxdart/rxdart.dart';

class TracksBloc extends BlocBase {
  Repository _repository;

  TracksBloc(repository) {
    this._repository = repository;
  }

  Observable<ResponseTopTracks> getTracks() => _repository.getTracks();

  Observable<String> getAdvantageUrl() {
    return _repository.getAdvantageUrl(TypeQuery.TRACKS);
  }
}
