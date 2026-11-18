import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../models/cart_item.dart';

class CartState extends ChangeNotifier {
  static final CartState _instance = CartState._internal();
  factory CartState() => _instance;
  CartState._internal();

  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  int get totalItemCount => _items.fold(0, (sum, item) => sum + item.cantidad);

  double get totalAmount => _items.fold(0.0, (sum, item) => sum + item.subtotal);

  String get totalAmountFormatted => "\$ ${totalAmount.toStringAsFixed(2)} USD";

  String get totalCOPFormatted {
    final valorCop = (totalAmount * 4000).round();
    final formatted = valorCop.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
    return "\$ $formatted COP";
  }

  void addItem(Product product, String talla) {
    final index = _items.indexWhere(
      (item) => item.product.id == product.id && item.talla == talla,
    );

    if (index >= 0) {
      _items[index].cantidad++;
    } else {
      _items.add(CartItem(product: product, talla: talla));
    }
    notifyListeners();
  }

  void removeItem(int index) {
    if (index >= 0 && index < _items.length) {
      _items.removeAt(index);
      notifyListeners();
    }
  }

  void incrementQuantity(int index) {
    if (index >= 0 && index < _items.length) {
      _items[index].cantidad++;
      notifyListeners();
    }
  }

  void decrementQuantity(int index) {
    if (index >= 0 && index < _items.length) {
      if (_items[index].cantidad > 1) {
        _items[index].cantidad--;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
