import 'package:flutter/material.dart';
import 'package:my_app/ChartPage/ChartProvider.dart';
import 'package:my_app/Login/LoginViewController.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF4B3A),
          primary: const Color(0xFFFF4B3A),
        ),
        useMaterial3: true,
      ),
      home: const OnboardingPage(),
    );
  }
}

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingItem> _onboardingItems = [
    OnboardingItem(
      image:
          'https://www.savoryexperiments.com/wp-content/uploads/2024/07/Homemade-Italian-Sausage-32.jpg',
      title: 'Temukan Makanan Favoritmu',
      description:
          'Jelajahi berbagai pilihan makanan lezat dari restoran terbaik',
    ),
    OnboardingItem(
      image:
          'https://cdn1-production-images-kly.akamaized.net/m5Es7e9OWVFsHJE7idtl4E2EIL8=/800x450/smart/filters:quality(75):strip_icc():format(webp)/kly-media-production/medias/3184486/original/057993000_1595219338-pizza-slices-marble-chopping-board_23-2147926088.jpg',
      title: 'Pesan dengan Mudah',
      description:
          'Proses pemesanan yang cepat dan mudah, tinggal klik langsung antar',
    ),
    OnboardingItem(
      image:
          'https://asset.kompas.com/crops/zbmx5CMyQLbONPHVHv3Ip4Ax9lg=/12x51:892x637/1200x800/data/photo/2022/03/05/622358ed771fb.jpg',
      title: 'Pengiriman Cepat',
      description: 'Nikmati layanan pengiriman cepat langsung ke lokasi kamu',
    ),
  ];

  void _handleLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _onboardingItems.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return _buildOnboardingPage(_onboardingItems[index]);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // Page indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _onboardingItems.length,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 8,
                        width: _currentPage == index ? 24 : 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Login button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _handleLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Mulai Memesan',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Skip button
                  TextButton(
                    onPressed: _handleLogin,
                    child: const Text(
                      'Lewati',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOnboardingPage(OnboardingItem item) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(
            item.image,
            height: 300,
          ),
          const SizedBox(height: 48),
          Text(
            item.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            item.description,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class OnboardingItem {
  final String image;
  final String title;
  final String description;

  OnboardingItem({
    required this.image,
    required this.title,
    required this.description,
  });
}
