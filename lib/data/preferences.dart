import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

class Preferences {
  SharedPreferences _prefs;

  Preferences(Future<SharedPreferences> future) {
    initPrefs(future);
  }

  initPrefs(Future<SharedPreferences> future) async {
    _prefs = await future;
  }

  String getUserName() {
    if (_prefs.containsKey(PREFS_USER_NAME)) {
      return _prefs.get(PREFS_USER_NAME);
    } else {
      return "";
    }
  }

  Future<bool> setUserName(String userName) {
    return _prefs.setString(PREFS_USER_NAME, userName);
  }

  Future<bool> removeUserName() {
    return _prefs.remove(PREFS_USER_NAME);
  }

  String getUserProfile() {
    if (_prefs.containsKey(PREFS_USER_PROFILE)) {
      return _prefs.get(PREFS_USER_PROFILE);
    } else {
      return "";
    }
  }

  Future<bool> setUserProfile(String userProfile) {
    return _prefs.setString(PREFS_USER_PROFILE, userProfile);
  }

  Future<bool> removeUserProfile() {
    return _prefs.remove(PREFS_USER_PROFILE);
  }
}
