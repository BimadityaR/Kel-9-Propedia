import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'dart:convert';
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
    try {
      final response = await ApiService.protectedGet('properties');
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          properties = data;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load properties');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Tampilkan error atau log
      print('Error fetching properties: $e');
    }
  }

  void _showAddPropertyDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final titleController = TextEditingController();
        final priceController = TextEditingController();
        final typeController = TextEditingController();
        final locationController = TextEditingController();
        final descriptionController = TextEditingController();

        return AlertDialog(
          title: const Text('Tambah Properti Baru'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: priceController,
                  decoration: const InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: typeController,
                  decoration: const InputDecoration(
                    labelText: 'Type (rumah, apartemen, tanah, ruko)',
                  ),
                ),
                TextField(
                  controller: locationController,
                  decoration: const InputDecoration(labelText: 'Location'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                if (titleController.text.isEmpty ||
                    priceController.text.isEmpty ||
                    typeController.text.isEmpty ||
                    locationController.text.isEmpty) {
                  // Bisa tampilkan pesan error
                  return;
                }
                try {
                  final response =
                      await ApiService.protectedPost('properties', {
                        'title': titleController.text,
                        'price': double.parse(priceController.text),
                        'type': typeController.text,
                        'location': locationController.text,
                        'description': descriptionController.text,
                      });

                  print('Response status: ${response.statusCode}');
                  print('Response body: ${response.body}');

                  if (response.statusCode == 201) {
                    Navigator.of(context).pop();
                    fetchProperties(); // Refresh data properti
                  } else {
                    print('Failed to add property: ${response.body}');
                  }
                } catch (e) {
                  print('Error adding property: $e');
                }
              },
              child: const Text('Tambah'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agen Properti'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black),
            onPressed: () {
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
                            Navigator.of(context).pop();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const LoginScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
              );
            },
          ),
        ],
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : properties.isEmpty
              ? const Center(child: Text('Belum ada properti'))
              : ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: properties.length,
                itemBuilder: (context, index) {
                  final property = properties[index];
                  return _buildPropertyItem(
                    property['title'] ?? 'No Title',
                    'Rp ${property['price'] ?? '-'}',
                    property['status'] ?? 'Unknown',
                    _statusColor(property['status']),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddPropertyDialog,
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

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'aktif':
        return Colors.blue;
      case 'pending':
        return Colors.orange;
      case 'terjual':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
