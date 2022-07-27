import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:senior_project/controllers/menu_controller.dart';
import 'package:senior_project/models/order_model.dart';
import 'package:senior_project/models/restaurant_model.dart';
import 'package:senior_project/screens/reservation_completed_screen.dart';

class Payment extends StatefulWidget {
  Payment(
    this.isForReserve,
    this.payFunc,
  );
  Function payFunc;

  bool isForReserve;

  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  Color gradientStart = Colors.red[700]; //Change start gradient color here
  Color gradientEnd = Colors.black87.withOpacity(0.8);

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: Container(
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
        child: Center(
          child: Container(
            height: 350,
            width: 350,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(top: 20),
                      alignment: Alignment.topCenter,
                      child: Text(
                        "ÖDEME",
                        style: TextStyle(
                          fontSize: 30,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            width: 50,
                            height: 50,
                            margin: EdgeInsets.only(bottom: 40),
                            alignment: Alignment.center,
                            child: Text(
                              "1",
                              style:
                                  TextStyle(fontSize: 30, color: Colors.white),
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              border: Border.all(color: Colors.black),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            width: 50,
                            margin: EdgeInsets.only(left: 10, bottom: 40),
                            child: Divider(
                              height: 20,
                              thickness: 4,
                              color: Colors.black38,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            width: 50,
                            height: 50,
                            margin: EdgeInsets.only(bottom: 40),
                            alignment: Alignment.center,
                            child: Text(
                              "2",
                              style:
                                  TextStyle(fontSize: 30, color: Colors.black),
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.black),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(bottom: 40),
                            child: Divider(
                              height: 20,
                              thickness: 4,
                              color: Colors.black38,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            width: 50,
                            height: 50,
                            margin: EdgeInsets.only(bottom: 40),
                            alignment: Alignment.center,
                            child: Text(
                              "3",
                              style:
                                  TextStyle(fontSize: 30, color: Colors.black),
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.black),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                            alignment: Alignment.centerRight,
                            width: 70,
                            margin: EdgeInsets.only(bottom: 40),
                            child: Text(
                              "     Kart Numarası: ",
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            )),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(right: 20, bottom: 40),
                            width: 40,
                            child: TextFormField(
                              decoration: new InputDecoration(
                                fillColor: Colors.white,
                                border: new OutlineInputBorder(
                                  // borderRadius: new BorderRadius.,
                                  borderSide: new BorderSide(),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                            alignment: Alignment.centerRight,
                            margin: EdgeInsets.only(bottom: 40),
                            width: 70,
                            child: Text(
                              "SKT    : ",
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            )),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(bottom: 40, right: 136),
                            width: 70,
                            height: 50,
                            child: TextFormField(
                              decoration: new InputDecoration(
                                fillColor: Colors.white,
                                border: new OutlineInputBorder(
                                  borderSide: new BorderSide(),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                            width: 70,
                            margin: EdgeInsets.only(bottom: 40),
                            alignment: Alignment.centerRight,
                            child: Text(
                              "CVV    : ",
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            )),
                        Expanded(
                          child: Container(
                            width: 40,
                            margin: EdgeInsets.only(bottom: 40),
                            child: TextFormField(
                              decoration: new InputDecoration(
                                fillColor: Colors.white,
                                border: new OutlineInputBorder(
                                  // borderRadius: new BorderRadius.,
                                  borderSide: new BorderSide(),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerRight,
                            height: 40,
                            width: 10,
                            margin:
                                EdgeInsets.only(left: 30, right: 20, top: 20),
                            child: FlatButton(
                              onPressed: () async {
                                setState(() {
                                  isLoading = true;
                                });
                                await widget.payFunc();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ReservationCompletedScreen(
                                            isOrder:
                                                widget.isForReserve ?? false,
                                          )),
                                );
                              },
                              color: Colors.blue,
                              textColor: Colors.white,
                              padding: EdgeInsets.all(10.0),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      new BorderRadius.circular(60.0)),
                              child: Row(
                                children: [
                                  Text("İlerle"),
                                  Icon(Icons.arrow_forward),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
