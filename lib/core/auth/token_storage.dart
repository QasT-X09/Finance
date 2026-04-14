import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  TokenStorage._internal();

  static final TokenStorage instance = TokenStorage._internal();

  final _storage = const FlutterSecureStorage();
  String? _token;

  String? get token => _token;

  Future<void> init() async {
    try {
      _token = await _storage.read(key: 'api_token');
    } catch (e) {
      // On tests or unsupported platforms, ignore
      if (kDebugMode) {
        // ignore
      }
      _token = null;
    }
  }

  Future<void> setToken(String? t) async {
    _token = t;
    if (t == null) {
      await _storage.delete(key: 'api_token');
    } else {
      await _storage.write(key: 'api_token', value: t);
    }
  }
}
