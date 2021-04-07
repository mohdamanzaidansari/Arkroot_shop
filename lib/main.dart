import 'package:arkroot_shop/providers/products.dart';
import 'package:arkroot_shop/screens/add_edit_product.dart';
import 'package:arkroot_shop/screens/products_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ListenableProvider<Products>(
      create: (context) => Products(),
      child: MaterialApp(
        title: 'Arkroot Shop',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          accentColor: Colors.red,
          buttonTheme: ButtonThemeData(
            buttonColor: Colors.deepPurple,
            shape: StadiumBorder(),
            textTheme: ButtonTextTheme.primary,
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: ProductsListScreen(),
        routes: {
          EditProductScreen.routeName: (context) => EditProductScreen(),
        },
      ),
    );
  }
}
