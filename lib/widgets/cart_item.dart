import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/providers.dart';

class ListCartItem extends StatelessWidget {
  final String keys;
  final Map<String, dynamic> cartItem;
  ListCartItem({
    Key? key,
    required this.keys,
    required this.cartItem,
  }) : super(key: key);

  void showAlertMessage(BuildContext context, String mssg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(mssg),
      backgroundColor: Theme.of(context).colorScheme.secondary,
      duration: Duration(seconds: 1),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(keys),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItemFromCart(keys);
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
                  aspectRatio: 1,
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
                          cartItem['quantity']--;
                          cart
                              .updateCart(keys, cartItem['price'],
                                  cartItem['image'], cartItem['title'], true)
                              .catchError((err) {
                            cartItem['quantity']++;
                            showAlertMessage(context, err.toString());
                          });
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
                          cartItem['quantity']++;

                          cart
                              .updateCart(keys, cartItem['price'],
                                  cartItem['image'], cartItem['title'])
                              .catchError((err) {
                            cartItem['quantity']--;
                            showAlertMessage(context, err.toString());
                          });
                        } else {
                          showAlertMessage(
                              context, 'Max 3 units allowed per order.');
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
