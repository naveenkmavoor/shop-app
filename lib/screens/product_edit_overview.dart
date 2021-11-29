import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens.dart';
import 'package:shop_app/providers/providers.dart';

class ProductEditOverview extends StatelessWidget {
  static const routeName = '/producteditoverview';

  Future<void> _fetchItems(BuildContext context) async {
    try {
      await Provider.of<ProductsProvider>(context, listen: false)
          .fetchProduct();
    } catch (err) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('No Item Found.')));
    }
  }

  void _deleteItems(
      BuildContext context, ProductsProvider provider, int index) async {
    try {
      Navigator.pop(context);

      await Provider.of<Cart>(context, listen: false)
          .removeItemFromCart(provider.items[index].id);
      await provider.deleteProduct(provider.items[index].id);
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 1),
        content: Text('$err'),
        backgroundColor: Theme.of(context).secondaryHeaderColor,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Manage products'),
          actions: [
            IconButton(
                onPressed: Provider.of<ProductsProvider>(context, listen: false)
                    .addItemforTesting,
                icon: Icon(Icons.add_circle)),
            IconButton(
                onPressed: () => Navigator.of(context)
                    .pushNamed(ProductEdit.routeName)
                    .then((value) => value == true
                        ? ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                              'Added successfully.',
                            ),
                            backgroundColor:
                                Theme.of(context).secondaryHeaderColor,
                          ))
                        : Container()),
                icon: Icon(Icons.add))
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () => _fetchItems(context),
          child: Consumer(
            builder: (ctx, ProductsProvider provider, child) {
              return ListView.builder(
                itemBuilder: (ctx, index) {
                  return Column(
                    children: [
                      ListTile(
                        title: Text('${provider.items[index].title}'),
                        leading: CircleAvatar(
                          backgroundColor: Colors.white,
                          backgroundImage:
                              NetworkImage(provider.items[index].imageUrl),
                        ),
                        trailing: Container(
                          width: 100,
                          child: Row(
                            children: [
                              IconButton(
                                color: Theme.of(context).colorScheme.primary,
                                icon: Icon(Icons.edit),
                                onPressed: () => Navigator.of(context)
                                    .pushNamed(ProductEdit.routeName,
                                        arguments: provider.items[index].id),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                color: Theme.of(context).errorColor,
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (ctx) {
                                        return AlertDialog(
                                          content: Text('Are you sure?'),
                                          title: Text('Delete'),
                                          actions: [
                                            TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: Text('Cancel')),
                                            TextButton(
                                                onPressed: () {
                                                  _deleteItems(
                                                      context, provider, index);
                                                },
                                                child: Text('Delete')),
                                          ],
                                        );
                                      });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Divider(),
                    ],
                  );
                },
                itemCount: provider.items.length,
              );
            },
          ),
        ));
  }
}
