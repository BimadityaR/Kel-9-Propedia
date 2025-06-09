import 'dart:convert';
import 'package:http/http.dart' as http;
import 'secure_storage.dart';
import 'package:propedia9/models/property.dart';

class ApiService {
  static const String baseUrl = 'http://10.128.121.23:8000/api/v1';
  static const bool isDebug = true;
  static String? _token;

  /// Inisialisasi token dari secure storage
  static Future<void> initialize() async {
    _token = await SecureStorage.getToken();
    if (isDebug) print('Token initialized: $_token');
  }

  /// Ambil token terbaru dari storage jika belum tersedia
  static Future<String?> getToken() async {
    _token ??= await SecureStorage.getToken();
    return _token;
  }

  /// Login user dan simpan token, role, email
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode({'email': email, 'password': password}),
    );

    if (isDebug) print('Login Response: ${response.body}');

    final data = json.decode(response.body);

    if (response.statusCode == 200 && data['success'] == true) {
      final accessToken = data['data']['access_token'];
      await SecureStorage.setToken(accessToken);
      await SecureStorage.setRole(data['data']['role']);
      await SecureStorage.setEmail(email);
      _token = accessToken;
      return data;
    } else {
      throw Exception(data['message'] ?? 'Login gagal');
    }
  }

  /// Register user baru
  static Future<void> register({
    required String email,
    required String password,
    required String role,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode({'email': email, 'password': password, 'role': role}),
    );

    if (isDebug) print('Register Response: ${response.body}');

    if (response.statusCode != 201) {
      final errorData = json.decode(response.body);
      throw Exception(errorData['message'] ?? 'Registrasi gagal');
    }
  }

  /// Logout dan hapus semua data lokal
  static Future<void> logout() async {
    await SecureStorage.clearAll();
    _token = null;
  }

  /// Ambil properti berdasarkan role user
  static Future<List<Property>> getProperties() async {
    final token = await getToken();
    if (token == null) throw Exception('Token tidak tersedia');

    final response = await http.get(
      Uri.parse('$baseUrl/properties'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (isDebug) print('Get Properties Response: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List list = data['data'] ?? [];
      return list.map((json) => Property.fromJson(json)).toList();
    } else {
      throw Exception('Gagal mengambil data properti');
    }
  }

  /// Tambah properti baru
  static Future<void> addProperty(Map<String, dynamic> property) async {
    final token = await getToken();
    if (token == null) throw Exception('Token tidak tersedia');

    final response = await http.post(
      Uri.parse('$baseUrl/properties'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: json.encode(property),
    );

    if (isDebug) print('Add Property Response: ${response.body}');

    if (response.statusCode != 201) {
      try {
        final errorData = json.decode(response.body);
        final message = errorData['message'] ?? 'Gagal menambah properti';
        throw Exception(message);
      } catch (_) {
        throw Exception('Gagal menambah properti');
      }
    }
  }

  /// Update properti berdasarkan ID
  static Future<void> updateProperty(
    int id,
    Map<String, dynamic> property,
  ) async {
    final token = await getToken();
    if (token == null) throw Exception('Token tidak tersedia');

    final response = await http.put(
      Uri.parse('$baseUrl/properties/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: json.encode(property),
    );

    if (isDebug) print('Update Property Response: ${response.body}');

    if (response.statusCode != 200) {
      try {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Gagal mengupdate properti');
      } catch (_) {
        throw Exception('Gagal mengupdate properti');
      }
    }
  }

  /// Hapus properti berdasarkan ID
  static Future<void> deleteProperty(int id) async {
    final token = await getToken();
    if (token == null) throw Exception('Token tidak tersedia');

    final response = await http.delete(
      Uri.parse('$baseUrl/properties/$id'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (isDebug) print('Delete Property Response: ${response.body}');

    if (response.statusCode != 204) {
      try {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Gagal menghapus properti');
      } catch (_) {
        throw Exception('Gagal menghapus properti');
      }
    }
  }
}