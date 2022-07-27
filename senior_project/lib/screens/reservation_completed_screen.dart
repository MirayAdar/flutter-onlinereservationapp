import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:senior_project/screens/sign_in_screen.dart';
import 'package:senior_project/services/notifiers.dart';

class ReservationCompletedScreen extends StatelessWidget {
  ReservationCompletedScreen({Key key, this.isOrder}) : super(key: key);
  bool isOrder;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0.0,
        automaticallyImplyLeading: false,
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
        actions: [
          IconButton(
              icon: Icon(Icons.check),
              onPressed: () async {
                GoogleSignInAccount account =
                    Provider.of<CartModel>(context, listen: false).getAccount;
                print(account);
                print("now go");
                Navigator.of(context).popUntil((route) => route.isFirst);
                /*  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => SignInScreen(
                              account: account,
                            )),
                    (Route<dynamic> route) => false);*/
              })
        ],
      ),
      body: SafeArea(
          child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(16),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green, size: 100),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                        !isOrder
                            ? "Your order has been successfully completed, Maximum Arrival Time: 30 mins"
                            : "Your table has been successfully reserved",
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center),
                  ],
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}
