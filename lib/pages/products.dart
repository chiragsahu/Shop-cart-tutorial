import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:test_prj/scoped_models/main.dart';
import 'package:test_prj/widgets/products/products.dart';

// this is the homepage of the application

class ProductsPage extends StatefulWidget {
  final MainModel model;
  ProductsPage(this.model);
  @override
  State<StatefulWidget> createState() {
    return _ProductsPage();
  }
}

class _ProductsPage extends State<ProductsPage> {
  @override
  initState() {
    super.initState();
    widget.model.fetchProducts();
  }

  Widget _buildSideDrawer(BuildContext context) {
    return Drawer(
      //drawer is used for sidebar, Drawer is special widget
      child: Column(
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading:
                false, // to hide the hamburger icon on expanded sidebar
            title: Text("Choose"),
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text("Manage products"),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/admin');
            },
          )
        ],
      ),
    );
  }

  Widget _buildProduct() {
    return ScopedModelDescendant(
        builder: (BuildContext context, Widget child, MainModel model) {
      Widget content = Center(child: Text("Not found anything!"));
      if (model.displayProduct.length > 0 && !model.isLoading) {
        content = Products();
      } else if (model.isLoading) {
        content = Center(child: CircularProgressIndicator());
      }
      return RefreshIndicator(child: content, onRefresh: model.fetchProducts);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildSideDrawer(context),
      appBar: AppBar(
        title: Text('Food list'),
        actions: <Widget>[
          ScopedModelDescendant(
              builder: (BuildContext context, Widget child, MainModel model) {
            return IconButton(
                icon: Icon(model.displayFavorites
                    ? Icons.favorite
                    : Icons.favorite_border),
                onPressed: () {
                  model.toggleDisplayMode();
                });
          })
        ],
      ),
      body: _buildProduct(),
    );
  }
}

// class ProductsPage extends StatefulWidget {
//   final MainModel model;

//   ProductsPage(this.model);

//   @override
//   State<StatefulWidget> createState() {
//     return _ProductsPageState();
//   }
// }

// class _ProductsPageState extends State<ProductsPage> {
//   @override
//   initState() {
//     widget.model.fetchProduct();
//     super.initState();
//   }

//   Widget _buildSideDrawer(BuildContext context) {
//     return Drawer(
//       child: Column(
//         children: <Widget>[
//           AppBar(
//             automaticallyImplyLeading: false,
//             title: Text('Choose'),
//           ),
//           ListTile(
//             leading: Icon(Icons.edit),
//             title: Text('Manage Products'),
//             onTap: () {
//               Navigator.pushReplacementNamed(context, '/admin');
//             },
//           )
//         ],
//       ),
//     );
//   }

//   Widget _buildProductsList() {
//     return ScopedModelDescendant(
//       builder: (BuildContext context, Widget child, MainModel model) {
//         Widget content = Center(child: Text('No Products Found!'));
//         if (model.displayProduct.length > 0 && !model.isLoading) {
//           content = Products();
//         } else if (model.isLoading) {
//           content = Center(child: CircularProgressIndicator());
//         }
//         return RefreshIndicator(
//           onRefresh: model.fetchProduct,
//           child: content,
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       drawer: _buildSideDrawer(context),
//       appBar: AppBar(
//         title: Text('EasyList'),
//         actions: <Widget>[
//           ScopedModelDescendant<MainModel>(
//             builder: (BuildContext context, Widget child, MainModel model) {
//               return IconButton(
//                 icon: Icon(model.displayFavorites
//                     ? Icons.favorite
//                     : Icons.favorite_border),
//                 onPressed: () {
//                   model.toggleDisplayMode();
//                 },
//               );
//             },
//           )
//         ],
//       ),
//       body: _buildProductsList(),
//     );
//   }
// }
