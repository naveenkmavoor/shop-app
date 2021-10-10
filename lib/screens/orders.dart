import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/models.dart';
import 'package:shop_app/widgets/widgets.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = '/orders';
  const OrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ordersData = Provider.of<Order>(context);
    return Scaffold( 
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      body: ordersData.orders.length == 0
          ? Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.payment,
                    color: Colors.grey[400],
                    size: 50,
                  ),
                  Text(
                    'No orders yet!',
                    style: TextStyle(color: Colors.grey[400], fontSize: 16),
                  )
                ],
              ),
            )
          : ListView.builder(
              itemBuilder: (ctx, index) =>
                  ListOrderItems(orderItem: ordersData.orders[index]),
              itemCount: ordersData.orders.length,
            ),
    );
  }
}
