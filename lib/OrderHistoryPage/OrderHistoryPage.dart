import 'package:flutter/material.dart';
import 'package:my_app/OrderHistoryPage/OrderHistoryApiService.dart';
import 'package:my_app/SearchPage/SearchPage.dart';

// Model untuk Order
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

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({Key? key}) : super(key: key);

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  final OrderHistoryApiService _foodHistoryApiService =
      OrderHistoryApiService();
  List<FoodOrder> _orders = [];
  bool _isLoading = false;
  OrderSort _currentSort = OrderSort.newest;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final foods = await _foodHistoryApiService.getFoodsOrder();
      setState(() {
        _orders = foods;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<FoodOrder> get _sortedOrders {
    final sorted = List<FoodOrder>.from(_orders);
    switch (_currentSort) {
      case OrderSort.newest:
        sorted.sort((a, b) => b.orderDate.compareTo(a.orderDate));
      case OrderSort.oldest:
        sorted.sort((a, b) => a.orderDate.compareTo(b.orderDate));
      case OrderSort.cheapest:
        sorted.sort((a, b) => a.totalPrice.compareTo(b.totalPrice));
      case OrderSort.expensive:
        sorted.sort((a, b) => b.totalPrice.compareTo(a.totalPrice));
    }
    return sorted;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Pesanan'),
        actions: [
          PopupMenuButton<OrderSort>(
            icon: const Icon(Icons.sort),
            initialValue: _currentSort,
            onSelected: (OrderSort sort) {
              setState(() {
                _currentSort = sort;
              });
            },
            itemBuilder: (BuildContext context) {
              return OrderSort.values.map((OrderSort sort) {
                return PopupMenuItem<OrderSort>(
                  value: sort,
                  child: Row(
                    children: [
                      Icon(
                        _getSortIcon(sort),
                        color: _currentSort == sort
                            ? Theme.of(context).primaryColor
                            : null,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        sort.name,
                        style: TextStyle(
                          color: _currentSort == sort
                              ? Theme.of(context).primaryColor
                              : null,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _orders.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.receipt_long_outlined,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Belum ada pesanan',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadOrders,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _sortedOrders.length,
                    itemBuilder: (context, index) {
                      final order = _sortedOrders[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      order.food
                                          .imageUrl, // Replace with the actual image URL
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Container(
                                          width: 80,
                                          height: 80,
                                          color: Colors.grey[300],
                                          child: const Icon(Icons.image),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          order.food.name,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${order.quantity}x . Rp ${order.totalPrice.toStringAsFixed(0)}',
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  _buildStatusChip(order.status),
                                ],
                              ),
                              const Divider(height: 24),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _formatDate(order.orderDate),
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      // Navigate to order detail
                                    },
                                    child: const Text('Lihat Detail'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }

  IconData _getSortIcon(OrderSort sort) {
    switch (sort) {
      case OrderSort.newest:
        return Icons.arrow_downward;
      case OrderSort.oldest:
        return Icons.arrow_upward;
      case OrderSort.cheapest:
        return Icons.money_off;
      case OrderSort.expensive:
        return Icons.money;
    }
  }

  Widget _buildStatusChip(String status) {
    Color color;
    String text;

    switch (status.toLowerCase()) {
      case 'completed':
        color = Colors.green;
        text = 'Selesai';
      case 'pending':
        color = Colors.orange;
        text = 'Diproses';
      case 'cancelled':
        color = Colors.red;
        text = 'Dibatalkan';
      default:
        color = Colors.grey;
        text = 'Unknown';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}';
  }
}
