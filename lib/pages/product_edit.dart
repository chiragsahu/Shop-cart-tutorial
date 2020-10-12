import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:test_prj/models/product.dart';
import 'package:test_prj/scoped_models/main.dart';

class ProductEditPage extends StatefulWidget {
  // converted to statefullwidget to get actions in same state

  

  @override
  State<StatefulWidget> createState() {
    return _ProductEditPage();
  }
}

class _ProductEditPage extends State<ProductEditPage> {
  final Map<String, dynamic> _formData = {
    'title': null,
    'description': null,
    'price': null,
    'image': "asset/images/foods.jpg"
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildPage(context, Product product) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    final double targetPadding = deviceWidth - targetWidth;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        // used for getting out of keyboard when tapping outside of the
        // focussed widget
      },
      child: Container(
        margin: EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: ListView(
              padding: EdgeInsets.symmetric(horizontal: targetPadding / 2),
              children: <Widget>[
                _buildTitleWidget(product),
                _buildDescription(product),
                _buildPriceInput(product),
                SizedBox(
                  height: 10.0,
                ),
                _buildSubmitButton()
              ]),
        ),
      ),
    );
  }

  Widget _buildTitleWidget(Product product) {
    return TextFormField(
      decoration: InputDecoration(labelText: "Product text"),
      // ignore: missing_return
      validator: (String value) {
        if (value.isEmpty || value.length < 5) {
          return 'Title cant be empty or atleast 5 characters!';
        }
      },
      initialValue: product == null ? '' : product.title,
      onSaved: (String value) {
        _formData['title'] = value;
      },
    );
  }

  Widget _buildDescription(Product product) {
    return TextFormField(
      keyboardType: TextInputType.multiline,
      maxLines: null,
      // inputFormatters: <TextInputFormatter>[
      //   LengthLimitingTextInputFormatter(5),
      //   WhitelistingTextInputFormatter.digitsOnly,
      //   BlacklistingTextInputFormatter.singleLineFormatter // to make input be in single line
      // ],
      decoration: InputDecoration(
        hintText: "Enter Description",
        labelText: "Description",
      ),
      initialValue: product == null ? '' : product.description,
      // ignore: missing_return
      validator: (String value) {
        if (value.isEmpty || value.length < 10) {
          return 'Description cant be empty or atleast 10 characters! ';
        }
      },
      onSaved: (String value) {
        _formData['description'] = value;
      },
    );
  }

  Widget _buildPriceInput(Product product) {
    return TextFormField(
      decoration: InputDecoration(labelText: "Price"),
      // ignore: missing_return
      validator: (String value) {
        if (value.isEmpty) {
          return 'Price should be an number!';
        }
      },
      keyboardType: TextInputType.number,
      inputFormatters: [
        WhitelistingTextInputFormatter.digitsOnly
      ], // using this allows to type/paste only numbers (text isnt pasted)
      initialValue: product == null ? '' : product.price.toString(),

      onSaved: (String value) {
        _formData['price'] = double.parse(value);
      },
    );
  }

  void _submitForm(
      Function addProduct, Function updateProduct, Function getSelectProduct,
      [int productIndex]) {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    if (productIndex == null) {
      print('it is null');
      addProduct(_formData['title'], _formData['description'],
              _formData['image'], _formData['price'])
          .then((_) => Navigator.pushReplacementNamed(context, "/products")
              .then((_) => getSelectProduct(null)));
    } else {

      updateProduct(_formData['title'], _formData['description'],
              _formData['image'], _formData['price'])
          .then((_) => Navigator.pushReplacementNamed(context, "/products")
              .then((_) => getSelectProduct(null)));
      ;
    }
  }

  Widget _buildSubmitButton() {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      ;
      return model.isLoading
          ? Center(child: CircularProgressIndicator())
          : RaisedButton(
              child: Text("Submit"),
              color: Theme.of(context).accentColor,
              textColor: Colors.white,
              //textColor: Theme.of(context).accentColor, this is theme color and using this will change button color everytime we change theme of the app
              onPressed: () {
                _submitForm(model.addProduct, model.updateProduct,
                    model.getProductIndex, model.selectedProductIndex);
              });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      final Widget pageContent = _buildPage(context, model.selectedProduct);

      return model.selectedProductIndex == null
          ? pageContent
          : Scaffold(
              appBar: AppBar(
                title: Text('Edit page'),
              ),
              body: pageContent,
            );
    });
  }
}

// // To print the value as soon as it is typed on the keyboard
// class _ProductCreatePage extends State<ProductCreatePage> {
//   String titleValue = '';
//   @override
//   Widget build(BuildContext context) {
//     return Column(children: <Widget>[
//       TextField(onChanged: (String value) {
//         setState(() {
//           titleValue = value;
//         });
//       }),
//       Text(titleValue)
//     ]);
//   }
// }

// To use modal use the following code:
//class ProductCreatePage extends StatelessWidget {
//   return Center(
//     child: RaisedButton(
//       child: Text("Save"),
//       onPressed: () {
//         showModalBottomSheet(
//           context: context,
//           builder: (BuildContext context) {
//             return Center(
//               child: Text("This is a Modal!"),
//             );
//           },
//         );
//       },
//     ),
//   );
// }
