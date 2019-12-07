class ResponseTrack {
  Track track;

  ResponseTrack({this.track});

  ResponseTrack.fromJson(Map<String, dynamic> json) {
    track = json['track'] != null ? new Track.fromJson(json['track']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.track != null) {
      data['track'] = this.track.toJson();
    }
    return data;
  }
}

class Track {
  String name;
  String url;
  String duration;
  Streamable streamable;
  String listeners;
  String playcount;
  TrackArtist artist;
  Album album;
  Toptags toptags;

  Track(
      {this.name,
        this.url,
        this.duration,
        this.streamable,
        this.listeners,
        this.playcount,
        this.artist,
        this.album,
        this.toptags});

  Track.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    url = json['url'];
    duration = json['duration'];
    streamable = json['streamable'] != null
        ? new Streamable.fromJson(json['streamable'])
        : null;
    listeners = json['listeners'];
    playcount = json['playcount'];
    artist =
    json['artist'] != null ? new TrackArtist.fromJson(json['artist']) : null;
    album = json['album'] != null ? new Album.fromJson(json['album']) : null;
    toptags =
    json['toptags'] != null ? new Toptags.fromJson(json['toptags']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['url'] = this.url;
    data['duration'] = this.duration;
    if (this.streamable != null) {
      data['streamable'] = this.streamable.toJson();
    }
    data['listeners'] = this.listeners;
    data['playcount'] = this.playcount;
    if (this.artist != null) {
      data['artist'] = this.artist.toJson();
    }
    if (this.album != null) {
      data['album'] = this.album.toJson();
    }
    if (this.toptags != null) {
      data['toptags'] = this.toptags.toJson();
    }
    return data;
  }
}

class Streamable {
  String text;
  String fulltrack;

  Streamable({this.text, this.fulltrack});

  Streamable.fromJson(Map<String, dynamic> json) {
    text = json['#text'];
    fulltrack = json['fulltrack'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['#text'] = this.text;
    data['fulltrack'] = this.fulltrack;
    return data;
  }
}

class TrackArtist {
  String name;
  String url;

  TrackArtist({this.name, this.url});

  TrackArtist.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['url'] = this.url;
    return data;
  }
}

class Album {
  String artist;
  String title;
  String url;
  List<ImageTrack> image;

  Album({this.artist, this.title, this.url, this.image});

  Album.fromJson(Map<String, dynamic> json) {
    artist = json['artist'];
    title = json['title'];
    url = json['url'];
    if (json['image'] != null) {
      image = new List<ImageTrack>();
      json['image'].forEach((v) {
        image.add(new ImageTrack.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['artist'] = this.artist;
    data['title'] = this.title;
    data['url'] = this.url;
    if (this.image != null) {
      data['image'] = this.image.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ImageTrack {
  String text;
  String size;

  ImageTrack({this.text, this.size});

  ImageTrack.fromJson(Map<String, dynamic> json) {
    text = json['#text'];
    size = json['size'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['#text'] = this.text;
    data['size'] = this.size;
    return data;
  }
}

class Toptags {
  List<TrackTag> tag;

  Toptags({this.tag});

  Toptags.fromJson(Map<String, dynamic> json) {
    if (json['tag'] != null) {
      tag = new List<TrackTag>();
      json['tag'].forEach((v) {
        tag.add(new TrackTag.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.tag != null) {
      data['tag'] = this.tag.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TrackTag {
  String name;
  String url;

  TrackTag({this.name, this.url});

  TrackTag.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['url'] = this.url;
    return data;
  }
}