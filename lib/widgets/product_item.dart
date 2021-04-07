import 'dart:io';

import 'package:arkroot_shop/screens/add_edit_product.dart';
import 'package:flutter/material.dart';

class ProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String image;

  const ProductItem({
    required this.id,
    required this.title,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: GridTile(
        child: GestureDetector(
          onTap: () {},
          child: Hero(
            tag: id,
            child: Image.file(
              File(image),
              fit: BoxFit.cover,
            ),
            // ),
          ),
        ),
        footer: GridTileBar(
          title: Text(
            title,
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.black54,
          trailing: IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).pushNamed(
                EditProductScreen.routeName,
                arguments: id,
              );
            },
          ),
        ),
      ),
    );
  }
}
