import 'package:http/http.dart' as http;

import '../constants.dart';

class ApiService {
  http.Client _client;

  ApiService(client) {
    this._client = client;
  }

  Future<http.Response> fetchUserInfo(String userName) async => _client.get(
      '$BASE_URL?method=user.getinfo&user=$userName&format=json&api_key=93748312c8b6bb664c0b42bca2c47d4a');

  Future<http.Response> userAuth(
          String userName, String password, String apiSig) async =>
      _client.post(
          "$BASE_URL?method=auth.getMobileSession&username=$userName&password=$password&api_sig=$apiSig&format=json&api_key=$API_KEY");

  Future<
      http
          .Response> getUserRecentTracks(String userName) async => _client.get(
      "$BASE_URL?method=user.getrecenttracks&user=$userName&api_key=$API_KEY&format=json");

  Future<http.Response> getUserAlbums(String userName, String period) async =>
      _client.get(
          "$BASE_URL?method=user.gettopalbums&user=$userName&api_key=$API_KEY&format=json&period=$period");

  Future<http.Response> getUserArtists(String userName, String period) async =>
      _client.get(
          "$BASE_URL?method=user.gettopartists&user=$userName&api_key=$API_KEY&format=json&period=$period");

  Future<http.Response> getUserTracks(String userName, String period) async =>
      _client.get(
          "$BASE_URL?method=user.gettoptracks&user=$userName&api_key=$API_KEY&format=json&period=$period");

  Future<
      http
          .Response> getAlbum(String artist, String album) async => _client.get(
      "$BASE_URL?method=album.getinfo&api_key=$API_KEY&artist=$artist&album=$album&format=json");

  Future<http.Response> getArtist(String artist) async => _client.get(
      "$BASE_URL?method=artist.getinfo&api_key=$API_KEY&artist=$artist&format=json");

  Future<
      http
          .Response> getTrack(String artist, String song) async => _client.get(
      "$BASE_URL?method=track.getinfo&api_key=$API_KEY&artist=$artist&track=$song&format=json");

  Future<String> fetchHTML(String url) async {
    final response = await http.get(url);
    if (response.statusCode == 200)
      return response.body;
    else
      throw Exception('Failed');
  }
}
