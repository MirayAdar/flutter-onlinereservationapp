import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:senior_project/models/menu_model.dart';
import 'package:provider/provider.dart';
import 'package:senior_project/models/restaurant_model.dart';

class CartModel extends ChangeNotifier {
  /// Internal, private state of the cart.
  final List<Menu> _items = [];

  /// An unmodifiable view of the items in the cart.
  List<Menu> get getItems => _items;

  String currentCartRestaurant = "";
  Restaurant currentRestaurant;
  GoogleSignInAccount account;

  GoogleSignInAccount get getAccount => account;

  /// Adds [item] to cart. This and [removeAll] are the only ways to modify the
  /// cart from the outside.
  void add(Menu item) {
    currentCartRestaurant = item.restId;

    _items.add(item);
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  void setAccount(GoogleSignInAccount setAccount) {
    account = setAccount;

    notifyListeners();
  }

  double getTotalPrice() {
    double totalPrice = 0;
    _items.forEach((element) {
      totalPrice += element.price;
    });
    return totalPrice;
  }

  void remove(Menu item) {
    _items.remove(item);
    if (_items.isEmpty) {
      currentCartRestaurant = "";
      currentRestaurant = null;
    }
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  void setCurrentRestaurant(Restaurant restaurant) {
    currentRestaurant = restaurant;
    notifyListeners();
  }

  /// Removes all items from the cart.
  void removeAll() {
    currentCartRestaurant = "";
    currentRestaurant = null;
    _items.clear();
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }
}
