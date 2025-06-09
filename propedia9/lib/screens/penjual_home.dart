import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'add_property_screen.dart';
import '../services/api_service.dart';

class SellerHome extends StatefulWidget {
  const SellerHome({super.key});

  @override
  State<SellerHome> createState() => _SellerHomeState();
}

class _SellerHomeState extends State<SellerHome> {
  List<dynamic> properties = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProperties();
  }

  Future<void> fetchProperties() async {
    setState(() => isLoading = true);
    try {
      final data = await ApiService.getProperties();
      setState(() {
        properties = data;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal mengambil properti: $e')));
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _logout() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Konfirmasi Logout'),
            content: const Text('Apakah Anda yakin ingin logout?'),
            actions: [
              TextButton(
                child: const Text('Tidak'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: const Text('Ya'),
                onPressed: () {
                  Navigator.of(context).pop(); // Tutup dialog
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                },
              ),
            ],
          ),
    );
  }

  void _goToAddProperty() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddPropertyScreen()),
    );
    if (result == true) {
      fetchProperties();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agen Properti'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black),
            onPressed: _logout,
          ),
        ],
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : properties.isEmpty
              ? const Center(child: Text('Belum ada properti.'))
              : ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: properties.length,
                itemBuilder: (context, index) {
                  final p = properties[index];

                  // Ambil status dan tentukan warna
                  String statusText = '-';
                  if (p is Map<String, dynamic>) {
                    statusText = p['status'] ?? '-';
                  } else {
                    statusText = p.status ?? '-';
                  }

                  Color statusColor;
                  switch (statusText.toLowerCase()) {
                    case 'pending':
                      statusColor = Colors.orange;
                      break;
                    case 'terjual':
                      statusColor = Colors.green;
                      break;
                    case 'aktif':
                      statusColor = Colors.blue;
                      break;
                    default:
                      statusColor = Colors.grey;
                  }

                  // Ambil title dan price dengan aman
                  String title =
                      p is Map<String, dynamic>
                          ? (p['title'] ?? '-')
                          : (p.title ?? '-');
                  String price =
                      p is Map<String, dynamic>
                          ? (p['price'] != null ? p['price'].toString() : '-')
                          : (p.price != null ? p.price.toString() : '-');

                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: ListTile(
                      leading: const Icon(Icons.home, size: 40),
                      title: Text(title),
                      subtitle: Text('Rp $price'),
                      trailing: Chip(
                        label: Text(statusText),
                        backgroundColor: statusColor.withOpacity(0.2),
                        labelStyle: TextStyle(color: statusColor),
                      ),
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToAddProperty,
        child: const Icon(Icons.add),
      ),
    );
  }
}