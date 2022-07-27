import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:senior_project/models/order_model.dart';

class MenuController {
  Future<List<QueryDocumentSnapshot>> getMenus() async {
    var docs;
    await FirebaseFirestore.instance.collection('menus').get().then((value) {
      docs = value.docs;
    });
    return docs;
  }

  Future orderFromRestaurant(Order order) async {
    await FirebaseFirestore.instance
        .collection('orders')
        .add(order.toMap())
        .then((value) => value.update({"orderId": value.id}));
  }

  Future<List<Order>> getRecentOrders(String userId) async {
    List<Order> userOrders = [];
    await FirebaseFirestore.instance
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .get()
        .then((docs) {
      docs.docs.forEach((element) {
        userOrders.add(Order.fromMap(element.data()));
      });
    });
    return userOrders;
  }
}
