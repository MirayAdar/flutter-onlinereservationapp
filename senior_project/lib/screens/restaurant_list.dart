import 'package:carousel_pro/carousel_pro.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:senior_project/controllers/campaign_controller.dart';
import 'package:senior_project/controllers/restaurant_controller.dart';
import 'package:senior_project/models/campaign_model.dart';
import 'package:senior_project/models/restaurant_model.dart';
import 'package:senior_project/screens/restaurant_info.dart';

class RestaurantList extends StatefulWidget {
  @override
  _RestaurantListState createState() => _RestaurantListState();
}

class _RestaurantListState extends State<RestaurantList> {
  //with SingleTickerProviderStateMixin {
  // TextEditingController editingController = TextEditingController();
  //TabController controller;

  var listNames = [
    "Murano's",
    "Red Dragon",
    "Tuzu Biberi",
    "The Hunger",
    "Pizza Locale",
    "Big Chefs",
    "Sushico",
    "Midpoint"
  ];
  var listDesc = [
    "Min: ₺25,00 ",
    "Min: ₺35,00 ",
    "Min: ₺60,00 ",
    "Min: ₺45,00 ",
    "Min: ₺30,00 ",
    "Min: ₺60,00 ",
    "Min: ₺70,00 ",
    "Min: ₺40,00 "
  ];
  var listImg = [
    "assets/muranoslogo.png",
    "assets/reddragonlogo.png",
    "assets/tuzubiberilogo.png",
    "assets/hungerlogo.png",
    "assets/pizzalocalelogo.png",
    "assets/bigchefslogo.png",
    "assets/sushicologo.png",
    "assets/midpointlogo.png"
  ];
  List<QueryDocumentSnapshot> docs = [];
  List<QueryDocumentSnapshot> campaignDocs = [];

  getRestaurantsFromDb() async {
    RestaurantController().getRestaurants().then((value) {
      print(value[0]);
      setState(() {
        docs = value;
      });
    });
  }

  getCampaignsFromDb() async {
    await CampaignController().getCampaigns().then((value) {
      print(value[0]);
      setState(() {
        campaignDocs = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getRestaurantsFromDb();
    getCampaignsFromDb();
  }

  @override
  Widget build(BuildContext context) {
    //  double width = MediaQuery.of(context).size.width * 0.6;
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
        body: docs.isEmpty
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    ListView(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 12),
                            child: Text("Kampanyalar",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 24,
                                )),
                          ),
                          SizedBox(
                            height: 24,
                          ),
                          campaignDocs.length == 0
                              ? CircularNotchedRectangle()
                              : Container(
                                  height: 200,
                                  child: CarouselSlider.builder(
                                      options: CarouselOptions(
                                        height: 400,
                                        aspectRatio: 16 / 9,
                                        viewportFraction: 0.8,
                                        initialPage: 0,
                                        enableInfiniteScroll: true,
                                        reverse: false,
                                        autoPlay: true,
                                        autoPlayInterval: Duration(seconds: 3),
                                        autoPlayAnimationDuration:
                                            Duration(milliseconds: 800),
                                        autoPlayCurve: Curves.fastOutSlowIn,
                                        enlargeCenterPage: true,
                                        scrollDirection: Axis.horizontal,
                                      ),
                                      itemCount: campaignDocs.length,
                                      itemBuilder: (context, index, int) {
                                        return Container(
                                            child: Image.network(
                                                campaignDocs[index]
                                                    .get("campaignUrl")));
                                      }),
                                )
                        ]),
                    Container(
                      child: Center(
                        child: Text(
                          "Tüm Restoranlar",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 27,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    //  Divider(color: Colors.black),
                    ListView.builder(
                        itemCount: docs.length,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return docs[index].get("restType") == "Orderable"
                              ? GestureDetector(
                                  onTap: () {
                                    Restaurant a =
                                        Restaurant.fromMap(docs[index].data());
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => RestaurantInfo(
                                                restaurant: a,
                                              )),
                                    );
                                  },
                                  child: Card(
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          width: 100,
                                          height: 100,
                                          child: docs[index].get("logoUrl") ==
                                                  null
                                              ? SizedBox()
                                              : Image.network(
                                                  docs[index].get("logoUrl")),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                docs[index].get("name") ?? "",
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 19,
                                                  color: Colors.black87,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Container(
                                                height: 30,
                                                child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        docs[index]
                                                                .get("price") +
                                                            "₺",
                                                        maxLines: 3,
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            color: Colors
                                                                .grey[500]),
                                                      ),
                                                    ]),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              : SizedBox();
                        }),
                  ],
                ),
              ));
  }
}
