import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:last_fm/data/models/response_toptracks.dart';
import 'package:last_fm/data/repository.dart';
import 'package:last_fm/presentation/screens/main/tracks/tracks_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rxdart/rxdart.dart';

class TracksFragment extends StatefulWidget {
  List<Track> _tracks = [];

  bool initial = true;

  TracksFragmentState _tracksFragmentState;

  updateScreen() {
    _tracksFragmentState._refreshController.requestRefresh();
  }

  @override
  State<StatefulWidget> createState() {
    _tracksFragmentState = TracksFragmentState();
    return _tracksFragmentState;
  }
}

class TracksFragmentState extends State<TracksFragment> {
  CompositeSubscription _compositeSubscription = CompositeSubscription();

  RefreshController _refreshController;

  TracksBloc _tracksBloc = TracksBloc(BlocProvider.getBloc<Repository>());

  void _onRefresh() async {
    _compositeSubscription.add(_tracksBloc.getTracks().listen(
        (data) => _handleCompleted(data.toptracks.track),
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

  @override
  Widget build(BuildContext context) {
    double c_width = MediaQuery.of(context).size.width * 0.8;
    return Container(
      width: c_width,
      color: Colors.black12,
      child: SmartRefresher(
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
                height: 60.0,
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
                            overflow: TextOverflow.fade,
                            maxLines: 1,
                            softWrap: false,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 17),
                          ),
                          Text(
                            track.artist.name,
                            overflow: TextOverflow.fade,
                            maxLines: 1,
                            softWrap: false,
                            style:
                                TextStyle(fontSize: 14, color: Colors.white70),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "scrobbles: ${track.playcount}",
                            overflow: TextOverflow.fade,
                            maxLines: 1,
                            softWrap: false,
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
