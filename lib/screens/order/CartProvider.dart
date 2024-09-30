import 'package:flutter/foundation.dart';

class CartProvider with ChangeNotifier {
  List<Map<String, dynamic>> _cartProducts = [];

  List<Map<String, dynamic>> get cartProducts => _cartProducts;

  void addProduct(Map<String, dynamic> newProduct) {
    int existingIndex = _cartProducts.indexWhere((product) => product['prdcode'] == newProduct['prdcode']);
    if (existingIndex != -1) {
      _cartProducts[existingIndex]['quantity'] += newProduct['quantity'];
    } else {
      _cartProducts.add(newProduct);
    }
    notifyListeners();
  }

  void removeProduct(int index) {
    _cartProducts.removeAt(index);
    notifyListeners();
  }

  void updateQuantity(int index, int newQuantity) {
    if (newQuantity == 0) {
      _cartProducts.removeAt(index);
    } else {
      _cartProducts[index]['quantity'] = newQuantity;
    }
    notifyListeners();
  }

  double get totalPrice {
    return _cartProducts.fold(0, (sum, item) {
      final price = num.tryParse(item['price'].toString()) ?? 0;
      final quantity = num.tryParse(item['quantity'].toString()) ?? 0;
      return sum + (price * quantity);
    });
  }

  void updateCart() {
    notifyListeners();
  }

  void clearCart() {
    _cartProducts.clear();
    notifyListeners();
  }
}
