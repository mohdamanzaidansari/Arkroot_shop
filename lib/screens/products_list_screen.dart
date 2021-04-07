import 'package:arkroot_shop/screens/add_edit_product.dart';
import 'package:arkroot_shop/widgets/product_grid.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class ProductsListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(math.pi),
          child: IconButton(
            splashRadius: 24,
            icon: Icon(
              Icons.segment,
              size: 32,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: () {},
          ),
        ),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Hi,',
              style: TextStyle(
                color: Colors.black38,
                // fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 6),
            Text(
              'Aarav Lynn',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            Text(
              '.',
              style: TextStyle(
                fontSize: 24,
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w700,
              ),
            )
          ],
        ),
        actions: [
          IconButton(
            splashRadius: 24,
            icon: Icon(
              Icons.add,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: () {
              Navigator.of(context).pushNamed(
                EditProductScreen.routeName,
                arguments: '',
              );
            },
          ),
        ],
      ),
      body: ProductGrid(),
    );
  }
}
