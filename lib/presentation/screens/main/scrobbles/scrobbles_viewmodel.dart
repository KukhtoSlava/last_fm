import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:last_fm/data/models/response_recenttracks.dart';
import 'package:last_fm/data/repository.dart';
import 'package:rxdart/rxdart.dart';

class ScrobblesBloc extends BlocBase {
  Repository _repository;

  ScrobblesBloc(repository) {
    this._repository = repository;
  }

  Observable<ResponseRecentTracks> getRecentTracks() =>
      _repository.getRecentTracks();
}
