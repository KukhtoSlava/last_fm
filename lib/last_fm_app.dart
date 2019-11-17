import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:last_fm/data/api_service.dart';
import 'package:last_fm/data/preferences.dart';
import 'package:last_fm/data/repository.dart';
import 'package:last_fm/data/system.dart';
import 'package:last_fm/presentation/screens/splash/splash_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(Initial());

class Initial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      child: MaterialApp(
          home: SplashPage()
      ),
      blocs: [
        Bloc((i) => Repository(i.get<ApiService>(), i.get<Preferences>(), i.get<System>()),
            singleton: true),
      ],
      dependencies: [
        Dependency((i) => ApiService(http.Client()), singleton: true),
        Dependency((i) => Preferences(SharedPreferences.getInstance()),
            singleton: true),
        Dependency((i) => System(), singleton: true)
      ],
    );
  }
}
