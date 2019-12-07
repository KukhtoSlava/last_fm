import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:last_fm/data/models/response_onealbum.dart';
import 'package:last_fm/data/repository.dart';
import 'package:rxdart/rxdart.dart';

class OneAlbumBloc extends BlocBase {
  Repository _repository;

  OneAlbumBloc(repository) {
    this._repository = repository;
  }

  Observable<ResponseAlbum> getAlbum(String artist, String album) =>
      _repository.getOneAlbum(artist, album);
}
