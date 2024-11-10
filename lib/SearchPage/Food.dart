// Model untuk data makanan
class Food {
  final String name;
  final int price;
  final String category;
  final String imageUrl;
  final String description;

  Food({
    required this.name,
    required this.price,
    required this.category,
    required this.imageUrl,
    required this.description,
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      name: json['name'] ?? '',
      price: json['price'] ?? 0,
      category: json['category'] ?? '',
      imageUrl: json['image_url'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'category': category,
      'image_url': imageUrl,
      'description': description,
    };
  }
}
