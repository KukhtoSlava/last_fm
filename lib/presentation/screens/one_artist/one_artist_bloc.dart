import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:last_fm/data/models/response_oneartist.dart';
import 'package:last_fm/data/repository.dart';
import 'package:rxdart/rxdart.dart';

class OneArtistBloc extends BlocBase {
  Repository _repository;

  OneArtistBloc(repository) {
    this._repository = repository;
  }

  Observable<ResponseArtist> getArtist(String artist) =>
      _repository.getOneArtist(artist);
}
