import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ScrobblesFragment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      body: Lists(),
    );
  }
}

class Item {
  final String title;
  final String catagory;
  final String place;
  final String ratings;
  final String discount;
  final String image;

  Item(
      {this.title,
      this.catagory,
      this.place,
      this.ratings,
      this.discount,
      this.image});
}

class Lists extends StatelessWidget {
  final List<Item> _data = [
    Item(
        title: 'Our Hollow, Our Home',
        catagory: "Karmadillo",
        place: "10 Nov 2019, 10:12",
        image:
            "https://lastfm.freetls.fastly.net/i/u/300x300/4f97ae3bfe3f87798d7a743e32ba9437.jpg"),
    Item(
        title: 'Our Hollow, Our Home',
        catagory: "Karmadillo",
        place: "10 Nov 2019, 10:12",
        image:
        "https://lastfm.freetls.fastly.net/i/u/300x300/4f97ae3bfe3f87798d7a743e32ba9437.jpg"),
    Item(
        title: 'Our Hollow, Our Home',
        catagory: "Karmadillo",
        place: "10 Nov 2019, 10:12",
        image:
        "https://lastfm.freetls.fastly.net/i/u/300x300/4f97ae3bfe3f87798d7a743e32ba9437.jpg"),
    Item(
        title: 'Our Hollow, Our Home',
        catagory: "Karmadillo",
        place: "10 Nov 2019, 10:12",
        image:
        "https://lastfm.freetls.fastly.net/i/u/300x300/4f97ae3bfe3f87798d7a743e32ba9437.jpg"),
    Item(
        title: 'Our Hollow, Our Home',
        catagory: "Karmadillo",
        place: "10 Nov 2019, 10:12",
        image:
        "https://lastfm.freetls.fastly.net/i/u/300x300/4f97ae3bfe3f87798d7a743e32ba9437.jpg"),
    Item(
        title: 'Our Hollow, Our Home',
        catagory: "Karmadillo",
        place: "10 Nov 2019, 10:12",
        image:
        "https://lastfm.freetls.fastly.net/i/u/300x300/4f97ae3bfe3f87798d7a743e32ba9437.jpg"),
    Item(
        title: 'Our Hollow, Our Home',
        catagory: "Karmadillo",
        place: "10 Nov 2019, 10:12",
        image:
        "https://lastfm.freetls.fastly.net/i/u/300x300/4f97ae3bfe3f87798d7a743e32ba9437.jpg"),
    Item(
        title: 'Our Hollow, Our Home',
        catagory: "Karmadillo",
        place: "10 Nov 2019, 10:12",
        image:
        "https://lastfm.freetls.fastly.net/i/u/300x300/4f97ae3bfe3f87798d7a743e32ba9437.jpg"),
    Item(
        title: 'Our Hollow, Our Home',
        catagory: "Karmadillo",
        place: "10 Nov 2019, 10:12",
        image:
        "https://lastfm.freetls.fastly.net/i/u/300x300/4f97ae3bfe3f87798d7a743e32ba9437.jpg"),
    Item(
        title: 'Our Hollow, Our Home',
        catagory: "Karmadillo",
        place: "10 Nov 2019, 10:12",
        image:
        "https://lastfm.freetls.fastly.net/i/u/300x300/4f97ae3bfe3f87798d7a743e32ba9437.jpg"),
    Item(
        title: 'Our Hollow, Our Home',
        catagory: "Karmadillo",
        place: "10 Nov 2019, 10:12",
        image:
        "https://lastfm.freetls.fastly.net/i/u/300x300/4f97ae3bfe3f87798d7a743e32ba9437.jpg"),
    Item(
        title: 'Our Hollow, Our Home',
        catagory: "Karmadillo",
        place: "10 Nov 2019, 10:12",
        image:
        "https://lastfm.freetls.fastly.net/i/u/300x300/4f97ae3bfe3f87798d7a743e32ba9437.jpg"),
    Item(
        title: 'Our Hollow, Our Home',
        catagory: "Karmadillo",
        place: "10 Nov 2019, 10:12",
        image:
        "https://lastfm.freetls.fastly.net/i/u/300x300/4f97ae3bfe3f87798d7a743e32ba9437.jpg"),
    Item(
        title: 'Our Hollow, Our Home',
        catagory: "Karmadillo",
        place: "10 Nov 2019, 10:12",
        image:
        "https://lastfm.freetls.fastly.net/i/u/300x300/4f97ae3bfe3f87798d7a743e32ba9437.jpg"),
    Item(
        title: 'Our Hollow, Our Home',
        catagory: "Karmadillo",
        place: "10 Nov 2019, 10:12",
        image:
        "https://lastfm.freetls.fastly.net/i/u/300x300/4f97ae3bfe3f87798d7a743e32ba9437.jpg"),
    Item(
        title: 'Our Hollow, Our Home',
        catagory: "Karmadillo",
        place: "10 Nov 2019, 10:12",
        image:
        "https://lastfm.freetls.fastly.net/i/u/300x300/4f97ae3bfe3f87798d7a743e32ba9437.jpg"),
    Item(
        title: 'Our Hollow, Our Home',
        catagory: "Karmadillo",
        place: "10 Nov 2019, 10:12",
        image:
        "https://lastfm.freetls.fastly.net/i/u/300x300/4f97ae3bfe3f87798d7a743e32ba9437.jpg"),
    Item(
        title: 'Our Hollow, Our Home',
        catagory: "Karmadillo",
        place: "10 Nov 2019, 10:12",
        image:
        "https://lastfm.freetls.fastly.net/i/u/300x300/4f97ae3bfe3f87798d7a743e32ba9437.jpg"),
    Item(
        title: 'Our Hollow, Our Home',
        catagory: "Karmadillo",
        place: "10 Nov 2019, 10:12",
        image:
        "https://lastfm.freetls.fastly.net/i/u/300x300/4f97ae3bfe3f87798d7a743e32ba9437.jpg"),
    Item(
        title: 'Our Hollow, Our Home',
        catagory: "Karmadillo",
        place: "10 Nov 2019, 10:12",
        image:
        "https://lastfm.freetls.fastly.net/i/u/300x300/4f97ae3bfe3f87798d7a743e32ba9437.jpg"),
    Item(
        title: 'Our Hollow, Our Home',
        catagory: "Karmadillo",
        place: "10 Nov 2019, 10:12",
        image:
        "https://lastfm.freetls.fastly.net/i/u/300x300/4f97ae3bfe3f87798d7a743e32ba9437.jpg"),
    Item(
        title: 'Our Hollow, Our Home',
        catagory: "Karmadillo",
        place: "10 Nov 2019, 10:12",
        image:
        "https://lastfm.freetls.fastly.net/i/u/300x300/4f97ae3bfe3f87798d7a743e32ba9437.jpg"),
    Item(
        title: 'Our Hollow, Our Home',
        catagory: "Karmadillo",
        place: "10 Nov 2019, 10:12",
        image:
        "https://lastfm.freetls.fastly.net/i/u/300x300/4f97ae3bfe3f87798d7a743e32ba9437.jpg"),
    Item(
        title: 'Our Hollow, Our Home',
        catagory: "Karmadillo",
        place: "10 Nov 2019, 10:12",
        image:
        "https://lastfm.freetls.fastly.net/i/u/300x300/4f97ae3bfe3f87798d7a743e32ba9437.jpg"),

  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(3),
      itemCount: _data.length,
      itemBuilder: (BuildContext context, int index) {
        Item item = _data[index];
        return Card(
          color: Colors.black38,
          elevation: 5,
          child: Row(
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
                          image: CachedNetworkImageProvider(item.image),
                          fit: BoxFit.cover))),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      item.title,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 17),
                    ),
                    Text(
                      item.catagory,
                      style: TextStyle(fontSize: 14, color: Colors.white70),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      item.place,
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
