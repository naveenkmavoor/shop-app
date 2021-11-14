import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/providers.dart';

class ProductDetails extends StatelessWidget {
  static const routeName = '/productdetails';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final product = Provider.of<ProductsProvider>(context, listen: false)
        .findById(productId);
    return Scaffold(
      appBar: AppBar(
        title: Text('Description'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 300,
              width: double.infinity,
              child: FadeInImage(
                fit: BoxFit.cover,
                placeholder: AssetImage('assets/img/img.jpg'),
                image: NetworkImage(product.imageUrl),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                "Product Description",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              width: double.infinity,
              child: Text(
                product.description,
                softWrap: true,
              ),
            )
          ],
        ),
      ),
    );
  }
}
