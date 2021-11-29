import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/providers.dart';
import 'package:shop_app/screens/screens.dart';
import 'package:shop_app/widgets/widgets.dart';

enum FilterOptions { Favorites, All }

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _isFavs = false;

  Widget bodyWidget() {
    return FutureBuilder(
      builder: (context, AsyncSnapshot<List<Product>> dataSnapshot) {
        if (dataSnapshot.connectionState == ConnectionState.waiting) {
          return SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()));
        } else if (dataSnapshot.hasError) {
          return SliverFillRemaining(
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Oops! something goes wrong.",
                  style: TextStyle(color: Colors.grey),
                ),
                TextButton.icon(
                    onPressed: () => setState(() {}),
                    icon: Icon(Icons.refresh),
                    label: Text('Reload'))
              ],
            )),
          );
        } else if (dataSnapshot.data!.length == 0) {
          return SliverFillRemaining(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.cloud_off, color: Colors.grey),
                  Text('No Items found'),
                  TextButton.icon(
                      onPressed: () =>
                          Navigator.pushNamed(context, ProductEdit.routeName),
                      icon: Icon(Icons.add),
                      label: Text('Add Product'))
                ],
              ),
            ),
          );
        }
        return ProductGridview(isFav: _isFavs);
      },
      future:
          Provider.of<ProductsProvider>(context, listen: false).fetchProduct(),
    );
  }

  void newstate() {
    setState(() {});
  }

  Future<void> fetchval() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: AppDrawer(newstate: newstate),
        body: RefreshIndicator(
          onRefresh: () => fetchval(),
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                title: Text('Shopping Center'),
                actions: [
                  Consumer(
                    builder: (ctx, Cart cart, Widget? child) {
                      return cart.items.length == 0
                          ? child!
                          : Badge(
                              child: child,
                              value: cart.items.length.toString());
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
                floating: true,
              ),
              bodyWidget()
            ],
          ),
        ));
  }
}
