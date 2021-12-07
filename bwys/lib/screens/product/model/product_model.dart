import 'package:flutter/material.dart';

class Product {
  int id;
  String title;
  String description;
  List<String> images;
  List<ProductSizes> sizes;
  double rating, price;
  num totalRating;
  double discount;
  bool isFavourite, isPopular;

  Product({
    required this.id,
    required this.images,
    required this.sizes,
    this.rating = 0.0,
    this.isFavourite = true,
    this.isPopular = false,
    required this.title,
    required this.totalRating,
    required this.price,
    required this.discount,
    required this.description,
  });
}

class ProductSizes {
  String size;
  int noOfPiece;
  bool isSelected;

  ProductSizes({
    required this.size,
    required this.noOfPiece,
    required this.isSelected,
  });
}

class ProductColor {
  Color color;
  bool isSelected;

  ProductColor({
    required this.color,
    this.isSelected = false,
  });
}
