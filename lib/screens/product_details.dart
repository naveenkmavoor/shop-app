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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: FadeInImage(
                height: 200,
                width: 200,
                fit: BoxFit.cover,
                placeholder: AssetImage('assets/img/img.jpg'),
                image: NetworkImage(product.imageUrl),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, bottom: 15.0),
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
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  height: 50,
                  alignment: Alignment.center,
                  color: Theme.of(context).secondaryHeaderColor,
                  child: Text(
                    'Add To Cart',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 50,
                  alignment: Alignment.center,
                  color: Colors.black,
                  child: Text(
                    'Buy Now',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
