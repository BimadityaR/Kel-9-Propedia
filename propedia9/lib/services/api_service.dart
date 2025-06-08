import 'dart:convert';
import 'package:http/http.dart' as http;
import 'secure_storage.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.231.192:8000/api/v1';
  static const bool isDebug = true;

  static String? _token;

  // Inisialisasi token dari secure storage
  static Future<void> initialize() async {
    _token = await SecureStorage.getToken();
    if (isDebug) print('[ApiService] Token initialized: $_token');
  }

  // Ambil token jika belum ada
  static Future<String?> getToken() async {
    if (_token != null) return _token;
    _token = await SecureStorage.getToken();
    return _token;
  }

  /// Login user dan simpan token
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      print('[ApiService] Logging in with email: $email, password: $password');

      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({'email': email, 'password': password}),
      );

      print('[ApiService] Login response status code: ${response.statusCode}');
      print('[ApiService] Login response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['success'] == true) {
          final token = data['data']?['access_token'];
          if (token == null) {
            throw Exception('Token login tidak ditemukan di response');
          }
          _token = token;
          await SecureStorage.setToken(_token!);
          return data;
        } else {
          final message = data['message'] ?? 'Login failed';
          throw Exception(message);
        }
      } else {
        throw Exception(
          'Login failed with status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('[ApiService] Error during login: $e');
      throw Exception('Terjadi kesalahan saat login: $e');
    }
  }

  /// Register user baru
  static Future<http.Response> register({
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'email': email,
          'password': password,
          'role': role.toLowerCase(), // role sesuai enum Laravel
        }),
      );

      if (isDebug) {
        print('[ApiService] Register response: ${response.statusCode}');
        print('[ApiService] Body: ${response.body}');
      }

      return response;
    } catch (e) {
      throw Exception('Gagal mendaftar: $e');
    }
  }

  /// Logout: hapus token
  static Future<void> logout() async {
    _token = null;
    await SecureStorage.deleteToken();
    if (isDebug) print('[ApiService] Token dihapus dari storage');
  }

  /// GET request dengan token
  static Future<http.Response> protectedGet(String endpoint) async {
    final token = await getToken();
    if (token == null) throw Exception('Token tidak ditemukan');

    if (isDebug) print('[ApiService] GET $endpoint | Token: $token');

    return await http.get(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
  }

  /// POST request dengan token
  static Future<http.Response> protectedPost(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    final token = await getToken();
    if (token == null) throw Exception('Token tidak ditemukan');

    if (isDebug) {
      print('[ApiService] POST $endpoint | Token: $token');
      print('[ApiService] Body: $data');
    }

    return await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(data),
    );
  }

  /// PUT request dengan token
  static Future<http.Response> protectedPut(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    final token = await getToken();
    if (token == null) throw Exception('Token tidak ditemukan');

    if (isDebug) {
      print('[ApiService] PUT $endpoint | Token: $token');
      print('[ApiService] Body: $data');
    }

    return await http.put(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(data),
    );
  }

  // DELETE request dengan token
  static Future<http.Response> protectedDelete(String endpoint) async {
    final token = await getToken();
    if (token == null) throw Exception('Token tidak ditemukan');

    if (isDebug) print('[ApiService] DELETE $endpoint | Token: $token');

    return await http.delete(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
  }
}
