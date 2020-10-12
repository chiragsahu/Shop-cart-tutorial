import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:test_prj/models/product.dart';
import 'package:test_prj/scoped_models/main.dart';

import './products_card.dart';

class Products extends StatelessWidget {

  Widget _buildProductList(List<Product> products) {
    Widget productCards;
    if (products.length > 0) {
      productCards = ListView.builder(
        itemBuilder: (BuildContext context, int index) =>
            ProductCard(products[index], index),
        itemCount: products.length,
      );
    } else {
      productCards = Center(
        child: Text("Oops! nothing here, please add some"),
      );
    }
    return productCards;
  }

// in this file we will make list of sweets that will appear on click
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      // the function can access the model data and gets models everytime the widget is changed
      return _buildProductList(model.displayProduct);
    });
  }
}
