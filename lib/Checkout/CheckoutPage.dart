import 'package:flutter/material.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String selectedAddress = '';
  String selectedBank = '';
  final promoController = TextEditingController();
  bool isPromoApplied = false;

  // Daftar alamat dummy
  final List<Map<String, String>> addresses = [
    {
      'id': '1',
      'name': 'Rumah',
      'address': 'Jl. Contoh No. 123, Jakarta',
      'phone': '08123456789'
    },
    {
      'id': '2',
      'name': 'Kantor',
      'address': 'Jl. Bisnis No. 456, Jakarta',
      'phone': '08987654321'
    },
  ];

  // Daftar bank dummy
  final List<Map<String, dynamic>> banks = [
    {
      'id': '1',
      'name': 'BCA',
      'icon': 'assets/bca.png',
    },
    {
      'id': '2',
      'name': 'Mandiri',
      'icon': 'assets/mandiri.png',
    },
    {
      'id': '3',
      'name': 'BNI',
      'icon': 'assets/bni.png',
    },
  ];

  void applyPromoCode() {
    if (promoController.text.isNotEmpty) {
      // Implementasi logika promo di sini
      setState(() {
        isPromoApplied = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kode promo berhasil diterapkan!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bagian Alamat
            const Text(
              'Alamat Pengiriman',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: addresses.length,
              itemBuilder: (context, index) {
                final address = addresses[index];
                return RadioListTile(
                  value: address['id']!,
                  groupValue: selectedAddress,
                  title: Text(address['name']!),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(address['address']!),
                      Text(address['phone']!),
                    ],
                  ),
                  onChanged: (value) {
                    setState(() {
                      selectedAddress = value.toString();
                    });
                  },
                );
              },
            ),

            const SizedBox(height: 24),

            // Bagian Metode Pembayaran
            const Text(
              'Metode Pembayaran',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: banks.length,
              itemBuilder: (context, index) {
                final bank = banks[index];
                return RadioListTile(
                  value: bank['id']!,
                  groupValue: selectedBank,
                  title: Text(bank['name']!),
                  onChanged: (value) {
                    setState(() {
                      selectedBank = value.toString();
                    });
                  },
                );
              },
            ),

            const SizedBox(height: 24),

            // Bagian Kode Promo
            const Text(
              'Kode Promo',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: promoController,
                    decoration: const InputDecoration(
                      hintText: 'Masukkan kode promo',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: applyPromoCode,
                  child: const Text('Terapkan'),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Tombol Bayar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    (selectedAddress.isNotEmpty && selectedBank.isNotEmpty)
                        ? () {
                            // Implementasi proses pembayaran
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Memproses pembayaran...'),
                              ),
                            );
                          }
                        : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blue,
                ),
                child: const Text(
                  'Bayar Sekarang',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    promoController.dispose();
    super.dispose();
  }
}
