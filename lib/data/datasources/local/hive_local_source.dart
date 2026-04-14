import 'package:hive_flutter/hive_flutter.dart';
// 'hive_flutter' already exports core hive symbols.
import 'package:finance/core/security/secure_storage.dart';
import '../../models/transaction_model.dart';

class HiveLocalSource {
  static const String _boxName = 'transactions_box_v1';
  final SecureKeyStorage _keyStorage;
  bool _initialized = false;

  HiveLocalSource([SecureKeyStorage? keyStorage]) : _keyStorage = keyStorage ?? SecureKeyStorage();

  Future<void> init() async {
    if (_initialized) return;
    await Hive.initFlutter();
    final key = await _keyStorage.getOrCreateKey();
    final cipher = HiveAesCipher(key);
    await Hive.openBox(_boxName, encryptionCipher: cipher);
    _initialized = true;
  }

  Future<void> putTransaction(TransactionModel model) async {
    final box = Hive.box(_boxName);
    await box.put(model.id, model.toMap());
  }

  Future<List<TransactionModel>> getAllTransactions() async {
    final box = Hive.box(_boxName);
    final list = <TransactionModel>[];
    for (final v in box.values) {
      if (v is Map) {
        list.add(TransactionModel.fromMap(Map.from(v)));
      }
    }
    return list;
  }

  Future<void> deleteTransaction(String id) async {
    final box = Hive.box(_boxName);
    await box.delete(id);
  }

  Stream<List<TransactionModel>> watchTransactions() async* {
    final box = Hive.box(_boxName);
    yield await getAllTransactions();
    await for (final _ in box.watch()) {
      yield await getAllTransactions();
    }
  }
}
