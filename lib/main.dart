import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:test_prj/pages/auth.dart';
import 'package:test_prj/pages/product.dart';
import 'package:test_prj/pages/product_admin.dart';
import 'package:test_prj/pages/products.dart';
import 'package:test_prj/scoped_models/main.dart';

//this is the first file, in this we will create myapp class which will have
// many states,

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyApp();
  }
}

class _MyApp extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final MainModel model = MainModel();
    return ScopedModel<MainModel>(
        model: model, //here we instantiate the model
        // only one instance is created when the app starts and that is
        //passed down through the widgets
        child: MaterialApp(
          //home: AuthPage(),
          theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.deepOrange,
            accentColor: Colors.deepPurple,
          ),
          routes: {
            '/': (BuildContext context) => AuthPage(),

            '/admin': (BuildContext context) => ProductsAdminPage(model),
            '/products': (BuildContext context) => ProductsPage(model),
            // creating new products page in productsadminpage from now on, instead of ProductsPage, therefore moving the req. params
          },
          //input automatically provided by flutter {
          onGenerateRoute: (RouteSettings settings) {
            final List<String> pathElements = settings.name.split('/');
            if (pathElements[0] != '') return null;
            if (pathElements[1] == 'product') {
              final int index = int.parse(pathElements[2]);
              return MaterialPageRoute<bool>(
                // route is pushed not the page
                builder: (BuildContext build) => ProductPage(index),
              );
            }
            return null;
          },
          onUnknownRoute: //this route is used a fallback route for ongenerate route
              (RouteSettings settings) {
            return MaterialPageRoute(
              builder: (BuildContext context) => ProductsPage(model),
            );
          },
        ));
  }
}
