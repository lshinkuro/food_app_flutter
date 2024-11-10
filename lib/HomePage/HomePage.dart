import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_app/ChartPage/ChartPage.dart';
import 'package:my_app/ChartPage/ChartProvider.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Consumer<CartProvider>(
              builder: (context, cart, child) {
                return badges.Badge(
                  position: badges.BadgePosition.topEnd(top: 0, end: 3),
                  badgeContent: Text(
                    cart.foodItemCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                  badgeStyle: const badges.BadgeStyle(
                    badgeColor: Colors.red,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CartPage(),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner Promosi
            Container(
              margin: const EdgeInsets.only(bottom: 16.0),
              width: double.infinity,
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color: Colors.orange,
                image: const DecorationImage(
                  image: AssetImage(
                      'assets/images/ads1.jpg'), // Ganti dengan path gambar banner
                  fit: BoxFit.cover,
                ),
              ),
              alignment: Alignment.center,
              child: const Text(
                'Promo Diskon 50%',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Kategori Makanan
            const Text(
              'Kategori',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildCategoryCard('Pizza', Icons.local_pizza, Colors.red),
                  _buildCategoryCard('Burger', Icons.fastfood, Colors.amber),
                  _buildCategoryCard('Sushi', Icons.rice_bowl, Colors.green),
                  _buildCategoryCard('Ice Cream', Icons.icecream, Colors.blue),
                ],
              ),
            ),

            const SizedBox(height: 16.0),

            // Makanan Populer
            const Text(
              'Populer',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 5,
              itemBuilder: (context, index) {
                return _buildFoodItem(
                  'Food Item ${index + 1}',
                  'Deskripsi singkat dari makanan ${index + 1}',
                  'assets/images/ads1.jpg', // Ganti dengan path gambar makanan
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk Kategori Makanan
  Widget _buildCategoryCard(String title, IconData icon, Color color) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 8.0),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: color),
          const SizedBox(height: 8.0),
          Text(
            title,
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // Widget untuk Item Makanan Populer
  Widget _buildFoodItem(String title, String description, String imagePath) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Image.asset(
          imagePath,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
        trailing: IconButton(
          icon: const Icon(Icons.add_shopping_cart),
          onPressed: () {
            // Aksi saat item ditambahkan ke keranjang
          },
        ),
      ),
    );
  }
}
