// Buat class untuk handle API Food
import 'package:my_app/NetworkManager/NetworkManager.dart';
import 'package:my_app/SearchPage/Food.dart';

class FoodApiService {
  final NetworkManager _networkManager = NetworkManager();

  // Get all foods
  Future<List<Food>> getFoods() async {
    try {
      final response = await _networkManager.get('/foods');
      final List foodList = response['data'];

      return foodList
          .map((json) => Food(
                name: json['name'],
                price: json['price'],
                category: json['category'],
                imageUrl: json['image_url'],
                description: json['description'],
              ))
          .toList();
    } catch (e) {
      print("error ");
      throw e;
    }
  }

  // Add new food
  Future<Food> addFood(Food food) async {
    try {
      final response = await _networkManager.post('/foods', body: {
        'name': food.name,
        'price': food.price,
        'category': food.category,
        'image_url': food.imageUrl,
        'description': food.description,
      });

      return Food(
        name: response['name'],
        price: response['price'],
        category: response['category'],
        imageUrl: response['image_url'],
        description: response['description'],
      );
    } catch (e) {
      throw e;
    }
  }
}
