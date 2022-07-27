import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:senior_project/controllers/restaurant_controller.dart';
import 'package:senior_project/models/order_model.dart';
import 'package:senior_project/models/restaurant_model.dart';
import 'package:senior_project/screens/restaurant_info.dart';
import 'package:share/share.dart';

class ProfileRestaurantContainer extends StatefulWidget {
  ProfileRestaurantContainer(this.restaurant, this.account, this.order);
  Restaurant restaurant;
  Order order;
  GoogleSignInAccount account;
  @override
  _ProfileRestaurantContainerState createState() =>
      _ProfileRestaurantContainerState();
}

class _ProfileRestaurantContainerState
    extends State<ProfileRestaurantContainer> {
  String dateAsMinutes(DateTime date) {
    String a = date.day.toString() +
        "-" +
        date.month.toString() +
        "-" +
        date.year.toString() +
        " " +
        date.hour.toString() +
        ":" +
        date.minute.toString();

    return a;
  }

  Color getColorByStatus() {
    if (widget.order.orderStatus == "Served") {
      return Colors.green;
    } else if (widget.order.orderStatus == "Pending") {
      return Colors.yellow;
    } else {
      return Colors.red;
    }
  }

  orderBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 30.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: new Icon(Icons.shopping_cart, color: Colors.red),
                  title: new Text(
                    'Go to restaurant',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RestaurantInfo(
                                restaurant: widget.restaurant,
                              )),
                    );
                  },
                ),
                widget.order.orderStatus == "Served"
                    ? ListTile(
                        leading: new Icon(Icons.rate_review, color: Colors.red),
                        title: new Text(
                          'Rate Restaurant',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        onTap: () {
                          ratingDialog();
                        },
                      )
                    : SizedBox(),
                ListTile(
                  leading: new Icon(Icons.share, color: Colors.red),
                  title: new Text(
                    'Share',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  onTap: () async {
                    await Share.share(widget.restaurant.logoUrl);
                  },
                ),
              ],
            ),
          );
        });
  }

  ratingDialog() {
    final _dialog = RatingDialog(
      // your app's name?
      title: 'Rate Restaurant',
      // encourage your user to leave a high rating?
      message:
          'Tap a star to set your rating. Add more description here if you want.',
      // your app's logo?
      image: Image.network(
        widget.restaurant.logoUrl,
        height: 100,
      ),
      submitButton: 'Rate',
      onCancelled: () => print('cancelled'),
      onSubmitted: (response) async {
        print('rating: ${response.rating}, comment: ${response.comment}');
        final User user = FirebaseAuth.instance.currentUser;
        await RestaurantController().rateRestaurant(response.comment,
            response.rating, user.uid, widget.restaurant, widget.account);
        final snackBar = SnackBar(
          content: Text('Restaurant rated'),
        );
        // Find the ScaffoldMessenger in the widget tree
        // and use it to show a SnackBar.
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
    );

// show the dialog
    showDialog(
      context: context,
      builder: (context) => _dialog,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: GestureDetector(
        onTap: () {
          orderBottomSheet();
        },
        child: Container(
          width: 150,
          height: 200,
          color: Colors.transparent,
          margin: const EdgeInsets.symmetric(horizontal: 11.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: Image.network(
                        widget.restaurant.logoUrl,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 9.0, vertical: 5.0),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(15),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.restaurant.name,
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                          Text(
                            dateAsMinutes(widget.order.orderDate),
                            style: Theme.of(context)
                                .textTheme
                                .subtitle
                                .apply(color: Colors.black),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Positioned(
                    left: 10,
                    top: 10,
                    child: Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: getColorByStatus(),
                      ),
                      child: Text(widget.order.orderStatus),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
