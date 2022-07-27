import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';

class RestaurantAds extends StatefulWidget {
  @override
  _RestaurantAdsState createState() => _RestaurantAdsState();
}

class _RestaurantAdsState extends State<RestaurantAds> {
  // ignore: non_constant_identifier_names
  Widget image_carousel = new Container(
    height: 200,
    child: Carousel(
      boxFit: BoxFit.fill,
      images: [
        AssetImage('assets/Adlocale.jpg'),
        AssetImage('assets/Asushico.jpg'),
        AssetImage('assets/Adbigchefs.jpg'),
        AssetImage('assets/Admidpoint.jpg'),
        AssetImage('assets/Adtuzubiberi.jpg'),
      ],
      autoplay: false,
      //animationCurve: Curves.fastOutSlowIn,
      //animationDuration: Duration(milliseconds: 2000),
      dotSize: 4.0,
      indicatorBgPadding: 6.0,
      dotColor: Colors.grey,
      borderRadius: true,
    ),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0.0,
        title: Text.rich(
          TextSpan(
            style: TextStyle(
              fontFamily: 'Calibri',
              fontSize: 35,
              color: const Color(0xfff5f5f5),
            ),
            children: [
              TextSpan(
                text: 'F',
              ),
              TextSpan(
                text: 'E',
                style: TextStyle(
                  color: const Color(0xffa11f1f),
                ),
              ),
              TextSpan(
                text: 'ASTER',
              ),
            ],
          ),
          textAlign: TextAlign.left,
        ),
      ),
      body: ListView(children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 12),
          child: Text("Kampanyalar",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
              )),
        ),
        image_carousel,
        Padding(
          padding: EdgeInsets.only(top: 8, bottom: 6),
          child: Text("Öne Çıkanlar",
              textAlign: TextAlign.center, style: TextStyle(fontSize: 24)),
        ),
        RestaurantList(),
        Padding(
          padding: const EdgeInsets.only(right: 5.0),
          child: InkWell(
            child: Text(
              "Tümünü Gör >",
              textAlign: TextAlign.end,
              style:
                  TextStyle(fontSize: 18, decoration: TextDecoration.underline),
            ),
            onTap: () {},
          ),
        ),
      ]),
    );
  }
}

class RestaurantList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 215,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          RestaurantListView(img_location: 'assets/muranos.jpg'),
          RestaurantListView(img_location: 'assets/hunger.jpg'),
          RestaurantListView(img_location: 'assets/cookshop.jpg'),
          RestaurantListView(img_location: 'assets/locale.jpg'),
          RestaurantListView(img_location: 'assets/reddragon.jpg')
        ],
      ),
    );
  }
}

class RestaurantListView extends StatelessWidget {
  final String img_location;
  // ignore: non_constant_identifier_names
  RestaurantListView({this.img_location});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      child:
          //ClipRRect(
          //  borderRadius: BorderRadius.all(Radius.circular(10.0)),

          InkWell(
        onTap: () {},
        child: ListTile(
          title: Image.asset(img_location),
        ),
      ),
    );
  }
}
