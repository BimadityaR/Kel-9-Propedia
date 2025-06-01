import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  final LatLng _telkomLocation = LatLng(-6.973194, 107.630886);
  final LatLng _wisataLocation = LatLng(
    -6.832345,
    107.605065,
  ); // Farm House Lembang

  List<Marker> _markers = [];
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _markers.add(_createMarker(_telkomLocation, "Telkom University"));
  }

  Marker _createMarker(LatLng point, String title) {
    return Marker(
      width: 80.0,
      height: 80.0,
      point: point,
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder:
                (ctx) => AlertDialog(
                  title: Text("Lokasi"),
                  content: Text(title),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: const Text("Tutup"),
                    ),
                  ],
                ),
          );
        },
        child: const Icon(Icons.location_on, size: 40, color: Colors.red),
      ),
    );
  }

  void _moveToLocation(LatLng newPosition, String title) {
    _mapController.move(newPosition, 15);
    setState(() {
      _markers.add(_createMarker(newPosition, title));
    });
  }

  Future<void> _pickImage() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      final picker = ImagePicker();
      final pickedImage = await picker.pickImage(source: ImageSource.camera);
      if (pickedImage != null) {
        setState(() {
          _imageFile = File(pickedImage.path);
        });
      }
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Izin kamera ditolak")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Peta & Kamera')),
      body: Column(
        children: [
          Expanded(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _telkomLocation,
                initialZoom: 15,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: const ['a', 'b', 'c'],
                ),
                MarkerLayer(markers: _markers),
              ],
            ),
          ),
          if (_imageFile != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.file(_imageFile!, height: 150),
            ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "camera",
            onPressed: _pickImage,
            child: const Icon(Icons.camera_alt),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: "move",
            onPressed:
                () => _moveToLocation(_wisataLocation, "Farm House Lembang"),
            child: const Icon(Icons.map),
          ),
        ],
      ),
    );
  }
}
