import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:last_fm/data/enums/enums.dart';
import 'package:last_fm/data/models/response_topartists.dart';
import 'package:last_fm/data/repository.dart';
import 'package:last_fm/presentation/screens/main/artists/artists_bloc.dart';
import 'package:last_fm/presentation/screens/one_artist/one_artist_page.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';
import 'package:url_launcher/url_launcher.dart';

class ArtistsFragment extends StatefulWidget {
  List<Artist> _artists = [];

  bool initial = true;

  ArtistsFragmentState _artistsFragmentState;

  updateScreen() {
    _artistsFragmentState._refreshController.requestRefresh();
  }

  @override
  State<StatefulWidget> createState() {
    _artistsFragmentState = ArtistsFragmentState();
    return _artistsFragmentState;
  }
}

class ArtistsFragmentState extends State<ArtistsFragment> {
  CompositeSubscription _compositeSubscription = CompositeSubscription();

  RefreshController _refreshController;

  ArtistsBloc _artistsBloc = ArtistsBloc(BlocProvider.getBloc<Repository>());

  void _onRefresh() async {
    _compositeSubscription.add(_artistsBloc.getArtists().listen(
        (data) => _handleCompleted(data.topartists.artist),
        onError: (e, s) => _refreshController.refreshFailed()));
  }

  _handleCompleted(List<Artist> artists) {
    setState(() {
      widget._artists = artists;
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
    _compositeSubscription
        .add(_artistsBloc.getAdvantage().listen((data) => _openMoreUrl(data)));
  }

  _openMoreUrl(Tuple2<String, Period> pair) async {
    String name = pair.item1;
    String period = _mapPeriod(pair.item2);
    String url =
        'https://www.last.fm/user/$name/library/artists?date_preset=$period';
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
          child: GridView.builder(
            gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            padding: EdgeInsets.all(3),
            itemCount: widget._artists.length,
            itemBuilder: (BuildContext context, int index) {
              Artist artist = widget._artists[index];
              String url;
              if (artist.image[3].text == "") {
                url =
                    "https://lastfm.freetls.fastly.net/i/u/300x300/2a96cbd8b46e442fc41c2b86b821562f.png";
              } else {
                url = artist.image[3].text;
              }
              return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArtistPage(artist: artist.name),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4.0),
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: <Widget>[
                        Container(
                            height: double.infinity,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: CachedNetworkImageProvider(url),
                                    fit: BoxFit.cover))),
                        Container(
                            padding: const EdgeInsets.all(3.0),
                            color: Colors.black.withOpacity(0.5),
                            height: 45,
                            width: double.infinity,
                            child: Column(children: [
                              Text(
                                "Scrobbles: ${artist.playcount}",
                                maxLines: 1,
                                overflow: TextOverflow.fade,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontFamily: 'Regular'),
                              ),
                              Text(
                                artist.name,
                                maxLines: 1,
                                overflow: TextOverflow.fade,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: 'Regular'),
                              )
                            ])),
                      ],
                    ),
                  ));
            },
          )),
    );
  }
}
