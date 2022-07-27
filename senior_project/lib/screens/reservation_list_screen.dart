import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:senior_project/controllers/restaurant_controller.dart';
import 'package:senior_project/models/restaurant_model.dart';
import 'package:senior_project/screens/restaurant_info.dart';

class ReservationListScreen extends StatefulWidget {
  ReservationListScreen({Key key}) : super(key: key);

  @override
  _ReservationListScreenState createState() => _ReservationListScreenState();
}

class _ReservationListScreenState extends State<ReservationListScreen> {
  List<Restaurant> docs = [];
  List<QueryDocumentSnapshot> dummy = [];
  getRestaurantsFromDb() async {
    dummy = await RestaurantController().getRestaurants();
    dummy.forEach((element) {
      print(element.get("restType") + element.get("name"));
      if (element.get("restType") != null) {
        if (element.get("restType") == "Reservable") {
          setState(() {
            docs.add(Restaurant.fromMap(element.data()));
          });
        }
      } else {
        docs.remove(element);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getRestaurantsFromDb();
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
        body: docs.isEmpty
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        child: Center(
                          child: Text(
                            "Tüm Restoranlar",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w800,
                              fontSize: 27,
                            ),
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
                            return GestureDetector(
                              onTap: () {
                                Restaurant a = docs[index];
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RestaurantInfo(
                                            restaurant: a,
                                            isReservePurpose: true,
                                          )),
                                );
                              },
                              child: Card(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      width: 100,
                                      height: 100,
                                      child: docs[index].logoUrl == null
                                          ? SizedBox()
                                          : Image.network(docs[index].logoUrl),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            docs[index].name ?? "",
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
                                                    "Total ${docs[index].noOfTable} Tables available",
                                                    maxLines: 3,
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color:
                                                            Colors.grey[500]),
                                                  ),
                                                ]),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }),
                    ],
                  ),
                ),
              ));
  }
}
