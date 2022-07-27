import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:senior_project/models/restaurant_model.dart';
import 'package:senior_project/screens/payment_main_page.dart';
import 'package:senior_project/services/utils.dart';

class ReservationStepScreen extends StatefulWidget {
  ReservationStepScreen(
      this.restaurant, this.reservationDate, this.tableNo, this.doc);
  Restaurant restaurant;
  int tableNo;
  Map<String, dynamic> doc;
  DateTime reservationDate;

  @override
  _ReservationStepScreenState createState() => _ReservationStepScreenState();
}

class _ReservationStepScreenState extends State<ReservationStepScreen> {
  Color gradientStart = Colors.red[700]; //Change start gradient color here
  Color gradientEnd = Colors.black87.withOpacity(0.8);
  int initialCount = 1;

  reserve() async {
    String id = widget.doc["id"];
    String date;

    print(date);
    print(widget.doc);
    print(id);
    print("removed");

    date = widget.doc["dates"].keys.toList()[0];
    Map<String, dynamic> usersUpdate = {};
    print(widget.doc["dates"]);
    List<dynamic> dyno =
        widget.doc["dates"][dateString(widget.reservationDate)].toList();
    dyno[widget.tableNo - 1] = {
      "status": "Full",
      "userId": FirebaseAuth.instance.currentUser.uid
    };
    print("dyno");
    print(dyno);
    usersUpdate["dates." + date] = dyno;
    print(usersUpdate);

    await FirebaseFirestore.instance
        .collection('reservations')
        .doc(id)
        .update({"dates." + dateString(widget.reservationDate): dyno});
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
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: new BoxDecoration(
                gradient: new LinearGradient(
                    colors: [gradientStart, gradientEnd],
                    begin: const FractionalOffset(0.5, 0.0),
                    end: const FractionalOffset(0.0, 0.5),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 25),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Complete your Reservation",
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 24,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Restaurant Name:",
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              widget.restaurant.name,
                              maxLines: 1,
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Table Number:",
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              widget.tableNo.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Arrival Time:",
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              "20:30",
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "People Count",
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            Row(
                              children: [
                                initialCount > 1
                                    ? IconButton(
                                        icon: Icon(Icons.remove),
                                        onPressed: () {
                                          setState(() {
                                            initialCount = initialCount - 1;
                                          });
                                        },
                                      )
                                    : SizedBox(),
                                Text(
                                  initialCount.toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                                initialCount < widget.restaurant.noPerTable
                                    ? IconButton(
                                        icon: Icon(Icons.add),
                                        onPressed: () {
                                          setState(() {
                                            initialCount = initialCount + 1;
                                          });
                                        },
                                      )
                                    : SizedBox(
                                        width: 15,
                                      ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 50,
              right: 50,
              bottom: 50,
              child: SizedBox(
                width: 200,
                child: ElevatedButton(
                  child: Text("Go to Payment"),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Payment(true, reserve)),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
