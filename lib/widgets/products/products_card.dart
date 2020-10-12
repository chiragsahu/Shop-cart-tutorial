import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:test_prj/scoped_models/main.dart';
import '../../models/product.dart';

import './price_tag.dart';
import '../ui_elements/title.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final int productIndex;

  ProductCard(this.product, this.productIndex);

  Widget _buildTitlePriceRow() {
    return Container(
        padding: EdgeInsets.only(top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            ProductTitle(product.title),
            SizedBox(width: 8.0),
            PriceTag(product.price.toString())
          ],
        ));
  }

  Widget _buildAddressRow() {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 4.0),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 1.0),
            borderRadius: BorderRadius.circular(5.0)),
        child: Text('Bhilai, CG'));
  }

  Widget _buildButtonBar(BuildContext context, int index) {
    return ButtonBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
            icon: Icon(Icons.info),
            //bool will tell that future will return boolean value
            color: Theme.of(context).accentColor,
            onPressed: () => Navigator.pushNamed<bool>(
                context, '/product/' + productIndex.toString())
            //     .then((bool value) {
            //   if (value) {
            //   deleteProduct(index);
            //   }
            // }), //build context is required to get required data
            // see productpage in pages/product.dart it will build the product details on clicking
            ),
        ScopedModelDescendant(
            builder: (BuildContext context, Widget child, MainModel model) {
          return IconButton(
            icon: model.allProducts[index].favouriteProduct
                ? Icon(Icons.favorite)
                : Icon(Icons.favorite_border),
            //bool will tell that future will return boolean value
            color: Colors.red,
            onPressed: () {
              model.getProductIndex(index);
              model.toggleProduct();
            },
          );
        })
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          FadeInImage(
              placeholder: AssetImage('assets/images/food.jpg'),
              height: 300,
              fit: BoxFit.cover,
              image: NetworkImage(product.image)),
          _buildTitlePriceRow(),
          _buildAddressRow(),
          Text(product.email),
          _buildButtonBar(context, productIndex)
        ],
      ),
    );
  }
}
