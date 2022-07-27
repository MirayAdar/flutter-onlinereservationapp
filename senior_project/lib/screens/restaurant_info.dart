import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:senior_project/models/restaurant_model.dart';
import 'package:senior_project/screens/restaurant_menu_screen.dart';
import 'package:senior_project/screens/restaurant_reservation_screen.dart';

class RestaurantInfo extends StatefulWidget {
  RestaurantInfo({Key key, this.restaurant, this.isReservePurpose})
      : super(key: key);
  Restaurant restaurant;
  bool isReservePurpose;
  @override
  _RestaurantInfoState createState() => _RestaurantInfoState();
}

class _RestaurantInfoState extends State<RestaurantInfo> {
  CarouselSlider carouselSlider;
  int _current = 0;

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

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
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 50.0, top: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.restaurant.name,
                  style: TextStyle(
                      fontSize: 24,
                      fontFamily: 'Calibri',
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                CarouselSlider(
                  options: CarouselOptions(
                    height: 250,
                    initialPage: 0,
                    enlargeCenterPage: true,
                    autoPlay: true,
                    reverse: false,
                    enableInfiniteScroll: true,
                    autoPlayInterval: Duration(seconds: 2),
                    autoPlayAnimationDuration: Duration(milliseconds: 2000),
                    scrollDirection: Axis.horizontal,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _current = index;
                      });
                    },
                  ),
                  items: widget.restaurant.detailUrls.map((imgAssets) {
                    return Builder(builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(color: Colors.redAccent[200]),
                        child: Image.network(
                          imgAssets,
                          fit: BoxFit.fill,
                        ),
                      );
                    });
                  }).toList(),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:
                      map<Widget>(widget.restaurant.detailUrls, (index, url) {
                    return Container(
                      width: 20,
                      height: 10,
                      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 2),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _current == index
                              ? Colors.red[200]
                              : Colors.grey[300]),
                    );
                  }),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 14),
                  child: Text(
                    widget.restaurant.details,
                    style: TextStyle(
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                        fontFamily: 'Calibri'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: widget.isReservePurpose == true
          ? Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: RaisedButton(
                child: Text(
                  "Rezervasyon Ekranı > ",
                  style: TextStyle(color: Colors.white, fontFamily: 'Calibri'),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(15)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RestaurantReservationScreen(
                              restaurant: widget.restaurant,
                            )),
                  );
                },
                color: const Color(0xffa11f1f),
              ),
            )
          : Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: RaisedButton(
                child: Text(
                  "Menü Seçimi > ",
                  style: TextStyle(color: Colors.white, fontFamily: 'Calibri'),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(15)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RestaurantMenuScreen(
                              restaurant: widget.restaurant,
                            )),
                  );
                },
                color: const Color(0xffa11f1f),
              ),
            ),
    );
  }
}
