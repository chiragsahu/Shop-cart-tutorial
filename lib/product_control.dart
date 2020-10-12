import 'package:flutter/material.dart';

// this file isnt required anymore as we have other options to import

class ProductControl extends StatelessWidget {
  final Function addProduct;

  ProductControl(this.addProduct);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: Theme.of(context).primaryColor,
      onPressed: () {
        addProduct({'title': 'Chocolate', 'image': "assets/images/food.jpg"});
        //map title and products to share related information
      },
      child: Text("Click me to add"),
    );
  }
}
