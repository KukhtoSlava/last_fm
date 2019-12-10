import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:last_fm/data/enums/enums.dart';
import 'package:last_fm/data/models/response_recenttracks.dart';
import 'package:last_fm/data/repository.dart';
import 'package:last_fm/presentation/screens/main/scrobbles/scrobbles_bloc.dart';
import 'package:last_fm/presentation/screens/one_track/one_track_page.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';
import 'package:url_launcher/url_launcher.dart';

class ScrobblesFragment extends StatefulWidget {
  List<Track> _tracks = [];

  bool initial = true;

  @override
  State<StatefulWidget> createState() => ScrobblessFragmentState();
}

class ScrobblessFragmentState extends State<ScrobblesFragment> {
  CompositeSubscription _compositeSubscription = CompositeSubscription();

  RefreshController _refreshController;

  ScrobblesBloc _scrobblesBloc =
      ScrobblesBloc(BlocProvider.getBloc<Repository>());

  void _onRefresh() async {
    _compositeSubscription.add(_scrobblesBloc.getRecentTracks().listen(
        (data) => _handleCompleted(data.recenttracks.track),
        onError: (e, s) => _refreshController.refreshFailed()));
  }

  _handleCompleted(List<Track> tracks) {
    setState(() {
      widget._tracks = tracks;
      _refreshController.refreshCompleted();
      widget.initial = false;
    });
  }

  @override
  void initState() {
    _refreshController = RefreshController(initialRefresh: widget.initial);
    super.initState();
  }

  @override
  void dispose() {
    _compositeSubscription.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  _advancedClicked() {
    _compositeSubscription.add(
        _scrobblesBloc.getAdvantage().listen((data) => _openMoreUrl(data)));
  }

  _openMoreUrl(Tuple2<String, Period> pair) async {
    String name = pair.item1;
    String period = _mapPeriod(pair.item2);
    String url = 'https://www.last.fm/user/$name/library?date_preset=$period';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      _showToast("Could not launch $url");
    }
  }

  String _mapPeriod(Period period) {
    if (period == Period.day7) {
      return "LAST_7_DAYS";
    }
    if (period == Period.month1) {
      return "LAST_30_DAYS";
    }
    if (period == Period.month3) {
      return "LAST_90_DAYS";
    }
    if (period == Period.month6) {
      return "LAST_180_DAYS";
    }
    if (period == Period.month12) {
      return "LAST_365_DAYS";
    }
    return "ALL";
  }

  _showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      body: SmartRefresher(
          enablePullDown: true,
          enablePullUp: true,
          header: ClassicHeader(),
          footer: CustomFooter(
            loadStyle: LoadStyle.ShowAlways,
            builder: (BuildContext context, LoadStatus mode) {
              Widget body;
              body = GestureDetector(
                  onTap: () {
                    _advancedClicked();
                  },
                  child: Text(
                    "See more...",
                    style: TextStyle(fontSize: 18, color: Colors.white70),
                    textAlign: TextAlign.end,
                  ));
              if (mode == LoadStatus.idle) {
                return Container();
              } else {
                return Container(
                  alignment: AlignmentDirectional(1.0, 0.0),
                  margin: new EdgeInsets.only(right: 25.0),
                  height: 60.0,
                  child: body,
                );
              }
            },
          ),
          controller: _refreshController,
          onRefresh: _onRefresh,
          child: ListView.builder(
            padding: EdgeInsets.all(3),
            itemCount: widget._tracks.length,
            itemBuilder: (BuildContext context, int index) {
              Track track = widget._tracks[index];
              String url;
              if (track.image[3].text == "") {
                url =
                    "https://lastfm.freetls.fastly.net/i/u/300x300/2a96cbd8b46e442fc41c2b86b821562f.png";
              } else {
                url = track.image[3].text;
              }
              String date;
              if (track.date == null) {
                date = "Scrobling now";
              } else {
                date = track.date.text;
              }
              return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TrackPage(
                          artist: track.artist.text,
                          song: track.name,
                        ),
                      ),
                    );
                  },
                  child: Card(
                      clipBehavior: Clip.antiAlias,
                      color: Colors.black38,
                      elevation: 5,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            width: 5,
                          ),
                          Container(
                              height: 70,
                              width: 70,
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: CachedNetworkImageProvider(url),
                                      fit: BoxFit.cover))),
                          Flexible(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  track.name,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 17),
                                ),
                                Text(
                                  track.artist.text,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.white70),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  date,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.white),
                                ),
                              ],
                            ),
                          ))
                        ],
                      )));
            },
          )),
    );
  }
}
