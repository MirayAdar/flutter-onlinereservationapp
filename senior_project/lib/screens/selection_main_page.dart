import 'package:flutter/material.dart';
import 'package:senior_project/screens/reservation_list_screen.dart';
import 'package:senior_project/screens/restaurant_list.dart';

class Selection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Card(
            margin: EdgeInsets.only(top: 100, bottom: 80),
            // child: FittedBox(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 4,
                  child: Container(
                    color: Colors.white,
                    child: Image(
                      image: AssetImage('assets/selection_one.png'),
                      height: 150,
                      width: 170,
                    ),
                  ),
                ),
                // ),
                Expanded(
                  flex: 7,
                  child: Container(
                    padding: EdgeInsets.only(top: 150),
                    width: 170,
                    height: 250,
                    color: Colors.white,
                    child: Text(
                        'Masanızı Önden Seçme Ayrıcalığı ile Rezervasyon Yapın!'),
                  ),
                ),
                Container(
                  width: 120,
                  height: 40,
                  color: Colors.white,
                  margin: EdgeInsets.only(bottom: 30),
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ReservationListScreen()),
                      );
                    },
                    child: Text('Rezervasyon Yap'),
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(60.0)),
                    color: Colors.brown,
                    textColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          //),
          Card(
            margin: EdgeInsets.only(top: 100, bottom: 80),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 4,
                  child: Container(
                    color: Colors.white,
                    child: Image(
                      image: AssetImage('assets/selection_two.png'),
                      height: 150,
                      width: 170,
                    ),
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: Container(
                    padding: EdgeInsets.only(top: 150),
                    width: 170,
                    height: 250,
                    color: Colors.white,
                    child: Text(
                        'Önden Sipariş Verin Geldiğinizde Siparişiniz Hazır Olsun!'),
                  ),
                ),
                Container(
                  width: 120,
                  height: 40,
                  color: Colors.white,
                  margin: EdgeInsets.only(bottom: 30),
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RestaurantList()),
                      );
                    },
                    child: Text('Sipariş Ver'),
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(60.0)),
                    color: Colors.brown,
                    textColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
