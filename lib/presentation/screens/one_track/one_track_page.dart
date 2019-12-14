import 'dart:io';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:last_fm/constants.dart';
import 'package:last_fm/data/models/response_track.dart';
import 'package:last_fm/data/repository.dart';
import 'package:last_fm/presentation/widgets/ui_helper.dart';

import 'one_track_bloc.dart';

class TrackPage extends StatefulWidget {
  String artist;
  String song;

  TrackPage({Key key, @required this.artist, @required this.song})
      : super(key: key);

  @override
  createState() {
    return TrackPageState(artist, song);
  }
}

class TrackPageState extends State {
  String _artist;
  String _song;

  TrackPageState(String artist, String song) {
    this._artist = artist;
    this._song = song;
  }

  OneTrackBloc _oneTrackBloc = OneTrackBloc(BlocProvider.getBloc<Repository>());
  UICommonComponent _uiCommonComponent =
      BlocProvider.getBloc<UICommonComponent>();

  @override
  Widget build(BuildContext context) {
    var image = EMPTY_PICTURE;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        title: Text(_song),
      ),
      body: SingleChildScrollView(
        child: StreamBuilder(
            stream: _oneTrackBloc.getTrack(_artist, _song),
            builder: (context, snappShot) {
              if (snappShot != null &&
                  snappShot.connectionState == ConnectionState.waiting) {
                return Stack(
                  children: <Widget>[
                    Container(
                      height: 400,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: CachedNetworkImageProvider(image),
                              fit: BoxFit.cover)),
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 410.0, bottom: 20),
                        child: Center(child: _platformProgressIndicator()))
                  ],
                );
              }
              if ((snappShot != null && !snappShot.hasData)) {
                return Container(
                  height: 400,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: CachedNetworkImageProvider(image),
                          fit: BoxFit.cover)),
                );
              } else {
                ResponseTrack response = snappShot.data as ResponseTrack;
                var image = response.track.album != null
                    ? response.track.album.image[3].text
                    : EMPTY_PICTURE;
                return Stack(
                  children: <Widget>[
                    Container(
                      height: 400,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: CachedNetworkImageProvider(image),
                              fit: BoxFit.cover)),
                    ),
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
                                response.track.playcount,
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
                                response.track.listeners,
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
                                        runAlignment: WrapAlignment.center,
                                        alignment: WrapAlignment.center,
                                        spacing: 3.0,
                                        children: buildTagsWidgets(
                                            response.track.toptags.tag),
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
                              _artist,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 30),
                            ),
                            Divider(
                              color: Colors.black,
                            ),
                          ],
                        )),
                    Container(
                      margin: EdgeInsets.only(top: 570.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            _song,
                            style: TextStyle(color: Colors.white, fontSize: 24),
                          ),
                          Divider(
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                    StreamBuilder(
                        stream:
                            _oneTrackBloc.checkYouTubeLink(response.track.url),
                        builder: (context, snappShot) {
                          if ((snappShot != null && !snappShot.hasData)) {
                            return Container();
                          } else {
                            if (snappShot.data != "") {
                              return GestureDetector(
                                  onTap: () {
                                    _uiCommonComponent.openUrl(
                                        snappShot.data, context);
                                  },
                                  child: Container(
                                      margin: EdgeInsets.only(top: 620.0),
                                      child: Center(
                                          child: Container(
                                              width: 100,
                                              height: 100,
                                              child: Image.asset(
                                                  'assets/images/youtube.png')))));
                            } else {
                              return Container();
                            }
                          }
                        })
                  ],
                );
              }
            }),
      ),
    );
  }

  List<Widget> buildTagsWidgets(List<TrackTag> tags) {
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
