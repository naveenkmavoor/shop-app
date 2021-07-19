import 'package:flutter/material.dart';

class OrderDrawer extends StatelessWidget {
  const OrderDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('Orders'),
            leading: Icon(Icons.payment),
            automaticallyImplyLeading: false,
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () => Navigator.of(context).pushReplacementNamed('/'),
          )
        ],
      ),
    );
  }
}
