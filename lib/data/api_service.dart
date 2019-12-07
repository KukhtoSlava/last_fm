import 'package:http/http.dart' as http;

import '../constants.dart';

class ApiService {
  http.Client _client;

  ApiService(client) {
    this._client = client;
  }

  Future<http.Response> fetchUserInfo(String userName) async => _client.get(
      'https://ws.audioscrobbler.com/2.0/?method=user.getinfo&user=$userName&format=json&api_key=93748312c8b6bb664c0b42bca2c47d4a');

  Future<http.Response> userAuth(
          String userName, String password, String apiSig) async =>
      _client.post(
          "https://ws.audioscrobbler.com/2.0/?method=auth.getMobileSession&username=$userName&password=$password&api_sig=$apiSig&format=json&api_key=$API_KEY");

  Future<
      http
          .Response> getUserRecentTracks(String userName) async => _client.get(
      "https://ws.audioscrobbler.com/2.0/?method=user.getrecenttracks&user=$userName&api_key=$API_KEY&format=json");

  Future<http.Response> getUserAlbums(String userName, String period) async =>
      _client.get(
          "https://ws.audioscrobbler.com/2.0/?method=user.gettopalbums&user=$userName&api_key=$API_KEY&format=json&period=$period");

  Future<http.Response> getUserArtists(String userName, String period) async =>
      _client.get(
          "https://ws.audioscrobbler.com/2.0/?method=user.gettopartists&user=$userName&api_key=$API_KEY&format=json&period=$period");

  Future<http.Response> getUserTracks(String userName, String period) async =>
      _client.get(
          "https://ws.audioscrobbler.com/2.0/?method=user.gettoptracks&user=$userName&api_key=$API_KEY&format=json&period=$period");

  Future<
      http
          .Response> getAlbum(String artist, String album) async => _client.get(
      "https://ws.audioscrobbler.com/2.0/?method=album.getinfo&api_key=$API_KEY&artist=$artist&album=$album&format=json");

  Future<
      http
          .Response> getArtist(String artist) async => _client.get(
      "https://ws.audioscrobbler.com/2.0/?method=artist.getinfo&api_key=$API_KEY&artist=$artist&format=json");
}
