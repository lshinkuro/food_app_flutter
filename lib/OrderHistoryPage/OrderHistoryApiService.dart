import 'package:my_app/NetworkManager/NetworkManager.dart';
import 'package:my_app/OrderHistoryPage/OrderHistoryPage.dart';

// order_history_api_service.dart
class OrderHistoryApiService {
  final NetworkManager _networkManager = NetworkManager();

  // Get all food orders
  Future<List<FoodOrder>> getFoodsOrder() async {
    try {
      final response = await _networkManager.get('/foodsOrder');
      final List orderList = response['data'];
      print(orderList);
      return orderList.map((json) => FoodOrder.fromJson(json)).toList();
    } catch (e) {
      print("Error fetching food orders: $e");
      throw e;
    }
  }

  // Add new food order
  Future<FoodOrder> addFoodOrder(FoodOrder order) async {
    try {
      final response = await _networkManager.post(
        '/foodsOrder',
        body: order.toJson(),
      );
      return FoodOrder.fromJson(response);
    } catch (e) {
      print("Error adding food order: $e");
      throw e;
    }
  }
}
