import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finance/data/datasources/local/hive_local_source.dart';
import 'package:finance/data/repositories/transaction_repository_impl.dart';
import 'package:finance/domain/repositories/transaction_repository.dart';
import 'package:finance/domain/entities/transaction.dart';
import 'package:finance/data/remote/remote_source_stub.dart';
import 'package:finance/data/remote/remote_source.dart';
import 'package:finance/data/remote/remote_source_http.dart';
import 'package:finance/core/sync/background_sync.dart';
import 'package:finance/core/sync/sync_service.dart';
// configuration via dart-define handled when constructing providers; no runtime Platform needed here.

final hiveLocalSourceProvider = Provider<HiveLocalSource>((ref) {
  return HiveLocalSource();
});

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  final local = ref.read(hiveLocalSourceProvider);
  return TransactionRepositoryImpl(local);
});

final remoteSourceProvider = Provider<RemoteSource>((ref) {
  // Read endpoint/token from dart-define environment variables at build time.
  final endpoint = const String.fromEnvironment('API_URL', defaultValue: '');
  final token = const String.fromEnvironment('API_TOKEN', defaultValue: '');
  if (endpoint.isNotEmpty) {
    return RemoteSourceHttp(endpoint: Uri.parse(endpoint), authToken: token.isNotEmpty ? token : null);
  }
  // fallback to stub during local development
  return RemoteSourceStub();
});

final backgroundSyncProvider = Provider<BackgroundSyncService>((ref) {
  final repo = ref.read(transactionRepositoryProvider);
  final remote = ref.read(remoteSourceProvider);
  return BackgroundSyncService(repo, remote);
});

final syncServiceProvider = Provider<SyncService>((ref) {
  final repo = ref.read(transactionRepositoryProvider);
  final remote = ref.read(remoteSourceProvider);
  return SyncService(repo, remote);
});

// platform notification channel wrapper provider (exposes nothing by default)
final notificationChannelProvider = Provider((ref) => null);

final transactionsNotifierProvider = StateNotifierProvider<TransactionsNotifier, AsyncValue<List<Transaction>>>((ref) {
  final repo = ref.read(transactionRepositoryProvider);
  return TransactionsNotifier(repo);
});

class TransactionsNotifier extends StateNotifier<AsyncValue<List<Transaction>>> {
  final TransactionRepository _repo;

  TransactionsNotifier(this._repo) : super(const AsyncValue.loading()) {
    _load();
  }

  Future<void> _load() async {
    try {
      final list = await _repo.getTransactions();
      if (list.isEmpty) {
        // seed with mock data (domain-aware, not UI)
        final now = DateTime.now();
        final sample = Transaction(id: 's1', amount: 3500.0, currency: 'KZT', timestamp: now.subtract(const Duration(days: 1)), description: 'Kaspi: Покупка 3500₸ Magnum');
        await _repo.addTransaction(sample);
        final reloaded = await _repo.getTransactions();
        state = AsyncValue.data(reloaded);
      } else {
        state = AsyncValue.data(list);
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> refresh() async => _load();

  Future<void> add(Transaction tx) async {
    await _repo.addTransaction(tx);
    await _load();
  }
}
