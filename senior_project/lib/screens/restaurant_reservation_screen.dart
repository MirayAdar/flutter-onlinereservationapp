import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:senior_project/controllers/restaurant_controller.dart';
import 'package:senior_project/models/restaurant_model.dart';
import 'package:senior_project/screens/photo_preview_screen.dart';
import 'package:senior_project/screens/reservation_step_screen.dart';
import 'package:senior_project/services/utils.dart';

class RestaurantReservationScreen extends StatefulWidget {
  RestaurantReservationScreen({Key key, this.restaurant}) : super(key: key);
  Restaurant restaurant;
  @override
  _RestaurantReservationScreenState createState() =>
      _RestaurantReservationScreenState();
}

class _RestaurantReservationScreenState
    extends State<RestaurantReservationScreen> {
  bool isLoading = true;
  Map<String, dynamic> docData;
  DateTime selectedReservationDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  Future<Map<String, dynamic>> getCurrentDays({DateTime date}) async {
    setState(() {
      isLoading = true;
    });
    DateTime selectedDate;
    if (date == null) {
      selectedDate = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      );
    } else {
      selectedDate = date;
    }
    print(selectedReservationDate);
    docData =
        await RestaurantController().getTables(widget.restaurant, selectedDate);
    print("docData");
    print(docData);
    setState(() {
      isLoading = false;
    });
    return docData;
  }

  reserveBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: new Icon(Icons.photo),
                title: new Text('Photo'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: new Icon(Icons.music_note),
                title: new Text('Music'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: new Icon(Icons.videocam),
                title: new Text('Video'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: new Icon(Icons.share),
                title: new Text('Share'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  selectDateMethod() async {
    setState(() {
      isLoading = true;
    });
    DateTime newDate = await showDatePicker(
        context: context,
        initialDate: selectedReservationDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day + 7));

    if (newDate != null &&
        newDate !=
            DateTime(selectedReservationDate.year,
                selectedReservationDate.month, selectedReservationDate.day)) {
      print(newDate.toString());
      setState(() {
        selectedReservationDate = newDate;
      });
      docData = await getCurrentDays(date: selectedReservationDate);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getCurrentDays();
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons

    Widget continueButton = FlatButton(
      child: Text("Okay"),
      color: Colors.red,
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Table is Full!"),
      content: Text(
          "Sorry, this table has already been reserved. You can look for the tables colored in green"),
      actions: [
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 40),
            child: Column(
              children: [
                Text("Reservation Screen",
                    style:
                        TextStyle(fontWeight: FontWeight.w800, fontSize: 29)),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red, // background
                      onPrimary: Colors.white, // foreground
                    ),
                    onPressed: selectDateMethod,
                    child: Text("Date : " +
                        selectedReservationDate.year.toString() +
                        "-" +
                        selectedReservationDate.month.toString() +
                        "-" +
                        selectedReservationDate.day.toString())),
                InkWell(
                  onTap: () async {
                    pushNewScreen(context,
                        screen: PhotoPreviewScreen(widget.restaurant.planUrl),
                        withNavBar: false);
                  },
                  child: SizedBox(
                      height: 400,
                      child: Image.network(widget.restaurant.planUrl)),
                ),
                isLoading == true
                    ? CircularProgressIndicator()
                    : GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 70,
                            childAspectRatio: 2 / 2,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20),
                        itemCount: widget.restaurant.noOfTable,
                        itemBuilder: (BuildContext ctx, index) {
                          return InkWell(
                            onTap: () {
                              if (docData["dates"]
                                          [dateString(selectedReservationDate)]
                                      [index]["status"] ==
                                  "Full") {
                                showAlertDialog(context);
                              } else {
                                pushNewScreen(context,
                                    screen: ReservationStepScreen(
                                        widget.restaurant,
                                        selectedReservationDate,
                                        index + 1,
                                        docData));
                              }
                            },
                            child: Container(
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(Icons.table_rows),
                                  Text((index + 1).toString(),
                                      style: TextStyle(fontSize: 20)),
                                ],
                              ),
                              decoration: BoxDecoration(
                                  color: docData == null
                                      ? Colors.amber
                                      : docData["dates"][dateString(
                                                      selectedReservationDate)]
                                                  [index]["status"] ==
                                              "Empty"
                                          ? Colors.green
                                          : Colors.amber,
                                  borderRadius: BorderRadius.circular(15)),
                            ),
                          );
                        }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
