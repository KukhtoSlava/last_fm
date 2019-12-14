import 'dart:io';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:last_fm/constants.dart';
import 'package:last_fm/data/repository.dart';
import 'package:last_fm/exceptions/exceptions.dart';
import 'package:last_fm/presentation/screens/main/main_page.dart';
import 'package:last_fm/presentation/screens/preview/login_bloc.dart';
import 'package:last_fm/presentation/widgets/ui_helper.dart';
import 'package:rxdart/rxdart.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  CompositeSubscription _compositeSubscription = CompositeSubscription();

  UICommonComponent _uiCommonComponent =
      BlocProvider.getBloc<UICommonComponent>();
  LoginBloc _loginBloc = LoginBloc(BlocProvider.getBloc<Repository>());
  TextEditingController _textEditingControllerName = TextEditingController();
  TextEditingController _textEditingControllerPassword =
      TextEditingController();
  String _name = "";
  String _password = "";

  @override
  void dispose() {
    _textEditingControllerName.dispose();
    _textEditingControllerPassword.dispose();
    _compositeSubscription.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView(
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: StreamBuilder<StatusLoading>(
                stream: _loginBloc.getStatus(),
                builder: (context, snappShot) {
                  if ((snappShot != null && !snappShot.hasData) ||
                      snappShot.data == StatusLoading.none) {
                    return Material(
                      elevation: 2.0,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      child: TextField(
                        enabled: true,
                        controller: _textEditingControllerName,
                        onChanged: (String value) {
                          _name = value;
                        },
                        cursorColor: Colors.deepOrange,
                        decoration: InputDecoration(
                            hintText: LOGIN,
                            prefixIcon: Material(
                              elevation: 0,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                              child: Icon(
                                Icons.people,
                                color: Colors.red,
                              ),
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 25, vertical: 13)),
                      ),
                    );
                  } else {
                    return Material(
                      elevation: 2.0,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      child: TextField(
                        enabled: false,
                        controller: _textEditingControllerName,
                        onChanged: (String value) {
                          _name = value;
                        },
                        cursorColor: Colors.deepOrange,
                        decoration: InputDecoration(
                            hintText: LOGIN,
                            prefixIcon: Material(
                              elevation: 0,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                              child: Icon(
                                Icons.people,
                                color: Colors.grey,
                              ),
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 25, vertical: 13)),
                      ),
                    );
                  }
                }),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: StreamBuilder<StatusLoading>(
                stream: _loginBloc.getStatus(),
                builder: (context, snappShot) {
                  if ((snappShot != null && !snappShot.hasData) ||
                      snappShot.data == StatusLoading.none) {
                    return Material(
                      elevation: 2.0,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      child: TextField(
                        obscureText: true,
                        enabled: true,
                        controller: _textEditingControllerPassword,
                        onChanged: (String value) {
                          _password = value;
                        },
                        cursorColor: Colors.deepOrange,
                        decoration: InputDecoration(
                            hintText: PASSWORD,
                            prefixIcon: Material(
                              elevation: 0,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                              child: Icon(
                                Icons.lock,
                                color: Colors.red,
                              ),
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 25, vertical: 13)),
                      ),
                    );
                  } else {
                    return Material(
                      elevation: 2.0,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      child: TextField(
                        obscureText: true,
                        enabled: false,
                        controller: _textEditingControllerPassword,
                        onChanged: (String value) {
                          _password = value;
                        },
                        cursorColor: Colors.deepOrange,
                        decoration: InputDecoration(
                            hintText: PASSWORD,
                            prefixIcon: Material(
                              elevation: 0,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                              child: Icon(
                                Icons.lock,
                                color: Colors.grey,
                              ),
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 25, vertical: 13)),
                      ),
                    );
                  }
                }),
          ),
          SizedBox(
            height: 25,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: StreamBuilder<StatusLoading>(
                stream: _loginBloc.getStatus(),
                builder: (context, snappShot) {
                  if ((snappShot != null && !snappShot.hasData) ||
                      snappShot.data == StatusLoading.none) {
                    return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                          color: Colors.red,
                        ),
                        child: FlatButton(
                            child: Text(
                              LOGIN,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18),
                            ),
                            onPressed: () {
                              _loginClicked();
                            }));
                  } else {
                    return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                          color: Colors.grey,
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              _platformProgressIndicator(),
                              FlatButton(
                                  child: Text(
                                    LOGIN,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 18),
                                  ),
                                  onPressed: () {})
                            ],
                          ),
                        ));
                  }
                }),
          ),
          SizedBox(
            height: 20,
          ),
          Center(
              child: GestureDetector(
            child: Text(
              FORGOT_PASSWORD,
              style: TextStyle(
                  color: Colors.red, fontSize: 12, fontWeight: FontWeight.w700),
            ),
            onTap: () {
              _forgotPasswordURL();
            },
          )),
          SizedBox(
            height: 40,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                NOT_ACCOUNT,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.normal),
              ),
              GestureDetector(
                child: Text(SIGN_UP,
                    style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        decoration: TextDecoration.underline)),
                onTap: () {
                  _signUpURL();
                },
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _platformProgressIndicator() {
    if (Platform.isAndroid) {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(Colors.red),
      );
    } else {
      return CupertinoActivityIndicator();
    }
  }

  _openMain() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => MainPage()));
  }

  _hideKeyboard() {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  _loginClicked() {
    _hideKeyboard();
    if (_name == "" || _password == "") {
      _uiCommonComponent.showErrorMessage(EMPTY_FIELDS, context);
      return;
    }
    _compositeSubscription.add(_loginBloc
        .login(_name, _password)
        .listen((name) => _openMain(), onError: (e, s) => _handleError(e)));
  }

  _handleError(dynamic error) {
    String errorMessage;
    if (error is UnauthorizedException) {
      errorMessage = error.cause;
    } else if (error is SocketException) {
      errorMessage = "Network connection problem";
    } else {
      errorMessage = error.toString();
    }
    _textEditingControllerName.text = _name;
    _textEditingControllerPassword.text = _password;
    _uiCommonComponent.showErrorMessage(errorMessage, context);
  }

  _forgotPasswordURL() async {
    _uiCommonComponent.openUrl(FORGOT_PASSWORD_URL, context);
  }

  _signUpURL() async {
    _uiCommonComponent.openUrl(SIGN_UP_URL, context);
  }
}

class WaveClipper1 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, size.height - 50);

    var firstEndPoint = Offset(size.width * 0.6, size.height - 29 - 50);
    var firstControlPoint = Offset(size.width * .25, size.height - 60 - 50);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint = Offset(size.width, size.height - 60);
    var secondControlPoint = Offset(size.width * 0.84, size.height - 50);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class WaveClipper3 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, size.height - 50);

    var firstEndPoint = Offset(size.width * 0.6, size.height - 15 - 50);
    var firstControlPoint = Offset(size.width * .25, size.height - 60 - 50);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint = Offset(size.width, size.height - 40);
    var secondControlPoint = Offset(size.width * 0.84, size.height - 30);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class WaveClipper2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, size.height - 50);

    var firstEndPoint = Offset(size.width * .7, size.height - 40);
    var firstControlPoint = Offset(size.width * .25, size.height);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint = Offset(size.width, size.height - 45);
    var secondControlPoint = Offset(size.width * 0.84, size.height - 50);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
