import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/providers.dart';
import 'package:shop_app/screens/screens.dart';

class AppDrawer extends StatelessWidget {
  final Function()? newstate;
  const AppDrawer({Key? key, this.newstate}) : super(key: key);

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
            onTap: () async {
              await Navigator.of(context)
                  .popAndPushNamed(OrderScreen.routeName);
              newstate!();
            },
          ),
          ListTile(
              leading: Icon(
                Icons.edit,
              ),
              title: Text('Manage Products'),
              onTap: () async {
                await Navigator.of(context)
                    .popAndPushNamed(ProductEditOverview.routeName);
                newstate!();
              }),
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
