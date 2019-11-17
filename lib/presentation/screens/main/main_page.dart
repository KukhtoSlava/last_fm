import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:last_fm/data/models/response_user.dart';
import 'package:last_fm/data/repository.dart';
import 'package:last_fm/presentation/screens/main/main_presenter.dart';
import 'package:last_fm/presentation/screens/main/main_view.dart';
import 'package:last_fm/presentation/screens/main/scrobbles/scrobbles_fragment.dart';
import 'package:last_fm/presentation/screens/splash/splash_page.dart';
import 'package:last_fm/presentation/widgets/PNetworkImage.dart';
import 'package:last_fm/presentation/widgets/custom_icons_icons.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> implements MainView {
  MainPresenter _mainPresenter =
      MainPresenter(BlocProvider.getBloc<Repository>());

  @override
  openSplash() {
    Navigator.of(context).pushReplacement(new MaterialPageRoute(
        builder: (BuildContext context) => new SplashPage()));
  }

  @override
  void initState() {
    _mainPresenter.init(this);
    super.initState();
  }

  String _convertTime(int timestamp) {
    var now = new DateTime.now();
    var format = new DateFormat('dd.MM.yyyy');
    var date = new DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return format.format(date);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(primarySwatch: Colors.red),
        home: Scaffold(
            appBar: AppBar(
              title: Text(""),
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
    return Scaffold(
      body: DefaultTabController(
        length: 4,
        child: new Scaffold(
          body: TabBarView(
            children: [
              new Container(child: new ScrobblesFragment()),
              new Container(
                color: Colors.purple,
              ),
              new Container(
                color: Colors.lightGreen,
              ),
              new Container(
                color: Colors.blueAccent,
              ),
            ],
          ),
          bottomNavigationBar: new TabBar(
            tabs: [
              Tab(
                icon: new Icon(Icons.format_list_bulleted),
                text: "Scrobbles",
              ),
              Tab(
                icon: new Icon(Icons.star),
                text: "Artists",
              ),
              Tab(
                icon: new Icon(CustomIcons.album),
                text: "Albums",
              ),
              Tab(
                icon: new Icon(CustomIcons.note_beamed),
                text: "Tracks",
              )
            ],
            labelColor: Colors.red,
            unselectedLabelColor: Colors.grey,
          ),
          backgroundColor: Colors.black,
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    ResponseUser response;
    return StreamBuilder<ResponseUser>(
      stream: _mainPresenter.getUserInfo(),
      builder: (context, snappShot) {
        String url = "";
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
                Text("Scrobbles: $scrobbles"),
                SizedBox(height: 10.0),
                Divider(),
                ListTile(
                  title: Text("Country: $country"),
                  leading: Icon(Icons.location_city),
                ),
                ListTile(
                  title: Text("Registrated date: $date"),
                  leading: Icon(Icons.date_range),
                ),
                ListTile(
                  onTap: () {
                    _mainPresenter.logOutClicked();
                  },
                  title: Text("Log out"),
                  leading: Icon(Icons.exit_to_app),
                )
              ],
            ),
          ),
        ]);
      },
    );
  }
}
