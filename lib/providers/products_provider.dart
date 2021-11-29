import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop_app/models/http_exception.dart';
import 'package:shop_app/providers/providers.dart';
import 'package:http/http.dart' as http;

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [];
  bool test = false; //for testing purpose. Remove when the testing is done.
  static const _url = 'https://shopapp-67ac8-default-rtdb.firebaseio.com/';

  List<Product> get items {
    return [..._items];
  }

  Future<void> updateProduct(Product product) async {
    final int index = _items.indexWhere((element) => element.id == product.id);
    if (index >= 0) {
      try {
        final http.Response response =
            await http.patch(Uri.parse(_url + 'products/${product.id}.json'),
                body: json.encode({
                  'title': product.title,
                  'description': product.description,
                  'price': product.price,
                  'imageUrl': product.imageUrl,
                  'isFavorite': product.isFavorite
                }));
        if (response.statusCode >= 400) {
          throw HttpException('Failed to update.');
        }
      } catch (err) {
        throw err;
      }

      _items[index] = product;
      notifyListeners();
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      final http.Response _response =
          await http.post(Uri.parse(_url + 'products.json'),
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

  Future<List<Product>> fetchProduct() async {
    _items = [];
    print('entered fetch product');
    // try {
    final http.Response response =
        await http.get(Uri.parse(_url + 'products.json')).timeout(
              const Duration(seconds: 10),
            );
    if (response.body == "null") {
      return [];
    }

    final fetchedProduct = json.decode(response.body) as Map<String, dynamic>;

    fetchedProduct.forEach((key, value) {
      final eachProduct = Product(
          id: key,
          title: value['title'],
          description: value['description'],
          price: value['price'],
          imageUrl: value['imageUrl'],
          isFavorite: value['isFavorite']);
      _items.add(eachProduct);
    });
    notifyListeners();
    return items;
    // } on TimeoutException {
    //   throw HttpException('Timeout Error');
    // } on SocketException {
    //   throw HttpException('No Internet conncetion');
    // } on Error {
    //   throw HttpException('Oops something went wrong');
    // }
  }

  Future<void> deleteProduct(String id) async {
    final existingProductIndex =
        _items.indexWhere((element) => element.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeWhere((element) => element.id == id);
    notifyListeners();

    final http.Response response =
        await http.delete(Uri.parse(_url + 'products/$id.json'));
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Failed to delete item.');
    }
  }

  List<Product> get favItems {
    return _items.where((element) => element.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  void addItemforTesting() async {
    //function for testing purpose
    test = !test;
    var rand = Random.secure();
    Product newproduct = Product(
        id: '',
        title: 'Awesome T shirt No. ${rand.nextInt(250)}',
        description: 'So comfy to wear.',
        price: rand.nextInt(100) + 1.0,
        imageUrl: test
            ? 'https://www.pngarts.com/files/5/Plain-Pink-T-Shirt-PNG-Photo.png'
            : 'https://www.pngarts.com/files/5/Plain-Purple-T-Shirt-PNG-Photo.png');
    final http.Response response =
        await http.post(Uri.parse(_url + 'products.json'),
            body: json.encode({
              'title': newproduct.title,
              'description': newproduct.description,
              'price': newproduct.price,
              'imageUrl': newproduct.imageUrl,
              'isFavorite': newproduct.isFavorite
            }));
    _items.add(Product(
        id: json.decode(response.body)['name'],
        title: newproduct.title,
        description: newproduct.description,
        price: newproduct.price,
        imageUrl: newproduct.imageUrl));
    notifyListeners();
  }
}
