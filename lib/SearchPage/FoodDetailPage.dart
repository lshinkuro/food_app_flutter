import 'package:flutter/material.dart';
import 'package:my_app/ChartPage/ChartPage.dart';
import 'package:my_app/ChartPage/ChartProvider.dart';
import 'package:my_app/SearchPage/Food.dart';
import 'package:provider/provider.dart';

class FoodDetailPage extends StatelessWidget {
  final Food food;

  const FoodDetailPage({Key? key, required this.food}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CartProvider()..loadCart(),
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            // App Bar with Image
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Image.network(
                  food.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.image,
                        size: 100,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.favorite_border),
                  onPressed: () {
                    // TODO: Implement favorite functionality
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () {
                    // TODO: Implement share functionality
                  },
                ),
              ],
            ),

            // Content
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name and Price
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            food.name,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          'Rp ${food.price.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Category
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        food.category,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Description Title
                    const Text(
                      'Deskripsi',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Description
                    Text(
                      food.description,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Additional Info
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildInfoItem(
                            icon: Icons.access_time,
                            label: '20-30 min',
                            subtitle: 'Delivery',
                          ),
                          _buildInfoItem(
                            icon: Icons.star,
                            label: '4.5',
                            subtitle: 'Rating',
                          ),
                          _buildInfoItem(
                            icon: Icons.local_fire_department,
                            label: '150 kkal',
                            subtitle: 'Calories',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 100), // Space for bottom button
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: Consumer<CartProvider>(
          builder: (context, cart, child) {
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        cart.addItem(food);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('${food.name} ditambahkan ke keranjang'),
                            action: SnackBarAction(
                              label: 'LIHAT KERANJANG',
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const CartPage(),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Tambah ke Keranjang',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String subtitle,
  }) {
    return Column(
      children: [
        Icon(icon, color: Colors.grey[600]),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          subtitle,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
