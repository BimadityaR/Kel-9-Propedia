import 'package:flutter/material.dart';

class SellerHome extends StatelessWidget {
  const SellerHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agen Properti'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {}, // Navigasi ke tambah properti
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            'Properti Saya',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildPropertyItem(
            'Rumah Mewah',
            'Rp 1.5M',
            'Pending',
            Colors.orange,
          ),
          _buildPropertyItem('Apartemen', 'Rp 800Jt', 'Terjual', Colors.green),
          _buildPropertyItem('Tanah Kavling', 'Rp 500Jt', 'Aktif', Colors.blue),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {}, // Tambah properti
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildPropertyItem(
    String title,
    String price,
    String status,
    Color color,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: const Icon(Icons.home, size: 40),
        title: Text(title),
        subtitle: Text(price),
        trailing: Chip(
          label: Text(status),
          backgroundColor: color.withOpacity(0.2),
          labelStyle: TextStyle(color: color),
        ),
      ),
    );
  }
}
