import 'package:flutter/material.dart'; 
import 'package:shop_app/screens/product_edit_overview.dart'; 
import 'package:shop_app/screens/screens.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            automaticallyImplyLeading: false,
            title: Text('Home'),
            leading: Icon(Icons.home),
          ),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Orders'),
            onTap: () {
              Navigator.of(context).popAndPushNamed(OrderScreen.routeName);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.edit,
            ),
            title: Text('Manage Products'),
            onTap: () => Navigator.of(context).popAndPushNamed(ProductEditOverview.routeName),
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Log Out'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
