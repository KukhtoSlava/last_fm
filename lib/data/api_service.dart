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
}
