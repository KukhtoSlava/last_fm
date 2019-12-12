import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:last_fm/data/enums/enums.dart';
import 'package:last_fm/data/models/response_topalbums.dart';
import 'package:last_fm/data/repository.dart';
import 'package:rxdart/rxdart.dart';

class AlbumsBloc extends BlocBase {
  Repository _repository;

  AlbumsBloc(repository) {
    this._repository = repository;
  }

  Observable<ResponseTopAlbums> getAlbums() => _repository.getAlbums();

  Observable<String> getAdvantageUrl() {
    return _repository.getAdvantageUrl(TypeQuery.ALBUMS);
  }
}
