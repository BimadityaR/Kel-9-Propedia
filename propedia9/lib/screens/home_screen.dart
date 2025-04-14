import 'package:flutter/material.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  final String userName;

  const HomeScreen({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            const Icon(Icons.home, color: Colors.lightBlue),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Hello, $userName',
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Search Box
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.lightBlueAccent.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              height: 60,
              child: Row(
                children: [
                  const Icon(Icons.search, color: Colors.white),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Search Your Dream Property Here',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Image.asset(
                    'assets/logo_propedia.jpg',
                    width: 30,
                    height: 30,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Categories
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCategory(Icons.apartment, 'Apartemen'),
                _buildCategory(Icons.house, 'Rumah'),
                _buildCategory(Icons.terrain, 'Tanah'),
              ],
            ),

            const SizedBox(height: 24),
            const Text(
              'Recommended For You',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Recommended List
            _buildRecommendationItem(
              'Foto 1',
              'Grand Palace',
              'Jakarta',
              'Rp 1.2 M',
              'Apartemen',
            ),
            _buildRecommendationItem(
              'Foto 2',
              'Green Park',
              'Bandung',
              'Rp 900 Juta',
              'Rumah',
            ),
            _buildRecommendationItem(
              'Foto 3',
              'Bukit Indah',
              'Bogor',
              'Rp 500 Juta',
              'Tanah',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategory(IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.lightBlueAccent,
          child: Icon(icon, size: 28, color: Colors.white),
        ),
        const SizedBox(height: 8),
        Text(label),
      ],
    );
  }

  Widget _buildRecommendationItem(
    String foto,
    String nama,
    String lokasi,
    String harga,
    String tipe,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            color: Colors.grey,
            child: Center(
              child: Text(foto, style: const TextStyle(color: Colors.white)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(nama, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(lokasi),
                Text(harga),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.lightBlue,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(tipe, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
