import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const _storage = FlutterSecureStorage();

  static const _tokenKey = 'token';
  static const _emailKey = 'email';
  static const _roleKey = 'role';

  static Future<void> setToken(String token) =>
      _storage.write(key: _tokenKey, value: token);
  static Future<void> setEmail(String email) =>
      _storage.write(key: _emailKey, value: email);
  static Future<void> setRole(String role) =>
      _storage.write(key: _roleKey, value: role);

  static Future<String?> getToken() => _storage.read(key: _tokenKey);
  static Future<String?> getEmail() => _storage.read(key: _emailKey);
  static Future<String?> getRole() => _storage.read(key: _roleKey);

  static Future<void> clearAll() => _storage.deleteAll();
}