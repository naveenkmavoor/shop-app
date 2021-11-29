import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/providers.dart';
import 'package:shop_app/screens/screens.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    return Container(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0), color: Colors.white),
        child: GestureDetector(
          onTap: () => Navigator.of(context)
              .pushNamed(ProductDetails.routeName, arguments: product.id),
          child: Column(
            children: [
              Expanded(
                child: FadeInImage(
                    fit: BoxFit.cover,
                    placeholder: AssetImage('assets/img/img.jpg'),
                    image: NetworkImage(
                      product.imageUrl,
                    )),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.rupeeSign,
                          size: 16,
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  ' ${product.price.toString()}',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              CircleAvatar(
                                backgroundColor:
                                    Theme.of(context).scaffoldBackgroundColor,
                                child: Consumer<Product>(
                                  builder: (ctx, product, _) => IconButton(
                                    color:
                                        Theme.of(context).secondaryHeaderColor,
                                    icon: Icon(product.isFavorite
                                        ? Icons.favorite
                                        : Icons.favorite_border),
                                    onPressed: () {
                                      product.toggleFavIcon();
                                      updateItem(product, context);
                                    },
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        )
        // child: GridTile(
        //   child: GestureDetector(
        //     onTap: () => Navigator.of(context)
        //         .pushNamed(ProductDetails.routeName, arguments: product.id),
        //     child: FadeInImage(
        //       image: NetworkImage(product.imageUrl),
        //       placeholder: AssetImage(
        //         'assets/img/img.jpg',
        //       ),
        //       fit: BoxFit.cover,
        //     ),
        //   ),
        //   header: Text(
        //     '${product.price}\$',
        //     textAlign: TextAlign.right,
        //     style: TextStyle(color: Theme.of(context).secondaryHeaderColor),
        //   ),
        //   footer: GridTileBar(
        //     // trailing: IconButton(
        //     //   color: Theme.of(context).secondaryHeaderColor,
        //     //   icon: Icon(Icons.shopping_cart),
        //     //   onPressed: () {
        //     //     cart.updateItems(
        //     //         product.id, product.price, product.imageUrl, product.title);
        //     //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //     //       content: Text('Added item to cart!'),
        //     //       duration: Duration(seconds: 1),
        //     //       action: SnackBarAction(
        //     //         label: 'UNDO',
        //     //         onPressed: () {
        //     //           cart.undoAction(product.id);
        //     //         },
        //     //       ),
        //     //     ));
        //     //   },
        //     // ),
        //     backgroundColor: Colors.black87,
        //     trailing: Consumer<Product>(
        //       builder: (ctx, product, _) => IconButton(
        //         color: Theme.of(context).secondaryHeaderColor,
        //         icon: Icon(
        //             product.isFavorite ? Icons.favorite : Icons.favorite_border),
        //         onPressed: () {
        //           product.toggleFavIcon();
        //           updateItem(product, context);
        //         },
        //       ),
        //     ),
        //     title: Text(
        //       product.title,
        //       textAlign: TextAlign.center,
        //     ),
        //   ),
        // ),
        );
  }

  void updateItem(Product product, BuildContext context) async {
    try {
      await Provider.of<ProductsProvider>(context, listen: false)
          .updateProduct(product);
    } catch (err) {
      product.toggleFavIcon();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          err.toString(),
        ),
        backgroundColor: Theme.of(context).secondaryHeaderColor,
      ));
    }
  }
}
