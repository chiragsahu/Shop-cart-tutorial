import 'package:flutter/material.dart';

class Product {
  final String pdtId;
  final String title;
  final String description;
  final double price;
  final String image;
  final bool favouriteProduct;
  final String email;
  final String userId;

  Product(
      {@required this.pdtId,
      @required this.title,
      @required this.description,
      @required this.image,
      @required this.price,
      @required this.email,
      @required this.userId,
      this.favouriteProduct = false});
}
