import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:senior_project/controllers/menu_controller.dart';
import 'package:senior_project/models/menu_model.dart';
import 'package:senior_project/models/restaurant_model.dart';
import 'package:senior_project/services/notifiers.dart';

class RestaurantMenuScreen extends StatefulWidget {
  RestaurantMenuScreen({Key key, this.restaurant}) : super(key: key);
  Restaurant restaurant;
  @override
  _RestaurantMenuScreenState createState() => _RestaurantMenuScreenState();
}

class _RestaurantMenuScreenState extends State<RestaurantMenuScreen> {
  List<QueryDocumentSnapshot> docs = [];
  List<Menu> menus = [];

  bool isFetching = true;
  List<Menu> mainFood = [];
  List<Menu> deserts = [];
  List<Menu> drinks = [];
  Map<String, List<Menu>> allMenus = {};
  getMenusFromDb() async {
    setState(() {
      isFetching = true;
    });
    await MenuController().getMenus().then((value) {
      print(value[0]);
      setState(() {
        docs = value;
      });
    });
    docs.forEach((element) {
      Menu menu = Menu.fromMap(element.data());
      print(menu.restId + " : " + widget.restaurant.restaurantId);
      if (menu.restId == widget.restaurant.restaurantId) {
        setState(() {
          print(menu.toString());
          menus.add(menu);
        });
      }
    });

    menus.forEach((element) {
      print("category");
      print(element.category);
      if (allMenus.containsKey(element.category)) {
        allMenus[element.category].add(element);
      } else {
        allMenus[element.category] = [];
        allMenus[element.category].add(element);
      }

      print(allMenus);
      if (element.category == "Ana Yemek") {
        setState(() {
          mainFood.add(element);
        });
      } else if (element.category == "İçecekler") {
        setState(() {
          drinks.add(element);
        });
      } else {
        setState(() {
          deserts.add(element);
        });
      }
    });
    setState(() {
      isFetching = false;
    });
  }

  diffRestAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Empty"),
      color: Colors.red,
      onPressed: () {
        Provider.of<CartModel>(context, listen: false).removeAll();
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Menu from another restaurant"),
      content: Text(
          "Looks like you have menu's in your cart from other restaurant. Do you want us to empty your trash for you ?"),
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

  @override
  void initState() {
    super.initState();
    getMenusFromDb();
  }

  Widget menuItemContainer(String key) {
    var cartModel = Provider.of<CartModel>(context, listen: false);
    return Container(
      child: Column(
        children: [
          Container(
            height: 50,
            width: MediaQuery.of(context).size.width,
            color: Colors.red,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                    key,
                    style: TextStyle(fontSize: 21, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            primary: false,
            physics: NeverScrollableScrollPhysics(),
            itemCount: allMenus[key].length,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(top: 10),
                height: 55,
                child: Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          if (cartModel.currentCartRestaurant != "" &&
                              cartModel.currentCartRestaurant !=
                                  allMenus[key][index].restId) {
                            diffRestAlertDialog(context);
                          } else {
                            if (cartModel.getItems
                                .contains(allMenus[key][index])) {
                              setState(() {
                                cartModel.remove(allMenus[key][index]);
                              });
                              final snackBar = SnackBar(
                                behavior: SnackBarBehavior.floating,
                                margin: EdgeInsets.only(bottom: 30),
                                content: Text('Item removed from your cart'),
                              );

                              // Find the ScaffoldMessenger in the widget tree
                              // and use it to show a SnackBar.
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            } else {
                              setState(() {
                                cartModel
                                    .setCurrentRestaurant(widget.restaurant);
                                cartModel.add(allMenus[key][index]);
                              });
                              final snackBar = SnackBar(
                                behavior: SnackBarBehavior.floating,
                                margin: EdgeInsets.only(bottom: 30),
                                content: Text('Item added to your cart'),
                              );

                              // Find the ScaffoldMessenger in the widget tree
                              // and use it to show a SnackBar.
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          }
                        },
                        style: cartModel.getItems.contains(allMenus[key][index])
                            ? ElevatedButton.styleFrom(
                                primary: Colors.red, // background
                                onPrimary: Colors.white, // foreground
                              )
                            : ElevatedButton.styleFrom(
                                primary: Colors.red, // background
                                onPrimary: Colors.white, // foreground
                              ),
                        child: cartModel.getItems.contains(allMenus[key][index])
                            ? Icon(Icons.remove_circle)
                            : Icon(Icons.add_shopping_cart)),
                    SizedBox(
                      width: 40,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            allMenus[key][index].foodName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: 'Calibri',
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xff464242),
                            ),
                          ),
                          Text(
                            allMenus[key][index].price.toString() + "₺",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: 'Calibri',
                              fontSize: 19.5,
                              color: const Color(0xff464242),
                            ),
                          )
                        ],
                      ),
                    ),
                    cartModel.getItems.contains(allMenus[key][index])
                        ? Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    cartModel.add(allMenus[key][index]);
                                  });
                                  final snackBar = SnackBar(
                                    behavior: SnackBarBehavior.floating,
                                    margin: EdgeInsets.only(bottom: 30),
                                    content: Text('Item added to your cart'),
                                  );

                                  // Find the ScaffoldMessenger in the widget tree
                                  // and use it to show a SnackBar.
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.green, // background
                                  onPrimary: Colors.white, // foreground
                                ),
                                child: Icon(Icons.add)),
                          )
                        : SizedBox()
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var cartModel = Provider.of<CartModel>(context, listen: false);
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
      body: isFetching == true
          ? Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: 130,
                        width: 130,
                        child: Image.network(widget.restaurant.logoUrl),
                      ),
                      SizedBox(
                        width: 40,
                      ),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(widget.restaurant.name,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 25)),
                            Divider(
                              height: 2,
                              color: Colors.grey,
                            ),
                            Text(widget.restaurant.address),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.red,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Text(
                            "Menüler",
                            style: TextStyle(
                                fontSize: 21, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          primary: false,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: allMenus.keys.length,
                          itemBuilder: (context, index) {
                            return menuItemContainer(
                                allMenus.keys.toList()[index]);
                          },
                        ),
                        /*  mainFood.length > 0
                            ? menuItemContainer(mainFood, "Ana Yemek")
                            : SizedBox(),
                        deserts.length > 0
                            ? menuItemContainer(deserts, "Tatlılar")
                            : SizedBox(),
                        drinks.length > 0
                            ? menuItemContainer(drinks, "İçecekler")
                            : SizedBox(),*/
                      ],
                    ),
                  )
                ],
              ),
            )),
    );
  }
}
