import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/products_provider.dart';
import 'package:shop_app/screens/product_edit.dart';

class ProductEditOverview extends StatelessWidget {
  static const routeName = '/producteditoverview';
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
        body: Consumer(
          builder: (ctx, ProductsProvider provider, child) {
            return ListView.builder(
              itemBuilder: (ctx, index) {
                return Column(
                  children: [
                    ListTile(
                      title: Text('${provider.items[index].title}'),
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.primary,
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
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              color: Theme.of(context).errorColor,
                              onPressed: () {},
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
        ));
  }
}
