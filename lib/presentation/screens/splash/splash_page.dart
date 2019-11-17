import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:last_fm/data/repository.dart';
import 'package:last_fm/presentation/screens/main/main_page.dart';
import 'package:last_fm/presentation/screens/preview/login_page.dart';
import 'package:last_fm/presentation/screens/splash/splash_presenter.dart';
import 'package:last_fm/presentation/screens/splash/splash_view.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => new _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin
    implements SplashView {
  SplashPresenter _splashPresenter;

  AnimationController controller;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller =
        new AnimationController(duration: Duration(seconds: 3), vsync: this)
          ..addListener(() => setState(() {}));
    animation = Tween(begin: 800.0, end: 0.0).animate(controller);
    controller.forward();
    _splashPresenter = SplashPresenter(BlocProvider.getBloc<Repository>());
    _splashPresenter.init(this);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Transform.translate(
          offset: Offset(0.0, animation.value),
          child: ListView(
            children: <Widget>[
              Stack(
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
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ));
  }

  @override
  openLogin() {
    Navigator.of(context).pushReplacement(new MaterialPageRoute(
        builder: (BuildContext context) => new LoginPage()));
  }

  @override
  openMain() {
    Navigator.of(context).pushReplacement(new MaterialPageRoute(
        builder: (BuildContext context) => new MainPage()));
  }
}
