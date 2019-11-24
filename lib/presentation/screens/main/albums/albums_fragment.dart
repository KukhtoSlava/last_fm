import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:last_fm/data/models/response_topalbums.dart';
import 'package:last_fm/data/repository.dart';
import 'package:last_fm/presentation/screens/main/albums/albums_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rxdart/rxdart.dart';

class AlbumsFragment extends StatefulWidget {
  List<Album> _albums = [];

  bool initial = true;

  AlbumsFragmentState _albumsFragmentState;

  updateScreen() {
    _albumsFragmentState._refreshController.requestRefresh();
  }

  @override
  State<StatefulWidget> createState() {
    _albumsFragmentState = AlbumsFragmentState();
    return _albumsFragmentState;
  }
}

class AlbumsFragmentState extends State<AlbumsFragment> {
  CompositeSubscription _compositeSubscription = CompositeSubscription();

  RefreshController _refreshController;

  AlbumsBloc _albumsBloc = AlbumsBloc(BlocProvider.getBloc<Repository>());

  void _onRefresh() async {
    _compositeSubscription.add(_albumsBloc.getAlbums().listen(
        (data) => _handleCompleted(data.topalbums.album),
        onError: (e, s) => _refreshController.refreshFailed()));
  }

  _handleCompleted(List<Album> artists) {
    setState(() {
      widget._albums = artists;
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
              );
              return Container(
                alignment: AlignmentDirectional(1.0, 0.0),
                margin: new EdgeInsets.only(right: 25.0),
                height: 60.0,
                child: body,
              );
            },
          ),
          controller: _refreshController,
          onRefresh: _onRefresh,
          child: GridView.builder(
            gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            padding: EdgeInsets.all(3),
            itemCount: widget._albums.length,
            itemBuilder: (BuildContext context, int index) {
              Album album = widget._albums[index];
              String url;
              if (album.image[3].text == "") {
                url =
                    "https://lastfm.freetls.fastly.net/i/u/300x300/2a96cbd8b46e442fc41c2b86b821562f.png";
              } else {
                url = album.image[3].text;
              }
              return Container(
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
                            "Scrobbles: ${album.playcount}",
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'Regular'),
                          ),
                          Text(
                            album.name,
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
              );
            },
          )),
    );
  }
}
