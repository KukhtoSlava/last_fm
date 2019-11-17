class ResponseAuth {
  Session session;

  ResponseAuth({this.session});

  ResponseAuth.fromJson(Map<String, dynamic> json) {
    session =
        json['session'] != null ? new Session.fromJson(json['session']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.session != null) {
      data['session'] = this.session.toJson();
    }
    return data;
  }
}

class Session {
  int subscriber;
  String name;
  String key;

  Session({this.subscriber, this.name, this.key});

  Session.fromJson(Map<String, dynamic> json) {
    subscriber = json['subscriber'];
    name = json['name'];
    key = json['key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subscriber'] = this.subscriber;
    data['name'] = this.name;
    data['key'] = this.key;
    return data;
  }
}
