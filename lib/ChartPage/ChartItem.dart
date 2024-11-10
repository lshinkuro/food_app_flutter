// cart_item.dart
import 'package:my_app/SearchPage/Food.dart';

class CartItem {
  final Food food;
  int quantity;

  CartItem({
    required this.food,
    this.quantity = 1,
  });

  double get totalPrice => food.price.toDouble() * quantity;

  Map<String, dynamic> toJson() {
    return {
      'food': {
        'name': food.name,
        'price': food.price,
        'category': food.category,
        'imageUrl': food.imageUrl,
        'description': food.description,
      },
      'quantity': quantity,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      food: Food(
        name: json['food']['name'],
        price: json['food']['price'],
        category: json['food']['category'],
        imageUrl: json['food']['imageUrl'],
        description: json['food']['description'],
      ),
      quantity: json['quantity'],
    );
  }
}
