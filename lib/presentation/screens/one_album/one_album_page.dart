import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:last_fm/data/models/response_onealbum.dart';
import 'package:last_fm/data/models/response_topalbums.dart';
import 'package:last_fm/data/repository.dart';

import 'one_album_bloc.dart';

class AlbumPage extends StatefulWidget {
  Album album;

  AlbumPage({Key key, @required this.album}) : super(key: key);

  @override
  createState() {
    return AlbumPageState(album);
  }
}

class AlbumPageState extends State {
  Album _album;

  AlbumPageState(Album album) {
    this._album = album;
  }

  OneAlbumBloc _oneAlbumBloc = OneAlbumBloc(BlocProvider.getBloc<Repository>());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          centerTitle: true,
          title: Text(_album.name),
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Container(
                height: 400,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: CachedNetworkImageProvider(_album.image[3].text),
                        fit: BoxFit.cover)),
              ),
              StreamBuilder(
                  stream:
                      _oneAlbumBloc.getAlbum(_album.artist.name, _album.name),
                  builder: (context, snappShot) {
                    if ((snappShot != null && !snappShot.hasData)) {
                      return Container();
                    }
                    else {
                      ResponseAlbum response = snappShot.data as ResponseAlbum;
                      return Stack(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: 410.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "Scrobbles:",
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 20,
                                      ),
                                    ),
                                    Text(
                                      response.album.playcount,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "Listeners:",
                                      style: TextStyle(
                                          color: Colors.white70, fontSize: 20),
                                    ),
                                    Text(
                                      response.album.listeners,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.only(top: 450.0),
                              child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Stack(
                                    children: <Widget>[
                                      SizedBox(height: 400.0),
                                      Container(
                                        padding: EdgeInsets.all(4.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Wrap(
                                              runAlignment:
                                                  WrapAlignment.center,
                                              alignment: WrapAlignment.center,
                                              spacing: 3.0,
                                              children: buildTagsWidgets(
                                                  response.album.tags.tag),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ))),
                          Container(
                              margin: EdgeInsets.only(top: 520.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "Tracklist",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 30),
                                  ),
                                  Divider(
                                    color: Colors.white70,
                                  ),
                                ],
                              )),
                          Container(
                              margin: EdgeInsets.only(top: 570.0),
                              child: new ListView.separated(
                                  separatorBuilder: (context, index) => Divider(
                                        color: Colors.white70,
                                      ),
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.all(3),
                                  itemCount: response.album.tracks.track.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Card(
                                      clipBehavior: Clip.antiAlias,
                                      color: Colors.black38,
                                      elevation: 5,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Flexible(
                                              child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  "${index + 1} ${response.album.tracks.track[index].name}",
                                                  overflow: TextOverflow.fade,
                                                  maxLines: 1,
                                                  softWrap: false,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 17),
                                                ),
                                              ],
                                            ),
                                          ))
                                        ],
                                      ),
                                    );
                                  }))
                        ],
                      );
                    }
                  })
            ],
          ),
        ));
  }

  List<Widget> buildTagsWidgets(List<Tag> tags) {
    List<Widget> list = new List<Widget>();
    for (var i = 0; i < tags.length; i++) {
      var widget = Chip(
        label: Text(tags[i].name.toUpperCase()),
      );
      list.add(widget);
    }
    return list;
  }
}
