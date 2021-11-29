import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/providers.dart';
import 'package:shop_app/widgets/widgets.dart';

class MyCart extends StatefulWidget {
  static const routename = '/mycart';
  const MyCart({Key? key}) : super(key: key);

  @override
  _MyCartState createState() => _MyCartState();
}

class _MyCartState extends State<MyCart> {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);
    final order = Provider.of<Order>(context, listen: false);
    final style = TextStyle(fontWeight: FontWeight.bold, fontSize: 16);
    return Scaffold(
        appBar: AppBar(
          title: Text('My Cart'),
        ),
        body: FutureBuilder(
          builder: (context, AsyncSnapshot<Map<String, CartItem>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Failed to Load :('),
              );
            } else if (snapshot.data!.length == 0) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_cart_rounded,
                      color: Colors.grey[400],
                      size: 50,
                    ),
                    Text(
                      "Cart is empty",
                      style: TextStyle(color: Colors.grey[400], fontSize: 16),
                    )
                  ],
                ),
              );
            }

            return Column(
              children: [
                Expanded(
                    child: ListView.builder(
                  itemBuilder: (ctx, i) => ListCartItem(
                      cartItem: cart.items.values.toList()[i].toMap(),
                      keys: cart.items.keys.toList()[i]),
                  itemCount: cart.items.length,
                )),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18.0, vertical: 15.0),
                  child: Row(
                    children: [
                      Text(
                        'Total Payment',
                        style: style,
                      ),
                      Spacer(),
                      Consumer<Cart>(
                        builder: (_, cart, child) {
                          return Text(
                            '\$${cart.totalAmount}',
                            style: style,
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18.0, vertical: 15),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: TextButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).secondaryHeaderColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            padding: EdgeInsets.all(15),
                          ),
                          child: Text(
                            'Order Now',
                            style: style,
                          ),
                          onPressed: () async {
                            if (cart.items.length != 0) {
                              try {
                                await order.addOrders(
                                    cart.items.values.toList(),
                                    double.parse(cart.totalAmount));

                                await cart.clearCart();
                              } catch (err) {
                              } finally {
                                setState(() {});
                              }
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ],
            );
          },
          future: cart.fetchCartItems(),
        )
        //  Column(
        //   children: [
        //     Expanded(
        //         child: cart.items.length == 0
        //             ? Column(
        //                 mainAxisAlignment: MainAxisAlignment.center,
        //                 children: [
        //                   Icon(
        //                     Icons.shopping_cart_rounded,
        //                     color: Colors.grey[400],
        //                     size: 50,
        //                   ),
        //                   Text(
        //                     "Cart is empty",
        //                     style:
        //                         TextStyle(color: Colors.grey[400], fontSize: 16),
        //                   )
        //                 ],
        //               )
        //             : ListView.builder(
        //                 itemBuilder: (ctx, i) => ListCartItem(
        //                     cartItem: cart.items.values.toList()[i].toMap(),
        //                     keys: cart.items.keys.toList()[i]),
        //                 itemCount: cart.items.length,
        //               )),
        //     Padding(
        //       padding:
        //           const EdgeInsets.symmetric(horizontal: 18.0, vertical: 15.0),
        //       child: Row(
        //         children: [
        //           Text(
        //             'Total Payment',
        //             style: style,
        //           ),
        //           Spacer(),
        //           Consumer<Cart>(
        //             builder: (_, cart, child) {
        //               return Text(
        //                 '\$${cart.totalAmount}',
        //                 style: style,
        //               );
        //             },
        //           ),
        //         ],
        //       ),
        //     ),
        //     Padding(
        //       padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 15),
        //       child: Row(
        //         children: [
        //           Expanded(
        //             child: ElevatedButton(
        //               style: TextButton.styleFrom(
        //                 backgroundColor: Theme.of(context).secondaryHeaderColor,
        //                 shape: RoundedRectangleBorder(
        //                     borderRadius: BorderRadius.circular(10)),
        //                 padding: EdgeInsets.all(15),
        //               ),
        //               child: Text(
        //                 'Order Now',
        //                 style: style,
        //               ),
        //               onPressed: () async {
        //                 if (cart.items.length != 0) {
        //                   try {
        //                     await order.addOrders(cart.items.values.toList(),
        //                         double.parse(cart.totalAmount));

        //                     await cart.clearCart();
        //                   } catch (err) {
        //                   } finally {
        //                     setState(() {});
        //                   }
        //                 }
        //               },
        //             ),
        //           )
        //         ],
        //       ),
        //     ),
        //   ],
        // ),
        );
  }
}
