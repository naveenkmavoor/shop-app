import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';

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
  static const _url = 'https://shopapp-67ac8-default-rtdb.firebaseio.com/cart';
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

  Future<Map<String, CartItem>> fetchCartItems() async {
    try {
      final http.Response response = await http.get(Uri.parse(_url + '.json'));
      if (response.body == "null") {
        return {};
      }
      final fetchedItems = json.decode(response.body) as Map<String, dynamic>;

      fetchedItems.forEach((key, value) {
        _items.putIfAbsent(
            value['id'],
            () => CartItem(
                id: key,
                image: value['image'],
                price: value['price'],
                quantity: value['quantity'],
                title: value['title']));
      });
      notifyListeners();
      return _items;
    } catch (err) {
      throw HttpException('Something goes wrong.');
    }
  }

  bool containsItemInCart(String productId) {
    if (_items.containsKey(productId)) {
      return true;
    }
    return false;
  }

  Future<void> updateCart(
      String productId, double price, String image, String title,
      [bool remove = false]) async {
    try {
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
        notifyListeners();

        http.Response response = await http.patch(
            Uri.parse(_url + '/${_items[productId]!.id}.json'),
            body: json.encode({'quantity': _items[productId]!.quantity}));
        if (response.statusCode >= 400) {
          undoAction(productId);
          notifyListeners();
          throw HttpException('Failed To Update Cart');
        }
      } else {
        http.Response response = await http.post(Uri.parse(_url + '.json'),
            body: json.encode({
              'id': productId,
              'title': title,
              'image': image,
              'quantity': 1,
              'price': price
            }));
        _items.putIfAbsent(
            productId,
            () => CartItem(
                id: json.decode(response.body)['name'],
                title: title,
                image: image,
                quantity: 1,
                price: price));
        notifyListeners();
      }
    } catch (err) {
      throw err;
    }
  }

  Future<void> removeItemFromCart(String key) async {
    if (_items.containsKey(key)) {
      print('cart id : ${_items[key]!.id}');
      final http.Response response =
          await http.delete(Uri.parse(_url + '/${_items[key]!.id}.json'));
      if (response.statusCode >= 400) {
        throw HttpException('Error occured');
      }
      _items.remove(key);
      notifyListeners();
    }
  }

  Future<void> clearCart() async {
    final _cacheItems = _items;
    _items = {};
    notifyListeners();
    final http.Response response = await http.delete(Uri.parse(_url + '.json'));
    if (response.statusCode >= 400) {
      _items = _cacheItems;
      throw HttpException('Error occured!');
    }
  }

  void undoAction(String id) {
    if (!_items.containsKey(id)) {
      return;
    }
    if (_items[id]!.quantity > 1) {
      _items.update(
          id,
          (existingCartItem) => CartItem(
              id: id,
              image: existingCartItem.image,
              title: existingCartItem.title,
              quantity: existingCartItem.quantity - 1,
              price: existingCartItem.price));
    } else {
      removeItemFromCart(id);
      return;
    }
    notifyListeners();
  }
}
