import 'package:flutter/material.dart';
import 'package:shop_app/models/models.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [
    Product(
        id: 'p1',
        title: 'Red Shirt',
        description: "Red as blood!",
        price: 19.99,
        imageUrl: 'https://www.marni.com/12/12386489mt_13_n_r.jpg'),
    Product(
        id: 'p2',
        title: 'Rain Jacket',
        description: "Cheap, Eco-Friendly, Hiking and Running.",
        price: 29.99,
        imageUrl:
            'https://media.wired.com/photos/606ce52941bf976945513469/191:100/w_2086,h_1092,c_limit/Gear-Cloudburst-Jacket---Mandarin-Front-square-grey-back.jpg'),
    Product(
        id: 'p3',
        title: 'Denim Jacket',
        description: "Denim Winter Warm Wool Denim Jacket",
        price: 39.99,
        imageUrl:
            'https://img.joomcdn.net/3d9ab777e9ab4e964c5c6377de686b521a46635a_original.jpeg'),
    Product(
        id: 'p4',
        title: 'T-Shirt',
        description: "Vogue T-shirt for men.",
        price: 29.99,
        imageUrl:
            'https://assets.vogue.com/photos/605a71e1fcace3ac4650f07b/master/w_1280%2Cc_limit/slide_13.jpg'),
  ];

  List<Product> get items {
    return [..._items];
  }

  void addProduct() {}

  List<Product> get favItems {
    return _items.where((element) => element.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }
}
