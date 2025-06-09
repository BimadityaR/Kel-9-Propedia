import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AddPropertyScreen extends StatefulWidget {
  const AddPropertyScreen({super.key});

  @override
  State<AddPropertyScreen> createState() => _AddPropertyScreenState();
}

class _AddPropertyScreenState extends State<AddPropertyScreen> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String price = '';
  String type = 'rumah';
  String description = '';
  String location = '';

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    // Parsing harga dengan lebih tepat: hilangkan titik sebagai ribuan, koma sebagai desimal
    String normalizedPrice = price.replaceAll('.', '').replaceAll(',', '.');
    double? priceValue = double.tryParse(normalizedPrice);

    if (priceValue == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Harga tidak valid')));
      return;
    }

    try {
      await ApiService.addProperty({
        'title': title,
        'price': priceValue,
        'type': type,
        'description': description,
        'location': location,
      });
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal menambah properti: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Properti')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Judul'),
                validator:
                    (v) => v == null || v.isEmpty ? 'Tidak boleh kosong' : null,
                onSaved: (v) => title = v ?? '',
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Harga'),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator:
                    (v) => v == null || v.isEmpty ? 'Tidak boleh kosong' : null,
                onSaved: (v) => price = v ?? '',
              ),
              DropdownButtonFormField<String>(
                value: type,
                items: const [
                  DropdownMenuItem(value: 'rumah', child: Text('Rumah')),
                  DropdownMenuItem(
                    value: 'apartemen',
                    child: Text('Apartemen'),
                  ),
                  DropdownMenuItem(value: 'tanah', child: Text('Tanah')),
                  DropdownMenuItem(value: 'ruko', child: Text('Ruko')),
                ],
                onChanged: (v) => setState(() => type = v ?? 'rumah'),
                decoration: const InputDecoration(labelText: 'Tipe'),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Deskripsi'),
                onSaved: (v) => description = v ?? '',
                maxLines: 3,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Lokasi'),
                validator:
                    (v) => v == null || v.isEmpty ? 'Tidak boleh kosong' : null,
                onSaved: (v) => location = v ?? '',
              ),
              const SizedBox(height: 24),
              ElevatedButton(onPressed: _submit, child: const Text('Simpan')),
            ],
          ),
        ),
      ),
    );
  }
}