// cart_provider.dart
import 'package:flutter/material.dart';
import 'package:my_app/ChartPage/ChartItem.dart';
import 'package:my_app/SearchPage/Food.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CartProvider extends ChangeNotifier {
  List<CartItem> _items = [];

  List<CartItem> get items => _items;

  double get totalAmount =>
      _items.fold(0, (sum, item) => sum + item.totalPrice);

  Future<void> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cartData = prefs.getString('cart');
    if (cartData != null) {
      final List cartList = json.decode(cartData);
      _items = cartList.map((item) => CartItem.fromJson(item)).toList();
      notifyListeners();
    }
  }

  Future<void> saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cartData = json.encode(_items.map((item) => item.toJson()).toList());
    await prefs.setString('cart', cartData);
  }

  void addItem(Food food) {
    final existingIndex =
        _items.indexWhere((item) => item.food.name == food.name);
    if (existingIndex >= 0) {
      _items[existingIndex].quantity += 1;
    } else {
      _items.add(CartItem(food: food));
    }
    print("ke save cuy");
    saveCart();
    notifyListeners();
  }

  void removeItem(String foodName) {
    _items.removeWhere((item) => item.food.name == foodName);
    saveCart();
    notifyListeners();
  }

  void updateQuantity(String foodName, int quantity) {
    if (quantity <= 0) {
      removeItem(foodName);
      return;
    }

    final index = _items.indexWhere((item) => item.food.name == foodName);
    if (index >= 0) {
      _items[index].quantity = quantity;
      saveCart();
      notifyListeners();
    }
  }
}
