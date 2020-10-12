import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:test_prj/models/product.dart';
import 'package:test_prj/scoped_models/main.dart';
import 'dart:async';

import 'package:test_prj/widgets/ui_elements/title.dart';

class ProductPage extends StatelessWidget {
  final int index;
  ProductPage(this.index);

  // _showWarningDialog(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text("Are you sure?"),
  //         content: Text("This can't be undone"),
  //         actions: <Widget>[
  //           FlatButton(
  //             child: Text("DISCARD"),
  //             onPressed: () {
  //               Navigator.pop(context);
  //             },
  //           ),
  //           FlatButton(
  //             child: Text("CONFIRM"),
  //             onPressed: () {
  //               Navigator.pop(context);
  //               Navigator.pop(context, true);
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  Widget _buildAddress(double price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Bhilai, C.G.',
          style: TextStyle(fontFamily: 'Oswald', color: Colors.grey),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 5.0),
          child: Text(
            '|',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        Text(
          '\$' + price.toString(),
          style: TextStyle(fontFamily: 'Oswald', color: Colors.grey),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: () {
      Navigator.pop(context, false);
      return Future.value(
          false); //value is false because to not read the request by back button but to only read the custom request
    }, child: ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        final Product products = model.allProducts[index];
        return Scaffold(
          appBar: AppBar(
            title: Text(products.title),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.network(products.image),
              Container(
                  padding: EdgeInsets.all(10.0),
                  child: ProductTitle(products.title)),
              _buildAddress(products.price),
              Container(
                padding: EdgeInsets.all(10.0),
                //   child: RaisedButton(
                //       color: Theme.of(context).accentColor,
                //       child: Text("DELETE"),
                //       onPressed: () => _showWarningDialog(context)
                //       // returning true value so that it can be recorded as an event and used for deleting
                //       ),
                // )
                child: Text(products.description, textAlign: TextAlign.center),
              )
            ],
          ),
        );
      },
    ));
  }
}
