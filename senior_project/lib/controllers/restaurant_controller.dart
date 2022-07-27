import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:senior_project/models/restaurant_model.dart';
import 'package:senior_project/services/utils.dart';

class RestaurantController {
  Future<List<QueryDocumentSnapshot>> getRestaurants() async {
    var docs;
    await FirebaseFirestore.instance
        .collection('restaurants')
        .get()
        .then((value) {
      docs = value.docs;
    });
    return docs;
  }

  Future rateRestaurant(String comment, int rating, String userId,
      Restaurant restaurant, GoogleSignInAccount account) async {
    await FirebaseFirestore.instance.collection('reviews').add({
      "rating": rating,
      "userId": userId,
      "restId": restaurant.restaurantId,
      "description": comment,
      "userName": account.displayName
    });
  }

  Future<Map<String, dynamic>> getTables(
      Restaurant restaurant, DateTime date) async {
    return await FirebaseFirestore.instance
        .collection('reservations')
        .where('restId', isEqualTo: restaurant.restaurantId)
        .get()
        .then((queryDocs) async {
      if (queryDocs.docs.length == 0) {
        print("no : " + restaurant.noOfTable.toString());
        List<dynamic> tables = [];
        Map<String, dynamic> returnMap = {};
        for (int i = 0; i < restaurant.noOfTable; i++) {
          tables.add({"status": "Empty", "userId": null});
        }
        var id;
        await FirebaseFirestore.instance.collection('reservations').add({
          "restId": restaurant.restaurantId,
          "dates": {dateString(date): tables}
        }).then((value) async {
          //  print(queryDocs.docs.first.data()["dates"]);
          id = value.id;
        });

        DocumentSnapshot docSnap = await FirebaseFirestore.instance
            .collection('reservations')
            .doc(id)
            .get();
        returnMap["id"] = id;
        returnMap.addAll(docSnap.data());
        print("return 1");
        return returnMap;
      } else {
        print("docs : " + queryDocs.docs.first.data().toString());
        Map<String, dynamic> tableData = queryDocs.docs.first.data()["dates"];

        if (tableData.containsKey(dateString(date))) {
          print("return 2");
          print(queryDocs.docs.first.data()["dates"]);
          Map<String, dynamic> returnMap = {};
          returnMap["id"] = queryDocs.docs.first.id;
          returnMap.addAll(queryDocs.docs.first.data());
          return returnMap;
        } else {
          Map<String, dynamic> returnMap = {};
          List<dynamic> tables = [];
          for (int i = 0; i < restaurant.noOfTable; i++) {
            tables.add({"status": "Empty", "userId": null});
          }
          Map<String, dynamic> allMap = queryDocs.docs.first.data()["dates"];
          allMap[dateString(date)] = tables;
          queryDocs.docs.first.data()["dates"][dateString(date)] = tables;
          print(queryDocs.docs.first.data()["dates"]);
          await FirebaseFirestore.instance
              .collection('reservations')
              .doc(queryDocs.docs.first.id)
              .update({"dates": allMap});
          print("return 3");
          print(queryDocs.docs.first.data()["dates"]);
          var docSnap = await FirebaseFirestore.instance
              .collection('reservations')
              .doc(queryDocs.docs.first.id)
              .get();
          returnMap["id"] = queryDocs.docs.first.id;
          returnMap.addAll(docSnap.data());
          return returnMap;
        }
      }
    });
  }
}
