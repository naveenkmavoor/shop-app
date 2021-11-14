import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/providers/providers.dart';

class ListOrderItems extends StatefulWidget {
  final OrderItem orderItem;
  const ListOrderItems({Key? key, required this.orderItem}) : super(key: key);

  @override
  _ListOrderItemsState createState() => _ListOrderItemsState();
}

class _ListOrderItemsState extends State<ListOrderItems> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('\$${widget.orderItem.amount}'),
            subtitle: Text(
              DateFormat('EEE, MMM d, yyyy, h:mm a')
                  .format(widget.orderItem.dateTime),
            ),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if (_expanded)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              height: min(widget.orderItem.products.length * 20.0 + 100, 200),
              child: ListView(
                children: widget.orderItem.products
                    .map((product) => Card(
                          margin: EdgeInsets.all(8.0),
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(5.0),
                              child: AspectRatio(
                                aspectRatio: 3 / 2,
                                child: FadeInImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(product.image),
                                  placeholder: AssetImage('assets/img/img.jpg'),
                                ),
                              ),
                            ),
                            title: Text('${product.title}'),
                            trailing:
                                Text('${product.quantity}x ${product.price}'),
                          ),
                        ))
                    .toList(),
              ),
            )
        ],
      ),
    );
  }
}
