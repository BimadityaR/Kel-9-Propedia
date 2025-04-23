import 'package:flutter/material.dart';
import 'login_screen.dart';

class BuyerHome extends StatelessWidget {
  const BuyerHome({super.key});

  // Dummy data untuk properti
  final List<Map<String, dynamic>> houseProperties = const [
    {
      'image': 'assets/rumah_minimalis.jpg',
      'title': 'Rumah Minimalis',
      'price': 'Rp 1.2M',
      'location': 'Jakarta Selatan',
    },
    {
      'image': 'assets/rumah_minimalis2.jpg',
      'title': 'Rumah Taman',
      'price': 'Rp 1.8M',
      'location': 'Bandung',
    },
    {
      'image': 'assets/rumah_minimalis3.jpg',
      'title': 'Rumah Mewah',
      'price': 'Rp 3.5M',
      'location': 'Bogor',
    },
  ];

  final List<Map<String, dynamic>> apartmentProperties = const [
    {
      'image': 'assets/apartemen_elite.jpg',
      'title': 'Apartemen Elite',
      'price': 'Rp 900Jt',
      'location': 'Jakarta Pusat',
    },
    {
      'image': 'assets/apartemen_elite2.jpg',
      'title': 'Apartemen Modern',
      'price': 'Rp 750Jt',
      'location': 'Tangerang',
    },
    {
      'image': 'assets/apartemen_elite3.jpg',
      'title': 'Apartemen View Kota',
      'price': 'Rp 1.1M',
      'location': 'Surabaya',
    },
  ];

  final List<Map<String, dynamic>> landProperties = const [
    {
      'image': 'assets/tanah1.jpg',
      'title': 'Tanah Kavling',
      'price': 'Rp 500Jt',
      'location': 'Depok',
    },
    {
      'image': 'assets/tanah2.jpg',
      'title': 'Tanah Strategis',
      'price': 'Rp 800Jt',
      'location': 'Bekasi',
    },
  ];

  final List<Map<String, dynamic>> shopProperties = const [
    {
      'image': 'assets/ruko1.jpg',
      'title': 'Ruko Modern',
      'price': 'Rp 2.1M',
      'location': 'Jakarta Barat',
    },
    {
      'image': 'assets/ruko2.jpg',
      'title': 'Ruko Corner',
      'price': 'Rp 2.8M',
      'location': 'Tangerang Selatan',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Cari Properti'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Rumah'),
              Tab(text: 'Apartemen'),
              Tab(text: 'Tanah'),
              Tab(text: 'Ruko'),
            ],
            isScrollable: true,
          ),
        ),
        body: TabBarView(
          children: [
            _buildPropertyList(houseProperties),
            _buildPropertyList(apartmentProperties),
            _buildPropertyList(landProperties),
            _buildPropertyList(shopProperties),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.search),
        ),
      ),
    );
  }

  Widget _buildPropertyList(List<Map<String, dynamic>> properties) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: properties.length,
      itemBuilder: (context, index) {
        final property = properties[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: Image.asset(
                  property['image'],
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      property['title'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 16),
                        const SizedBox(width: 4),
                        Text(property['location']),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      property['price'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.favorite_border),
                          onPressed: () {},
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          child: const Text('Detail'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
