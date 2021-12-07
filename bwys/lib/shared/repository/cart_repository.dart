import 'package:bwys/screens/product/model/product_model.dart';

abstract class CartRepository {
  /// Cart List
  List<Product> get cartList => [];
  set cartListData(List<Product> data);

  /// Check if cart is empty
  bool get isEmpty => true;

  /// Find the number of items in the cart
  int get numOfItems => 0;
}

class CartRepositoryImpl extends CartRepository {
  List<Product> _cartList = [];

  @override
  List<Product> get cartList => _cartList;

  @override
  set cartListData(List<Product> data) {
    _cartList = data;
  }

  @override
  bool get isEmpty => _cartList.isEmpty;

  @override
  int get numOfItems => _cartList.length;

  double get totalPrice {
    double _totalPrice = 0.0;
    _cartList.forEach((i) {
      _totalPrice += i.price;
    });
    return _totalPrice;
  }

  String get formattedTotalPrice {
    return totalPrice.toString();
  }

  int get totalProductInCart => _cartList.length;

  bool isExists(Product item) {
    if (cartList.isEmpty) {
      return false;
    }
    final indexOfItem = cartList.indexWhere((i) => item.id == i.id);
    return indexOfItem >= 0;
  }

  void add(Product item) {
    if (!isExists(item)) {
      cartList.add(item);
    }
  }

  void remove(Product item) {
    if (cartList.isEmpty) return;
    final indexOfItem =
        cartList.indexWhere((i) => item.id == i.id && checkSizeEqual(item, i));
    if (indexOfItem >= 0) {
      cartList.removeAt(indexOfItem);
    }
  }

  bool checkSizeEqual(Product item, Product i) {
    for (int j = 0; j < i.sizes.length; j++) {
      if (item.sizes[j].isSelected != i.sizes[j].isSelected) {
        return false;
      }
    }
    return true;
  }

  Map<String, dynamic> get toMap {
    final List<Map<String, dynamic>> productList = this
        .cartList
        .map((i) => {
              'id': i.id,
              'name': i.title,
              'description': i.description,
              'price': i.price,
              'imageUrl': i.images[0]
            })
        .toList();
    return {"productList": productList, "total": this.totalPrice};
  }
}
