import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/providers.dart';
import 'package:shop_app/widgets/widgets.dart';

class ProductGridview extends StatelessWidget {
  final bool isFav;
  const ProductGridview({
    required this.isFav,
  });

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);
    final products = isFav ? productsData.favItems : productsData.items;
    return GridView.builder(
        padding: const EdgeInsets.all(20.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 0.7,
            crossAxisCount: 2,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0),
        itemCount: products.length,
        itemBuilder: (context, index) => ChangeNotifierProvider.value(
              value: products[index],
              child: ProductItem(),
            ));
  }
}
