import 'dart:io';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:last_fm/constants.dart';
import 'package:last_fm/data/enums/enums.dart';
import 'package:last_fm/data/models/response_user.dart';
import 'package:last_fm/data/repository.dart';
import 'package:last_fm/presentation/screens/main/albums/albums_fragment.dart';
import 'package:last_fm/presentation/screens/main/artists/artists_fragment.dart';
import 'package:last_fm/presentation/screens/main/main_bloc.dart';
import 'package:last_fm/presentation/screens/main/scrobbles/scrobbles_fragment.dart';
import 'package:last_fm/presentation/screens/main/tracks/tracks_fragment.dart';
import 'package:last_fm/presentation/screens/splash/splash_page.dart';
import 'package:last_fm/presentation/widgets/PNetworkImage.dart';
import 'package:last_fm/presentation/widgets/custom_icons_icons.dart';
import 'package:rxdart/rxdart.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  CompositeSubscription _compositeSubscription = CompositeSubscription();

  TabController _controller;

  int _currentTabIndex = 0;

  ScrobblesFragment _scrobblesFragment = ScrobblesFragment();
  TracksFragment _tracksFragment = TracksFragment();
  ArtistsFragment _artistsFragment = ArtistsFragment();
  AlbumsFragment _albumsFragment = AlbumsFragment();

  MainBloc _mainBloc = MainBloc(BlocProvider.getBloc<Repository>());

  String _convertTime(int timestamp) {
    var format = new DateFormat(DATE_FORMAT);
    var date = new DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return format.format(date);
  }

  @override
  void initState() {
    _controller = TabController(vsync: this, length: 4);
    _controller.addListener(() {
      _currentTabIndex = _controller.index;
      _mainBloc.updateBar(_currentTabIndex);
    });
    _mainBloc.updateBar(_currentTabIndex);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _compositeSubscription.dispose();
    super.dispose();
  }

  _checkCupertinoTabs(int index) {
    if (index == 1 && _artistsFragment.initial == true) {
      _artistsFragment.updateScreen();
    } else if (index == 2 && _albumsFragment.initial == true) {
      _albumsFragment.updateScreen();
    } else if (index == 3 && _tracksFragment.initial == true) {
      _tracksFragment.updateScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(primarySwatch: Colors.red),
        home: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: StreamBuilder(
                  stream: _mainBloc.getPeriodText(),
                  builder: (context, snappShot) {
                    if ((snappShot != null && !snappShot.hasData)) {
                      return Text(
                        SCROBBLES_NAMING,
                        style: new TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 22.0),
                      );
                    }
                    if (snappShot.data == SCROBBLES_NAMING) {
                      return Text(
                        snappShot.data,
                        style: new TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 22.0),
                      );
                    } else {
                      return GestureDetector(
                          onTap: () {
                            _settingModalBottomSheet(context);
                          },
                          child: Text(
                            "${snappShot.data}",
                            style: new TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 22.0),
                          ));
                    }
                  }),
            ),
            body: _buildBody(),
            drawer: new Drawer(
              elevation: 5.0,
              child: new Scaffold(
                backgroundColor: Colors.black54,
                body: _buildDrawer(),
              ),
            )));
  }

  Widget _buildBody() {
    if (Platform.isAndroid) {
      return Scaffold(
        body: DefaultTabController(
          length: 4,
          child: new Scaffold(
            body: TabBarView(
              controller: _controller,
              children: [
                _scrobblesFragment,
                _artistsFragment,
                _albumsFragment,
                _tracksFragment,
              ],
            ),
            bottomNavigationBar: new TabBar(
              controller: _controller,
              onTap: (index) {
                _currentTabIndex = index;
                _mainBloc.updateBar(_currentTabIndex);
              },
              tabs: [
                Tab(
                  icon: Icon(Icons.format_list_bulleted),
                  text: SCROBBLES_TAB,
                ),
                Tab(
                  icon: Icon(Icons.star),
                  text: ARTISTS_TAB,
                ),
                Tab(
                  icon: Icon(CustomIcons.album),
                  text: ALBUMS_TAB,
                ),
                Tab(
                  icon: Icon(CustomIcons.note_beamed),
                  text: TRACKS_TAB,
                )
              ],
              labelColor: Colors.red,
              unselectedLabelColor: Colors.grey,
            ),
            backgroundColor: Colors.black,
          ),
        ),
      );
    } else {
      return CupertinoTabScaffold(
        backgroundColor: Colors.black87,
        tabBar: CupertinoTabBar(
          backgroundColor: Colors.black,
          onTap: (index) {
            _currentTabIndex = index;
            _mainBloc.updateBar(_currentTabIndex);
            _checkCupertinoTabs(index);
          },
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.format_list_bulleted),
              title: Text(SCROBBLES_TAB),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.star),
              title: Text(ARTISTS_TAB),
            ),
            BottomNavigationBarItem(
              icon: Icon(CustomIcons.album),
              title: Text(ALBUMS_TAB),
            ),
            BottomNavigationBarItem(
              icon: Icon(CustomIcons.note_beamed),
              title: Text(TRACKS_TAB),
            ),
          ],
        ),
        tabBuilder: (BuildContext context, int index) {
          assert(index >= 0 && index <= 3);
          switch (index) {
            case 0:
              return _scrobblesFragment;
            case 1:
              return _artistsFragment;
            case 2:
              return _albumsFragment;
            case 3:
              return _tracksFragment;
          }
          return null;
        },
      );
    }
  }

  Widget _buildDrawer() {
    ResponseUser response;
    return StreamBuilder<ResponseUser>(
      stream: _mainBloc.getUserInfo(),
      builder: (context, snappShot) {
        String url = EMPTY_PICTURE;
        String name = "";
        String scrobbles = "";
        String date = "";
        String country = "";
        if (snappShot != null && snappShot.hasData) {
          response = snappShot.data;
        }
        if (response != null) {
          name = response.user.name;
          scrobbles = response.user.playcount;
          date = _convertTime(response.user.registered.text);
          country = response.user.country;
          url = response.user.image[3].text;
        }
        return Stack(children: <Widget>[
          Container(
              height: 300,
              width: double.infinity,
              child: PNetworkImage(
                url,
                fit: BoxFit.cover,
              )),
          Container(
            margin: EdgeInsets.fromLTRB(16.0, 250.0, 16.0, 16.0),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(5.0)),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  name,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                ),
                SizedBox(height: 10.0),
                Text("$SCROBBLES$scrobbles"),
                SizedBox(height: 10.0),
                Divider(),
                ListTile(
                  title: Text("$COUNTRY$country"),
                  leading: Icon(Icons.location_city),
                ),
                ListTile(
                  title: Text("$REGISTRATION_DATE$date"),
                  leading: Icon(Icons.date_range),
                ),
                ListTile(
                  onTap: () {
                    _logOutClicked();
                  },
                  title: Text(LOG_OUT),
                  leading: Icon(Icons.exit_to_app),
                )
              ],
            ),
          ),
        ]);
      },
    );
  }

  _logOutClicked() {
    _compositeSubscription.add(_mainBloc.logOut().listen((result) =>
        Navigator.of(context).pushReplacement(new MaterialPageRoute(
            builder: (BuildContext context) => new SplashPage()))));
  }

  _changePeriod(Period period) {
    _compositeSubscription.add(
        _mainBloc.setPeriod(period).listen((result) => _invalidateScreens()));
  }

  _invalidateScreens() {
    _artistsFragment.initial = true;
    _albumsFragment.initial = true;
    _tracksFragment.initial = true;
    _controller.index = _currentTabIndex;
    if (_currentTabIndex == 1) {
      _artistsFragment.updateScreen();
    } else if (_currentTabIndex == 2) {
      _albumsFragment.updateScreen();
    } else if (_currentTabIndex == 3) {
      _tracksFragment.updateScreen();
    }
    _mainBloc.updateBar(_currentTabIndex);
  }

  void _settingModalBottomSheet(context) {
    if (Platform.isAndroid) {
      showModalBottomSheet(
          context: context,
          builder: (BuildContext bc) {
            return Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      title: new Text(OVERALL),
                      onTap: () {
                        Navigator.of(context).pop();
                        _changePeriod(Period.overall);
                      }),
                  new ListTile(
                    title: new Text(DAY7),
                    onTap: () {
                      Navigator.of(context).pop();
                      _changePeriod(Period.day7);
                    },
                  ),
                  new ListTile(
                    title: new Text(MONTH1),
                    onTap: () {
                      Navigator.of(context).pop();
                      _changePeriod(Period.month1);
                    },
                  ),
                  new ListTile(
                    title: new Text(MONTH3),
                    onTap: () {
                      Navigator.of(context).pop();
                      _changePeriod(Period.month3);
                    },
                  ),
                  new ListTile(
                    title: new Text(MONTH6),
                    onTap: () {
                      Navigator.of(context).pop();
                      _changePeriod(Period.month6);
                    },
                  ),
                  new ListTile(
                    title: new Text(MONTH12),
                    onTap: () {
                      Navigator.of(context).pop();
                      _changePeriod(Period.month12);
                    },
                  ),
                ],
              ),
            );
          });
    } else {
      showCupertinoModalPopup(
          context: context,
          builder: (context) {
            return CupertinoActionSheet(
              cancelButton: CupertinoActionSheetAction(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(CANCEL)),
              actions: <Widget>[
                CupertinoActionSheetAction(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _changePeriod(Period.overall);
                  },
                  child: Text(OVERALL),
                ),
                CupertinoActionSheetAction(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _changePeriod(Period.day7);
                  },
                  child: Text(DAY7),
                ),
                CupertinoActionSheetAction(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _changePeriod(Period.month1);
                  },
                  child: Text(MONTH1),
                ),
                CupertinoActionSheetAction(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _changePeriod(Period.month3);
                  },
                  child: Text(MONTH3),
                ),
                CupertinoActionSheetAction(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _changePeriod(Period.month6);
                  },
                  child: Text(MONTH6),
                ),
                CupertinoActionSheetAction(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _changePeriod(Period.month12);
                  },
                  child: Text(MONTH12),
                )
              ],
            );
          });
    }
  }
}
