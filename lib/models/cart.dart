import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String image;
  final String title;
  final int quantity;
  final double price;
  CartItem({
    required this.id,
    required this.image,
    required this.title,
    required this.quantity,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'image': image,
      'title': title,
      'quantity': quantity,
      'price': price,
    };
  }
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  String get totalAmount {
    double total = 0.00;
    _items.forEach((_, element) {
      total += element.price * element.quantity;
    });
    return total.toStringAsFixed(2);
  }

  void updateItems(String productId, double price, String image, String title,
      [bool remove = false]) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (existingCartItem) => CartItem(
              id: existingCartItem.id,
              image: existingCartItem.image,
              title: existingCartItem.title,
              quantity: remove
                  ? existingCartItem.quantity > 1
                      ? existingCartItem.quantity - 1
                      : existingCartItem.quantity
                  : existingCartItem.quantity < 3
                      ? existingCartItem.quantity + 1
                      : existingCartItem.quantity,
              price: existingCartItem.price));
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
              id: DateTime.now().toString(),
              title: title,
              image: image,
              quantity: 1,
              price: price));
    }
    notifyListeners();
  }

  void removeItem(String key) {
    _items.remove(key);
    notifyListeners();
  }

  void clearCart() {
    _items = {}; 
  }
}
