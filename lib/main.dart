import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/models.dart';
import 'package:shop_app/models/orders.dart';
import 'package:shop_app/models/products_provider.dart';
import 'package:shop_app/screens/product_details.dart';
import 'package:shop_app/screens/screens.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ProductsProvider(),
        ), //provide an instance of a ProductsProvider class
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (context) => Order(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
            fontFamily: 'Lato',
            secondaryHeaderColor: Colors.deepOrange,
            colorScheme: ColorScheme.fromSwatch().copyWith(
              secondary: Colors.deepOrange,
              primary: Colors.purple,
            )),
        home: ProductsOverviewScreen(),
        routes: {
          ProductDetails.routeName: (context) => ProductDetails(),
          MyCart.routename: (context) => MyCart(),
          OrderScreen.routeName: (context) => OrderScreen()
        },
      ),
    );
  }
}
