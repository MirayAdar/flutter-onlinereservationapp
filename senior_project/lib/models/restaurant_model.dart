import 'dart:convert';

import 'package:collection/collection.dart';

class Restaurant {
  String logoUrl;
  List<String> detailUrls;
  String planUrl;
  String details;
  String name;
  String price;
  String restaurantId;
  String address;
  String ownerId;
  int noPerTable;
  int noOfTable;
  Restaurant({
    this.logoUrl,
    this.detailUrls,
    this.planUrl,
    this.details,
    this.name,
    this.noOfTable,
    this.price,
    this.noPerTable,
    this.restaurantId,
    this.address,
    this.ownerId,
  });

  Map<String, dynamic> toMap() {
    return {
      'logoUrl': logoUrl,
      'detailUrls': detailUrls,
      'planUrl': planUrl,
      'details': details,
      'name': name,
      'price': price,
      'noPerTable': noPerTable ?? 0,
      'noOfTable': noOfTable ?? 0,
      'restaurantId': restaurantId,
      'address': address,
      'ownerId': ownerId,
    };
  }

  factory Restaurant.fromMap(Map<String, dynamic> map) {
    return Restaurant(
      logoUrl: map['logoUrl'],
      detailUrls: List<String>.from(map['detailUrls']),
      planUrl: map['planUrl'],
      details: map['details'],
      name: map['name'],
      price: map['price'],
      noPerTable: map['noPerTable'] == null ? 0 : int.parse(map['noPerTable']),
      noOfTable: map['noOfTable'] == null ? 0 : int.parse(map['noOfTable']),
      restaurantId: map['restaurantId'],
      address: map['address'],
      ownerId: map['ownerId'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Restaurant.fromJson(String source) =>
      Restaurant.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Restaurant(logoUrl: $logoUrl, detailUrls: $detailUrls, planUrl: $planUrl, details: $details, name: $name, price: $price, restaurantId: $restaurantId, address: $address, ownerId: $ownerId)';
  }
}
