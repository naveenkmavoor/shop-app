import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/models.dart';
import 'package:shop_app/screens/screens.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: GridTile(
        child: GestureDetector(
          onTap: () => Navigator.of(context)
              .pushNamed(ProductDetails.routeName, arguments: product.id),
          child: FadeInImage(
            image: NetworkImage(product.imageUrl),
            placeholder: AssetImage(
              'assets/img/img.jpg',
            ),
            fit: BoxFit.cover,
          ),
        ),
        header: Text(
          '${product.price}\$',
          textAlign: TextAlign.right,
          style: TextStyle(color: Theme.of(context).secondaryHeaderColor),
        ),
        footer: GridTileBar(
          trailing: IconButton(
            color: Theme.of(context).secondaryHeaderColor,
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              cart.updateItems(
                  product.id, product.price, product.imageUrl, product.title);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Added item to cart!'),
                duration: Duration(seconds: 1),
                action: SnackBarAction(
                  label: 'UNDO',
                  onPressed: () {
                    cart.undoAction(product.id);
                  },
                ),
              ));
            },
          ),
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            builder: (ctx, product, _) => IconButton(
              color: Theme.of(context).secondaryHeaderColor,
              icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border),
              onPressed: () {
                product.toggleFavIcon();
              },
            ),
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
