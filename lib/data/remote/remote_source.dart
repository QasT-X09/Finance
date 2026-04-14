import 'package:finance/domain/entities/transaction.dart' as domain;
import 'package:finance/core/cancel_token.dart';

abstract class RemoteSource {
  /// Uploads a transaction to remote server. Returns true if upload succeeded.
  /// Optional [cancelToken] can be provided to request cancellation.
  Future<bool> uploadTransaction(domain.Transaction tx, {CancelToken? cancelToken});
}
