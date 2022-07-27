import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:senior_project/controllers/menu_controller.dart';
import 'package:senior_project/models/menu_model.dart';
import 'package:senior_project/models/order_model.dart';
import 'package:senior_project/screens/payment_main_page.dart';
import 'package:senior_project/services/notifiers.dart';

class CartScreen extends StatefulWidget {
  CartScreen({Key key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Delete"),
      color: Colors.red,
      onPressed: () {
        Provider.of<CartModel>(context, listen: false).removeAll();
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Empty Cart ?"),
      content: Text("Are you sure you want to empty your cart ?"),
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

  lowCartValueDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Ok"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
          "Your basket total is below the restaurants minimum deliver price"),
      content: Text("Please add more items"),
      actions: [
        cancelButton,
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
        actions: [
          IconButton(
            icon: Icon(
              Icons.delete,
              color: Colors.red,
            ),
            onPressed: () {
              showAlertDialog(context);
            },
          )
        ],
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
        child: Consumer<CartModel>(
          builder: (context, cart, child) {
            List<Menu> cartItems = cart.getItems;
            return cart.getItems.length > 0
                ? Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            primary: false,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: cartItems.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.only(top: 10),
                                height: 55,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 16,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              cartItems[index].foodName,
                                              style: TextStyle(
                                                fontFamily: 'Calibri',
                                                fontSize: 21,
                                                fontWeight: FontWeight.bold,
                                                color: const Color(0xff464242),
                                              ),
                                            ),
                                            Text(
                                              cartItems[index]
                                                      .price
                                                      .toString() +
                                                  "₺",
                                              style: TextStyle(
                                                fontFamily: 'Calibri',
                                                fontSize: 19.5,
                                                color: const Color(0xff464242),
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          width: 40,
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 16.0),
                                      child: ElevatedButton(
                                          onPressed: () {
                                            Provider.of<CartModel>(context,
                                                    listen: false)
                                                .remove(cartItems[index]);
                                            final snackBar = SnackBar(
                                              content: Text(
                                                  'Item removed from your cart'),
                                            );
                                            // Find the ScaffoldMessenger in the widget tree
                                            // and use it to show a SnackBar.
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(snackBar);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            primary: Colors.red, // background
                                            onPrimary:
                                                Colors.white, // foreground
                                          ),
                                          child: cartItems
                                                  .contains(cartItems[index])
                                              ? Icon(Icons.remove_shopping_cart)
                                              : Icon(Icons.add_shopping_cart)),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      Positioned(
                        left: 20,
                        bottom: 40,
                        child: ElevatedButton(
                          child: Text("Total Price : " +
                              cart.getTotalPrice().toString() +
                              " ₺"),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red,
                          ),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  )
                : Center(
                    child: Text("Your cart is empty",
                        style: TextStyle(fontSize: 30)),
                  );
          },
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: FloatingActionButton(
          backgroundColor: Colors.green,
          child: Icon(Icons.payment),
          onPressed: () {
            var cart = Provider.of<CartModel>(context, listen: false);
            if (cart.getTotalPrice() >=
                int.parse(cart.currentRestaurant.price)) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Payment(false, () async {
                          List<dynamic> menusAsMap = [];
                          cart.getItems.forEach((element) {
                            menusAsMap.add(element.toMap());
                          });
                          Order newOrder = Order(
                              userId: FirebaseAuth.instance.currentUser.uid,
                              restId: cart.currentCartRestaurant,
                              totalPrice: cart.getTotalPrice(),
                              menuList: menusAsMap,
                              orderDate: DateTime.now(),
                              orderStatus: "Pending");
                          await MenuController().orderFromRestaurant(newOrder);
                          await Provider.of<CartModel>(context, listen: false)
                              .removeAll();
                        })),
              );
            } else {
              lowCartValueDialog(context);
            }
          },
        ),
      ),
    );
  }
}
