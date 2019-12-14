import 'dart:io';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:last_fm/constants.dart';
import 'package:last_fm/data/models/response_oneartist.dart';
import 'package:last_fm/data/repository.dart';
import 'package:last_fm/presentation/screens/one_artist/one_artist_bloc.dart';

class ArtistPage extends StatefulWidget {
  String artist;

  ArtistPage({Key key, @required this.artist}) : super(key: key);

  @override
  createState() {
    return ArtistPageState(artist);
  }
}

class ArtistPageState extends State {
  String _artist;

  ArtistPageState(String artist) {
    this._artist = artist;
  }

  OneArtistBloc _oneArtistBloc =
      OneArtistBloc(BlocProvider.getBloc<Repository>());

  @override
  Widget build(BuildContext context) {
    var image = EMPTY_PICTURE;
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          centerTitle: true,
          title: Text(_artist),
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Container(
                height: 400,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: CachedNetworkImageProvider(image),
                        fit: BoxFit.cover)),
              ),
              StreamBuilder(
                  stream: _oneArtistBloc.getArtist(_artist),
                  builder: (context, snappShot) {
                    if (snappShot != null &&
                        snappShot.connectionState == ConnectionState.waiting) {
                      return Container(
                          margin: EdgeInsets.only(top: 410.0, bottom: 20),
                          child: Center(child: _platformProgressIndicator()));
                    }
                    if ((snappShot != null && !snappShot.hasData)) {
                      return Container();
                    } else {
                      ResponseArtist response =
                          snappShot.data as ResponseArtist;
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
                                      SCROBBLES,
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 20,
                                      ),
                                    ),
                                    Text(
                                      response.artist.stats.playcount,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      LISTENERS,
                                      style: TextStyle(
                                          color: Colors.white70, fontSize: 20),
                                    ),
                                    Text(
                                      response.artist.stats.listeners,
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
                                      SizedBox(height: 410.0),
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
                                                  response.artist.tags.tag),
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
                                    HISTORY,
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
                            child: Text(
                              response.artist.bio.content,
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        ],
                      );
                    }
                  })
            ],
          ),
        ));
  }

  List<Widget> buildTagsWidgets(List<ArtistTag> tags) {
    List<Widget> list = new List<Widget>();
    for (var i = 0; i < tags.length; i++) {
      var widget = Chip(
        label: Text(tags[i].name.toUpperCase()),
      );
      list.add(widget);
    }
    return list;
  }

  Widget _platformProgressIndicator() {
    if (Platform.isAndroid) {
      return CircularProgressIndicator();
    } else {
      return CupertinoActivityIndicator();
    }
  }
}
