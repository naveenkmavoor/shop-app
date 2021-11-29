import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/providers.dart';
import 'package:shop_app/screens/screens.dart';

class ProductDetails extends StatelessWidget {
  static const routeName = '/productdetails';
  final ValueNotifier<bool> _isLoading = ValueNotifier<bool>(false);
  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final cart = Provider.of<Cart>(context, listen: false);
    final product = Provider.of<ProductsProvider>(context, listen: false)
        .findById(productId);
    return Scaffold(
      bottomNavigationBar: ValueListenableBuilder<bool>(
        builder: (context, val, _) {
          return val
              ? Center(child: CircularProgressIndicator())
              : cart.containsItemInCart(productId)
                  ? ElevatedButton(
                      onPressed: () =>
                          Navigator.of(context).pushNamed(MyCart.routename),
                      child: Text('Go To Cart'),
                      style: TextButton.styleFrom(
                        backgroundColor: Theme.of(context).secondaryHeaderColor,
                        padding: EdgeInsets.all(15),
                      ))
                  : ElevatedButton.icon(
                      style: TextButton.styleFrom(
                        backgroundColor: Theme.of(context).secondaryHeaderColor,
                        padding: EdgeInsets.all(15),
                      ),
                      onPressed: () {
                        _isLoading.value = true;
                        cart
                            .updateCart(product.id, product.price,
                                product.imageUrl, product.title)
                            .catchError((onError) => showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content:
                                        Text('Oops! Something goes wrong.'),
                                    actions: [
                                      TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                          child: Text(' Ok'))
                                    ],
                                  );
                                }).then((value) => _isLoading.value = false))
                            .then((value) {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  content: Text('Added item to cart!'),
                                  actions: [
                                    TextButton(
                                        onPressed: () =>
                                            cart.undoAction(product.id),
                                        child: Text('Undo')),
                                    TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        child: Text(' Ok'))
                                  ],
                                );
                              }).then((value) => _isLoading.value = false);
                        });
                      },
                      icon: Icon(
                        Icons.shopping_cart,
                        color: Colors.white,
                      ),
                      label: Text(
                        'Add To Cart',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    );
        },
        valueListenable: _isLoading,
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text('Description'),
            floating: true,
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                FadeInImage(
                  fit: BoxFit.cover,
                  placeholder: AssetImage('assets/img/img.jpg'),
                  image: NetworkImage(product.imageUrl),
                ),
                Text(
                  "Product Description",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(product.description +
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."),
                SizedBox(
                  height: MediaQuery.of(context).size.width - 270,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
