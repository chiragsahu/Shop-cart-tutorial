import 'dart:convert';

import 'package:scoped_model/scoped_model.dart';
import 'package:test_prj/models/product.dart';
import 'package:test_prj/models/user.dart';
import 'package:http/http.dart' as http;

class connectedProductModel extends Model {
  List<Product> _products = [];
  User _authenticatedUser;
  int _setIndex;
  bool _isLoading = false;

  Future<Null> addProduct(
      String title, String description, String image, double price) {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> productData = {
      'title': title,
      'description': description,
      'image':
          "https://www.heart.org/-/media/images/news/2019/february-2019/0212chocolate_sc.png",
      'price': price,
      'email': _authenticatedUser.email,
      'userId': _authenticatedUser.id
    };
    return http
        .post('https://products-43135.firebaseio.com/products.json',
            body: json.encode(productData))
        .then((http.Response val) {
      final Map<String, dynamic> data = json.decode(val.body);
      final Product newProduct = Product(
          pdtId: data['name'],
          title: title,
          description: description,
          image:
              'https://www.heart.org/-/media/images/news/2019/february-2019/0212chocolate_sc.png',
          price: price,
          email: _authenticatedUser.email,
          userId: _authenticatedUser.id);
      _products.add(newProduct);
      _isLoading = false;
      notifyListeners();
    });
  }
}

class ProductModel extends connectedProductModel {
  bool _showFavorite = false;

  List<Product> get allProducts {
    return List.from(_products);
  }

  List<Product> get displayProduct {
    if (_showFavorite) {
      return _products
          .where((Product product) => product.favouriteProduct)
          .toList();
    }
    return List.from(_products);
  }

  int get selectedProductIndex {
    return _setIndex;
  }

  Product get selectedProduct {
    if (selectedProductIndex == null) {
      return null;
    } else {
      return _products[selectedProductIndex];
    }
  }

  bool get displayFavorites {
    return _showFavorite;
  }

  // void addProduct(Product product) {
  //   setState(() {
  //     _products.add(product);
  //   });
  // }
  //  set state not required since not in stateful widget

  void deleteProduct() {
    _isLoading = true;
    final deletedProductId = selectedProduct.pdtId;
    _products.removeAt(selectedProductIndex);
    _setIndex = null;
    http
        .delete(
            'https://products-43135.firebaseio.com/products/${deletedProductId}.json')
        .then((http.Response response) {
      _isLoading = false;

      notifyListeners();
    });
    // _products.removeAt(_setIndex);
  }

  Future<Null> updateProduct(
      String title, String description, String image, double price) {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> updateData = {
      'title': title,
      'description': description,
      'image':
          "https://www.heart.org/-/media/images/news/2019/february-2019/0212chocolate_sc.png",
      'price': price.toString(),
      'email': selectedProduct.email,
      'userId': selectedProduct.userId
    };
    return http
        .put(
            "https://products-43135.firebaseio.com/products/${selectedProduct.pdtId}.json",
            body: json.encode(updateData))
        .then((http.Response response) {
      _isLoading = false;
      final Product upDproduct = Product(
          pdtId: selectedProduct.pdtId,
          title: title,
          description: description,
          image: 'https://www.heart.org/-/media/images/news/2019/february-2019/0212chocolate_sc.png',
          price: price,
          email: selectedProduct.email,
          userId: selectedProduct.userId);
      _products[selectedProductIndex] = upDproduct;
      notifyListeners();
    });
  }

  void getProductIndex(int productIndex) {
    _setIndex = productIndex;
    notifyListeners();
  }

  Future<void> fetchProducts() {
    _isLoading = true;
    notifyListeners();
    return http
        .get('https://products-43135.firebaseio.com/products.json')
        .then((http.Response response) {
      final List<Product> fetchedProduct = [];
      final Map<String, dynamic> recievedData = json.decode(response.body);
      if (recievedData == null) {
        _isLoading = false;
        notifyListeners();
        print("this is not working");
        return;
      }
      recievedData.forEach((String key, dynamic productData) {
        final Product product = Product(
            pdtId: key,
            title: productData['title'],
            description: productData['description'],
            image: productData['image'],
            price: productData['price'],
            email: productData['email'],
            userId: productData['userId']);
        print("this is working");
        fetchedProduct.add(product);
      });
      _products = fetchedProduct;
      _isLoading = false;
      notifyListeners();
    });
  }

  void toggleProduct() {
    final bool isCurrentlyFavorite = selectedProduct.favouriteProduct;
    final bool newFavoriteStatus = !isCurrentlyFavorite;
    final Product updatedProduct = Product(
        pdtId: selectedProduct.pdtId,
        title: selectedProduct.title,
        description: selectedProduct.description,
        image: selectedProduct.image,
        price: selectedProduct.price,
        favouriteProduct: newFavoriteStatus,
        email: selectedProduct.email,
        userId: selectedProduct.userId);
    _products[selectedProductIndex] = updatedProduct;
    notifyListeners();
  }

  void toggleDisplayMode() {
    _showFavorite = !_showFavorite;
    notifyListeners();
  }
}

class UserModel extends connectedProductModel {
  void login(String email, String pass) {
    _authenticatedUser = User(id: 'testid', email: email, pass: pass);
  }
}

class UtilityModel extends connectedProductModel {
  bool get isLoading {
    return _isLoading;
  }
}
