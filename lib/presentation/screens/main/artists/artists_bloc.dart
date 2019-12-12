import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:last_fm/data/enums/enums.dart';
import 'package:last_fm/data/models/response_topartists.dart';
import 'package:last_fm/data/repository.dart';
import 'package:rxdart/rxdart.dart';

class ArtistsBloc extends BlocBase {
  Repository _repository;

  ArtistsBloc(repository) {
    this._repository = repository;
  }

  Observable<ResponseTopArtists> getArtists() => _repository.getArtists();

  Observable<String> getAdvantageUrl() {
    return _repository.getAdvantageUrl(TypeQuery.ARTISTS);
  }
}
