// Model untuk Order
import 'package:my_app/SearchPage/Food.dart';

class FoodOrder {
  final String id;
  final Food food;
  final int quantity;
  final double totalPrice;
  final DateTime orderDate;
  final String status; // pending, completed, cancelled

  FoodOrder({
    required this.id,
    required this.food,
    required this.quantity,
    required this.totalPrice,
    required this.orderDate,
    required this.status,
  });

  factory FoodOrder.fromJson(Map<String, dynamic> json) {
    return FoodOrder(
      id: json['id'] ?? '',
      food: Food.fromJson(json['food']),
      quantity: json['quantity'] ?? 0,
      totalPrice: (json['totalPrice'] ?? 0.0).toDouble(),
      orderDate: DateTime.parse(json['orderDate']),
      status: json['status'] ?? 'pending',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'food': food.toJson(),
      'quantity': quantity,
      'total_price': totalPrice,
      'order_date': orderDate.toIso8601String(),
      'status': status,
    };
  }
}

// Enum untuk tipe sorting
enum OrderSort {
  newest,
  oldest,
  cheapest,
  expensive;

  String get name {
    switch (this) {
      case OrderSort.newest:
        return 'Terbaru';
      case OrderSort.oldest:
        return 'Terlama';
      case OrderSort.cheapest:
        return 'Termurah';
      case OrderSort.expensive:
        return 'Termahal';
    }
  }
}
