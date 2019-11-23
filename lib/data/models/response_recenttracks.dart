class ResponseRecentTracks {
  Recenttracks recenttracks;

  ResponseRecentTracks({this.recenttracks});

  ResponseRecentTracks.fromJson(Map<String, dynamic> json) {
    recenttracks = json['recenttracks'] != null
        ? new Recenttracks.fromJson(json['recenttracks'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.recenttracks != null) {
      data['recenttracks'] = this.recenttracks.toJson();
    }
    return data;
  }
}

class Recenttracks {
  Attr attr;
  List<Track> track;

  Recenttracks({this.attr, this.track});

  Recenttracks.fromJson(Map<String, dynamic> json) {
    attr = json['@attr'] != null ? new Attr.fromJson(json['@attr']) : null;
    if (json['track'] != null) {
      track = new List<Track>();
      json['track'].forEach((v) {
        track.add(new Track.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.attr != null) {
      data['@attr'] = this.attr.toJson();
    }
    if (this.track != null) {
      data['track'] = this.track.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Attr {
  String page;
  String perPage;
  String user;
  String total;
  String totalPages;

  Attr({this.page, this.perPage, this.user, this.total, this.totalPages});

  Attr.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    perPage = json['perPage'];
    user = json['user'];
    total = json['total'];
    totalPages = json['totalPages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page'] = this.page;
    data['perPage'] = this.perPage;
    data['user'] = this.user;
    data['total'] = this.total;
    data['totalPages'] = this.totalPages;
    return data;
  }
}

class Track {
  Artist artist;
  Artist album;
  List<Image> image;
  String streamable;
  Date date;
  String url;
  String name;
  String mbid;

  Track(
      {this.artist,
      this.album,
      this.image,
      this.streamable,
      this.date,
      this.url,
      this.name,
      this.mbid});

  Track.fromJson(Map<String, dynamic> json) {
    artist =
        json['artist'] != null ? new Artist.fromJson(json['artist']) : null;
    album = json['album'] != null ? new Artist.fromJson(json['album']) : null;
    if (json['image'] != null) {
      image = new List<Image>();
      json['image'].forEach((v) {
        image.add(new Image.fromJson(v));
      });
    }
    streamable = json['streamable'];
    date = json['date'] != null ? new Date.fromJson(json['date']) : Date();
    url = json['url'];
    name = json['name'];
    mbid = json['mbid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.artist != null) {
      data['artist'] = this.artist.toJson();
    }
    if (this.album != null) {
      data['album'] = this.album.toJson();
    }
    if (this.image != null) {
      data['image'] = this.image.map((v) => v.toJson()).toList();
    }
    data['streamable'] = this.streamable;
    if (this.date != null) {
      data['date'] = this.date.toJson();
    }
    data['url'] = this.url;
    data['name'] = this.name;
    data['mbid'] = this.mbid;
    return data;
  }
}

class Artist {
  String mbid;
  String text;

  Artist({this.mbid, this.text});

  Artist.fromJson(Map<String, dynamic> json) {
    mbid = json['mbid'];
    text = json['#text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mbid'] = this.mbid;
    data['#text'] = this.text;
    return data;
  }
}

class Image {
  String size;
  String text;

  Image({this.size, this.text});

  Image.fromJson(Map<String, dynamic> json) {
    size = json['size'];
    text = json['#text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['size'] = this.size;
    data['#text'] = this.text;
    return data;
  }
}

class Date {
  String uts;
  String text;

  Date({this.uts, this.text});

  Date.fromJson(Map<String, dynamic> json) {
    uts = json['uts'];
    text = json['#text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uts'] = this.uts;
    data['#text'] = this.text;
    return data;
  }
}
