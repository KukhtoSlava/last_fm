import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:last_fm/data/models/response_track.dart';
import 'package:last_fm/data/repository.dart';
import 'package:rxdart/rxdart.dart';

class OneTrackBloc extends BlocBase {
  Repository _repository;

  OneTrackBloc(repository) {
    this._repository = repository;
  }

  Observable<ResponseTrack> getTrack(String artist, String song) =>
      _repository.getOneTrack(artist, song);

  Observable<String> checkYouTubeLink(String url) {
    return _repository.parseHtml(url).map((body) => _findYouTubeLink(body));
  }

  String _findYouTubeLink(String body) {
    String link = "";
    dom.Document document = parser.parse(body);
    var elements = document.querySelectorAll("a.image-overlay-playlink-link");
    for (var i = 0; i < elements.length; i++) {
      String baseUrl = elements[i].attributes["href"];
      if (baseUrl.contains("https://www.youtube.com")) {
        link = baseUrl;
        break;
      }
    }
    return link;
  }
}
