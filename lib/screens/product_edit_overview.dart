import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/products_provider.dart';
import 'package:shop_app/screens/product_edit.dart';

class ProductEditOverview extends StatelessWidget {
  static const routeName = '/producteditoverview';

  Future<void> _fetchItems(BuildContext context) async {
    await Provider.of<ProductsProvider>(context, listen: false).fetchProduct();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Manage products'),
          actions: [
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
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
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
                                                  provider.deleteProduct(
                                                      provider.items[index].id);
                                                  Navigator.pop(context);
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
