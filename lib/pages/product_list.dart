import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:test_prj/pages/product_edit.dart';
import 'package:test_prj/scoped_models/main.dart';

class ProductListPage extends StatefulWidget {
  final MainModel model;

  ProductListPage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _ProductListPage();
  }
}

class _ProductListPage extends State<ProductListPage> {
  @override
  // ignore: override_on_non_overriding_member
  initstate() {
    
    super.initState();
    widget.model.fetchProducts();
  }

  Widget _buildIconButton(BuildContext context, int index, MainModel model) {
    return IconButton(
      icon: Icon(Icons.edit),
      onPressed: () {
        model.getProductIndex(index);
        Navigator.of(context).push(
          MaterialPageRoute(builder: (BuildContext context) {
            return ProductEditPage();
          }),
        );
      },
    );
  }

  // Widget _buildAvatar(int index, products) {
  //   return CircleAvatar(backgroundImage: AssetImage(products[index].image));
  // }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
              key: Key(model.allProducts[index].title),
              background: Container(
                color: Colors.red,
              ),
              onDismissed: (DismissDirection direction) {
                if (direction == DismissDirection.endToStart) {
                  model.getProductIndex(index);
                  model.deleteProduct();
                }
              },
              child: ListTile(
                leading: CircleAvatar(
                    backgroundImage:
                        NetworkImage(model.allProducts[index].image)),
                title: Text(model.allProducts[index].title),
                subtitle:
                    Text('\$${model.allProducts[index].price.toString()}'),
                trailing: _buildIconButton(context, index, model),
              ));
        },
        itemCount: model.allProducts.length,
      );
    });
  }
}
