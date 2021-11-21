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
  bool _isInit = true;
  bool _isLoading = true;
  String text = '';
  @override
  void didChangeDependencies() {
    print('enter');
    if (_isInit) {
      print('entered');
      fetchItems(context);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void fetchItems(BuildContext context) async {
    try {
      await Provider.of<ProductsProvider>(context, listen: false)
          .fetchProduct();
    } catch (err) {
      text = err.toString();
      ShowAlertOnError.showAlertOnError(context, text);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget bodyWidget() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (text.isNotEmpty) {
      return Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            style: TextStyle(color: Colors.grey),
          ),
          TextButton.icon(
              onPressed: () => setState(() {
                    fetchItems(context);
                    _isLoading = true;
                    text = '';
                  }),
              icon: Icon(Icons.refresh),
              label: Text('Reload'))
        ],
      ));
    } else if (Provider.of<ProductsProvider>(context, listen: false)
            .items
            .length ==
        0) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_off, color: Colors.grey),
            Text('No Items added yet'),
            TextButton.icon(
                onPressed: () =>
                    Navigator.pushNamed(context, ProductEdit.routeName),
                icon: Icon(Icons.add),
                label: Text('Add Product'))
          ],
        ),
      );
    }
    return ProductGridview(isFav: _isFavs);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(
          title: Text('Shop App'),
          actions: [
            Consumer(
              builder: (ctx, Cart cart, Widget? child) {
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
        body: bodyWidget());
  }
}
