import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/models.dart';
import 'package:shop_app/screens/screens.dart';
import 'package:shop_app/widgets/widgets.dart';

enum FilterOptions { Favorites, All }

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _isFavs = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(
          title: Text('Shop App'),
          actions: [
            Consumer(
              builder: (ctx, Cart cart, Widget? child) {
                print('${cart.items.length}');
                return cart.items.length == 0
                    ? child!
                    : Badge(child: child, value: cart.items.length.toString());
              },
              child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () =>
                    Navigator.of(context).pushNamed(MyCart.routename),
              ),
            ),
            PopupMenuButton(
              itemBuilder: (_) => [
                PopupMenuItem(
                  child: Text('Only Favorites'),
                  value: FilterOptions.Favorites,
                ),
                PopupMenuItem(
                  child: Text('Show All'),
                  value: FilterOptions.All,
                ),
              ],
              onSelected: (FilterOptions val) {
                setState(() {
                  if (val == FilterOptions.Favorites) {
                    _isFavs = true;
                  } else {
                    _isFavs = false;
                  }
                });
              },
              icon: Icon(Icons.more_vert),
            )
          ],
        ),
        body: ProductGridview(isFav: _isFavs));
  }
}
