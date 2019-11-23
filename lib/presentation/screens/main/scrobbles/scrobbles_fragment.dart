import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:last_fm/data/models/response_recenttracks.dart';
import 'package:last_fm/data/repository.dart';
import 'package:last_fm/presentation/screens/main/scrobbles/scrobbles_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rxdart/rxdart.dart';

class ScrobblesFragment extends StatefulWidget {
  List<Track> _tracks = [];

  bool _initial = true;

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
      widget._initial = false;
    });
  }

  @override
  void initState() {
    _refreshController = RefreshController(initialRefresh: widget._initial);
    super.initState();
  }

  @override
  void dispose() {
    _compositeSubscription.dispose();
    super.dispose();
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
              body = Text(
                "See more...",
                style: TextStyle(fontSize: 18, color: Colors.white70),
                textAlign: TextAlign.end,
              );
              return Container(
                margin: new EdgeInsets.only(right: 25.0),
                height: 55.0,
                child: body,
              );
            },
          ),
          controller: _refreshController,
          onRefresh: _onRefresh,
          child: ListView.builder(
            padding: EdgeInsets.all(3),
            itemCount: widget._tracks.length,
            itemBuilder: (BuildContext context, int index) {
              Track track = widget._tracks[index];
              String date;
              if (track.date == null) {
                date = "Playing now";
              } else {
                date = track.date.text;
              }
              return Card(
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
                                image: CachedNetworkImageProvider(
                                    track.image[3].text),
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
                            style:
                                TextStyle(fontSize: 14, color: Colors.white70),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            date,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                        ],
                      ),
                    ))
                  ],
                ),
              );
            },
          )),
    );
  }
}
