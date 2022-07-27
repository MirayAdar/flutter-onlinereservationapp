import 'dart:convert';

class Menu {
  String category;
  String foodName;
  String ingeridents;
  String menuId;
  String ownerId;
  double price;
  String restId;
  Menu({
    this.category,
    this.foodName,
    this.ingeridents,
    this.menuId,
    this.ownerId,
    this.price,
    this.restId,
  });

  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'foodName': foodName,
      'ingeridents': ingeridents,
      'menuId': menuId,
      'ownerId': ownerId,
      'price': price.toString(),
      'restID': restId,
    };
  }

  factory Menu.fromMap(Map<String, dynamic> map) {
    return Menu(
      category: map['category'],
      foodName: map['foodName'],
      ingeridents: map['ingeridents'],
      menuId: map['menuId'],
      ownerId: map['ownerId'],
      price: double.parse(map['price']),
      restId: map['restID'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Menu.fromJson(String source) => Menu.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Menu(category: $category, foodName: $foodName, ingeridents: $ingeridents, menuId: $menuId, ownerId: $ownerId, price: $price, restId: $restId)';
  }
}
