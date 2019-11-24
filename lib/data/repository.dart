import 'dart:convert';

import 'package:last_fm/data/api_service.dart';
import 'package:last_fm/data/models/response_auth.dart';
import 'package:last_fm/data/models/response_recenttracks.dart';
import 'package:last_fm/data/models/response_user.dart';
import 'package:last_fm/data/preferences.dart';
import 'package:last_fm/data/system.dart';
import 'package:last_fm/exceptions/exceptions.dart';
import 'package:rxdart/rxdart.dart';

import '../constants.dart';
import 'enums/enums.dart';
import 'models/response_topalbums.dart';
import 'models/response_topartists.dart';
import 'models/response_toptracks.dart';

class Repository {
  ApiService _apiService;
  Preferences _preferences;
  System _system;

  Repository(apiService, preferences, system) {
    this._apiService = apiService;
    this._preferences = preferences;
    this._system = system;
  }

  Observable<ResponseUser> getUserInfo() {
    return getUserNameFast()
        .flatMap((userName) =>
            Observable.fromFuture(_apiService.fetchUserInfo(userName)))
        .flatMap((item) =>
            Observable.fromFuture(_preferences.setUserProfile(item.body)))
        .map((profile) => _preferences.getUserProfile())
        .onErrorResumeNext(Observable.just(_preferences.getUserProfile()))
        .map((profile) => ResponseUser.fromJson(json.decode(profile)))
        .asBroadcastStream();
  }

  Observable<String> auth(String userName, String password) {
    return Observable.just("$userName$password")
        .map((key) => _system.generateMd5(key))
        .map((authToken) => _system.generateMd5(
            "api_key${API_KEY}methodauth.getMobileSessionpassword${password}username$userName$SECRET"))
        .flatMap((sig) => Observable.fromFuture(
            _apiService.userAuth(userName, password, sig)))
        .map((item) =>
            ResponseAuth.fromJson(json.decode(utf8.decode(item.bodyBytes))))
        .map((body) {
      if (body.session == null) {
        throw UnauthorizedException("Incorrect login or password");
      } else {
        return body.session.name;
      }
    }).asBroadcastStream();
  }

  Observable<String> getUserName() {
    return Observable.just("")
        .delay(Duration(
            seconds: 3)) //hack need to init sharedpreferences in splash
        .map((item) => _preferences.getUserName());
  }

  Observable<bool> saveUserName(String userName) {
    return Observable.fromFuture(_preferences.setUserName(userName))
        .asBroadcastStream();
  }

  Observable<String> getUserNameFast() {
    return Observable.just(_preferences.getUserName());
  }

  Observable<bool> removeUserData() {
    return Observable.fromFuture(_preferences.removeUserName())
        .flatMap(
            (result) => Observable.fromFuture(_preferences.removeUserProfile()))
        .asBroadcastStream();
  }

  Observable<ResponseRecentTracks> getRecentTracks() {
    return Observable.just(_preferences.getUserName())
        .flatMap((userName) =>
            Observable.fromFuture(_apiService.getUserRecentTracks(userName)))
        .map((response) => ResponseRecentTracks.fromJson(
            json.decode(utf8.decode(response.bodyBytes))))
        .asBroadcastStream();
  }

  Observable<ResponseTopTracks> getTracks() {
    return Observable.just(_preferences.getUserName())
        .flatMap((userName) => Observable.fromFuture(_apiService.getUserTracks(
            userName, PeriodHelper.getValue(_preferences.getPeriod()))))
        .map((response) => ResponseTopTracks.fromJson(
            json.decode(utf8.decode(response.bodyBytes))))
        .asBroadcastStream();
  }

  Observable<ResponseTopArtists> getArtists() {
    return Observable.just(_preferences.getUserName())
        .flatMap((userName) => Observable.fromFuture(_apiService.getUserArtists(
            userName, PeriodHelper.getValue(_preferences.getPeriod()))))
        .map((response) => ResponseTopArtists.fromJson(
            json.decode(utf8.decode(response.bodyBytes))))
        .asBroadcastStream();
  }

  Observable<ResponseTopAlbums> getAlbums() {
    return Observable.just(_preferences.getUserName())
        .flatMap((userName) => Observable.fromFuture(_apiService.getUserAlbums(
            userName, PeriodHelper.getValue(_preferences.getPeriod()))))
        .map((response) => ResponseTopAlbums.fromJson(
            json.decode(utf8.decode(response.bodyBytes))))
        .asBroadcastStream();
  }

  Observable<bool> setPeriod(Period period) {
    return Observable.fromFuture(_preferences.setPeriod(period));
  }

  Observable<Period> getPeriod(){
    return Observable.just(_preferences.getPeriod());
  }
}
