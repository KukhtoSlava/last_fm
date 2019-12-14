import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:last_fm/data/repository.dart';
import 'package:last_fm/presentation/screens/main/main_page.dart';
import 'package:last_fm/presentation/screens/preview/login_page.dart';
import 'package:last_fm/presentation/screens/splash/splash_bloc.dart';
import 'package:rxdart/rxdart.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => new _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  CompositeSubscription _compositeSubscription = CompositeSubscription();
  SplashBloc _splashBloc = SplashBloc(BlocProvider.getBloc<Repository>());

  @override
  void initState() {
    super.initState();
    _compositeSubscription
        .add(_splashBloc.getUserName().listen((name) => _handleName(name)));
  }

  _handleName(String userName) {
    if (userName == "") {
      Navigator.of(context).pushReplacement(new MaterialPageRoute(
          builder: (BuildContext context) => new LoginPage()));
    } else {
      Navigator.of(context).pushReplacement(new MaterialPageRoute(
          builder: (BuildContext context) => new MainPage()));
    }
  }

  @override
  void dispose() {
    _compositeSubscription.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
            child: Stack(
                children: <Widget>[
                  ClipPath(
                    clipper: WaveClipper2(),
                    child: Container(
                      child: Column(),
                      width: double.infinity,
                      height: 300,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Color(0x22ff3a5a), Color(0x22fe494d)])),
                    ),
                  ),
                  ClipPath(
                    clipper: WaveClipper3(),
                    child: Container(
                      child: Column(),
                      width: double.infinity,
                      height: 300,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Color(0x44ff3a5a), Color(0x44fe494d)])),
                    ),
                  ),
                  ClipPath(
                    clipper: WaveClipper1(),
                    child: Container(
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 40,
                            ),
                            Image.asset('assets/images/logo_tranceporant.png',
                                width: 400.0, height: 150.0),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                        width: double.infinity,
                        height: 300,
                        decoration: BoxDecoration(color: Colors.black)),
                  ),
                ],
              ),
          ),
        );
  }
}
