import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_app/models/models.dart';
import 'package:http/http.dart' as http;

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }

  void updateProduct(Product product) {
    final int index = _items.indexWhere((element) => element.id == product.id);
    _items[index] = product;
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    const url =
        'https://shopapp-67ac8-default-rtdb.firebaseio.com/products.json';
    try {
      final http.Response _response = await http.post(Uri.parse(url),
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl
          }));
      print("${_response.body}");
      product = Product(
          id: json.decode(_response.body)['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl);
      _items.add(product);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> fetchProduct() async {
    _items = [];
    const url =
        'https://shopapp-67ac8-default-rtdb.firebaseio.com/products.json';
    try {
      final http.Response response = await http.get(Uri.parse(url));
      final fetchedProduct = json.decode(response.body) as Map<String, dynamic>;
      fetchedProduct.forEach((key, value) {
        final eachProduct = Product(
            id: key,
            title: value['title'],
            description: value['description'],
            price: value['price'],
            imageUrl: value['imageUrl']);
        print(eachProduct);
        _items.add(eachProduct);
        notifyListeners();
      });
    } catch (error) {
      throw error;
    }
  }

  void deleteProduct(String id) {
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  List<Product> get favItems {
    return _items.where((element) => element.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }
}
