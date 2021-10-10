import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop_app/models/models.dart';

class ListCartItem extends StatelessWidget {
  final String keys;
  final Map<String, dynamic> cartItem;
  ListCartItem({
    Key? key,
    required this.keys,
    required this.cartItem,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    print(cartItem);
    print(keys);
    return Dismissible(
      key: ValueKey(keys),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(keys);
      },
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('Confirm action'),
                  content:
                      Text('Do you want to remove the item from the cart?'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(ctx).pop(false);
                        },
                        child: Text('No')),
                    TextButton(
                        onPressed: () {
                          Navigator.of(ctx).pop(true);
                        },
                        child: Text('Yes')),
                  ],
                ));
      },
      background: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).errorColor,
            borderRadius: BorderRadius.circular(5.0)),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        padding: EdgeInsets.all(8),
        alignment: Alignment.centerRight,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Consumer<Cart>(
            builder: (ctx, cart, _) {
              return ListTile(
                title: Text(cartItem['title']),
                leading: AspectRatio(
                  aspectRatio: 3 / 2,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: FadeInImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(cartItem['image']),
                      placeholder: AssetImage('assets/img/img.jpg'),
                    ),
                  ),
                ),
                subtitle: Text(
                  'Total \$${(cartItem['price'] * cartItem['quantity'])}',
                ),
                trailing: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        if (cartItem['quantity'] > 1) {
                          cart.updateItems(keys, cartItem['price'],
                              cartItem['image'], cartItem['title'], true);
                          cartItem['quantity']--;
                        }
                      },
                      icon: Icon(Icons.remove),
                      iconSize: 18,
                      splashRadius: 15,
                    ),
                    Text(
                      '${cartItem['quantity']}x',
                    ),
                    IconButton(
                      onPressed: () {
                        if (cartItem['quantity'] < 3) {
                          cart.updateItems(keys, cartItem['price'],
                              cartItem['image'], cartItem['title']);
                          cartItem['quantity']++;
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor:
                                  Theme.of(context).colorScheme.secondary,
                              duration: Duration(seconds: 1),
                              content: Text(
                                  'Sorry, only 3 units allowed in each order')));
                        }
                      },
                      icon: Icon(Icons.add),
                      iconSize: 18,
                      splashRadius: 15,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
