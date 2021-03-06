import 'package:flutter/material.dart';
import 'package:shop_app/providers/providers.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;
  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}

class Order with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrders(List<CartItem> cartItems, double total) async {
    _orders.insert(
        0,
        OrderItem(
            id: DateTime.now().toString(),
            amount: total,
            products: cartItems,
            dateTime: DateTime.now()));

    notifyListeners();
  }
}
