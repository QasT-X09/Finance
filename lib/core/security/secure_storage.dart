import 'dart:convert';
import 'dart:typed_data';
import 'dart:math';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureKeyStorage {
  static const _keyName = 'hive_encryption_key_v1';
  final FlutterSecureStorage _secureStorage;

  SecureKeyStorage([FlutterSecureStorage? secureStorage]) : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  /// Returns 32 bytes key for HiveAesCipher as Uint8List
  Future<Uint8List> getOrCreateKey() async {
    final existing = await _secureStorage.read(key: _keyName);
    if (existing != null) {
      final bytes = base64Decode(existing);
      return Uint8List.fromList(bytes);
    }

    final key = _generateKey();
    await _secureStorage.write(key: _keyName, value: base64Encode(key));
    return Uint8List.fromList(key);
  }

  List<int> _generateKey() {
    // Use cryptographically secure RNG
    final rnd = Random.secure();
    final bytes = List<int>.generate(32, (_) => rnd.nextInt(256));
    return bytes;
  }
}
