import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:senior_project/components/profile/profile_restaurant_container.dart';
import 'package:senior_project/controllers/menu_controller.dart';
import 'package:senior_project/controllers/restaurant_controller.dart';
import 'package:senior_project/models/order_model.dart';
import 'package:senior_project/models/restaurant_model.dart';
import 'package:senior_project/screens/sign_in_screen.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  // Optional clientId
  // clientId: '479882132969-9i9aqik3jfjd7qhci1nqf0bm2g71rm1u.apps.googleusercontent.com',
  scopes: <String>[
    'email',
  ],
);

class ProfileScreen extends StatefulWidget {
  ProfileScreen(this.account);
  final GoogleSignInAccount account;

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Color gradientStart = Colors.red[700]; //Change start gradient color here
  Color gradientEnd = Colors.black87.withOpacity(0.8);
  bool isLoading = true;
  Future<void> _handleSignOut() => _googleSignIn.disconnect().then((value) {
        Navigator.of(context, rootNavigator: true).pop('dialog');
        pushNewScreen(context, withNavBar: false, screen: SignInScreen())
            .then((value) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => SignInScreen()),
              (Route<dynamic> route) => false);
        });
      });

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Log Out", style: TextStyle(color: Colors.red)),
      onPressed: () {
        _handleSignOut();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Log Out ?"),
      content: Text("Are you sure you want to log out ?"),
      actions: [
        cancelButton,
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

  Future refreshProfile() async {
    await getRestaurantsFromDb();
  }

  List<QueryDocumentSnapshot> docs = [];
  List<Restaurant> restaurants = [];
  List<Order> orders = [];
  Map<Order, Restaurant> orderRestaurants = {};

  @override
  void initState() {
    super.initState();
    getRestaurantsFromDb();
  }

  getRestaurantsFromDb() async {
    setState(() {
      isLoading = true;
    });
    orders = await MenuController()
        .getRecentOrders(FirebaseAuth.instance.currentUser.uid);

    await RestaurantController().getRestaurants().then((value) {
      print(value[0]);
      setState(() {
        docs = value;
      });
    });
    docs.forEach((element) {
      print(element.data());
      setState(() {
        restaurants.add(Restaurant.fromMap(element.data()));
      });
    });
    orders.sort((a, b) => a.orderDate.compareTo(b.orderDate));
    orders = orders.reversed.toList();
    orders.forEach((element) {
      orderRestaurants[element] = restaurants
          .where((rest) => rest.restaurantId == element.restId)
          .first;
    });

    setState(() {
      isLoading = false;
    });
  }

  Widget reservationCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 15.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.network(
                      widget.account.photoUrl,
                      fit: BoxFit.cover,
                      height: 35,
                      width: 35,
                    ),
                  ),
                  SizedBox(
                    width: 15.0,
                  ),
                  Text(
                    "Altug",
                    style: Theme.of(context)
                        .textTheme
                        .headline
                        .apply(color: Colors.blueGrey, fontWeightDelta: 2),
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(
                      Icons.info,
                      color: Colors.red,
                    ),
                    onPressed: () {},
                  )
                ],
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            Container(
              padding: const EdgeInsets.all(25.0),
              color: Colors.red,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Free Feaster User",
                      style: Theme.of(context)
                          .textTheme
                          .headline
                          .apply(color: Colors.white),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.refresh),
          onPressed: () async {
            await refreshProfile();
          },
        ),
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
              icon: Icon(
                Icons.logout,
                color: Colors.red,
              ),
              onPressed: () {
                showAlertDialog(context);
              })
        ],
      ),
      body: SafeArea(
          child: isLoading == true
              ? Center(child: CircularProgressIndicator())
              : Container(
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 25),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          reservationCard(),
                          SizedBox(
                            height: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Recent Orders",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold)),
                              Container(
                                height: 250,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemCount: orders.length,
                                  itemBuilder: (context, index) {
                                    return ProfileRestaurantContainer(
                                        orderRestaurants[orders[index]],
                                        widget.account,
                                        orders[index]);
                                  },
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                )),
    );
  }
}
