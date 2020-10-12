import 'package:flutter/material.dart';

import 'package:test_prj/pages/product_edit.dart';
import 'package:test_prj/pages/product_list.dart';
import 'package:test_prj/scoped_models/main.dart';

class ProductsAdminPage extends StatelessWidget {
  final MainModel model;
  ProductsAdminPage(this.model);

  Widget _buildSideDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading: false,
            title: Text("Choose"),
          ),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text("All products"),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/prodcuts');
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      // wraps the entire page
      length: 2,
      child: Scaffold(
        drawer: _buildSideDrawer(context),
        appBar: AppBar(
          title: Text("Manage products"),
          bottom: TabBar(
            // this will create tabs
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.create),
                text: ("create products"),
              ),
              Tab(
                icon: Icon(Icons.list),
                text: ("my products"),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            ProductEditPage(),
            ProductListPage(model)
          ], //amount of pages should be equal to the length
        ), // this will interact with the tabbarcontroller and load the right view acc to tab
      ),
    );
  }
}
