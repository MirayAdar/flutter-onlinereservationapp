import 'dart:convert';

import 'package:collection/collection.dart';

class Order {
  double totalPrice;
  List<dynamic> menuList;
  String userId;

  String restId;
  DateTime orderDate;
  String orderStatus;
  Order({
    this.totalPrice,
    this.menuList,
    this.userId,
    this.restId,
    this.orderDate,
    this.orderStatus,
  });

  Map<String, dynamic> toMap() {
    return {
      'totalPrice': totalPrice,
      'menuList': menuList,
      'userId': userId,
      'restId': restId,
      'orderDate': orderDate.toIso8601String(),
      'orderStatus': orderStatus,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      totalPrice: map['totalPrice'],
      menuList: List<dynamic>.from(map['menuList']),
      userId: map['userId'],
      restId: map['restId'],
      orderDate: DateTime.parse(map['orderDate']),
      orderStatus: map['orderStatus'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Order.fromJson(String source) => Order.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Order(totalPrice: $totalPrice, menuList: $menuList, userId: $userId, restId: $restId, orderDate: $orderDate, orderStatus: $orderStatus)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other is Order &&
        other.totalPrice == totalPrice &&
        listEquals(other.menuList, menuList) &&
        other.userId == userId &&
        other.restId == restId &&
        other.orderDate == orderDate &&
        other.orderStatus == orderStatus;
  }

  @override
  int get hashCode {
    return totalPrice.hashCode ^
        menuList.hashCode ^
        userId.hashCode ^
        restId.hashCode ^
        orderDate.hashCode ^
        orderStatus.hashCode;
  }
}
