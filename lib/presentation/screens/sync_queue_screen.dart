import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finance/core/di/providers.dart';
import 'package:finance/core/cancel_token.dart';

class SyncQueueScreen extends ConsumerWidget {
  const SyncQueueScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.read(transactionRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sync Queue'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            tooltip: 'Retry all',
            onPressed: () async {
              final messenger = ScaffoldMessenger.of(context);
              final remote = ref.read(remoteSourceProvider);
              final repo = ref.read(transactionRepositoryProvider);

              final pending = await repo.getPendingTransactions();
              if (!context.mounted) return;
              if (pending.isEmpty) {
                messenger.showSnackBar(const SnackBar(content: Text('No pending transactions')));
                return;
              }

              // show progress dialog and use SyncService
              int done = 0;
              int total = pending.length;
              final cancelToken = CancelToken();
              final sync = ref.read(syncServiceProvider);
              showDialog<void>(
                context: context,
                barrierDismissible: false,
                builder: (dialogCtx) {
                  // start upload when dialog builds
                  sync.uploadBatch(pending, concurrency: 3, cancelToken: cancelToken, onProgress: (d, t) {
                    done = d;
                    if (dialogCtx.mounted) {
                      // force rebuild of dialog by using StatefulBuilder
                      (dialogCtx as Element).markNeedsBuild();
                    }
                  }).then((res) async {
                    if (dialogCtx.mounted) Navigator.of(dialogCtx).pop();
                    await ref.read(transactionsNotifierProvider.notifier).refresh();
                    if (!context.mounted) return;
                    if (cancelToken.isCancelled) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Cancelled after $done of $total')));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Uploaded ${res.successIds.length} of $total, failed ${res.failedIds.length}')));
                      if (res.failedIds.isNotEmpty && context.mounted) {
                        showModalBottomSheet<void>(
                          context: context,
                          builder: (sheetCtx) {
                            return Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Failed uploads (${res.failedIds.length})', style: const TextStyle(fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 8),
                                  SizedBox(
                                    height: 120,
                                    child: ListView.separated(
                                      itemCount: res.failedIds.length,
                                      separatorBuilder: (_, __) => const Divider(height: 1),
                                      itemBuilder: (_, i) => ListTile(
                                        dense: true,
                                        title: Text(res.failedIds[i]),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                        onPressed: () => Navigator.of(sheetCtx).pop(),
                                        child: const Text('Close'),
                                      ),
                                      const SizedBox(width: 8),
                                      ElevatedButton(
                                        onPressed: () async {
                                          final sheetMessenger = ScaffoldMessenger.of(context);
                                          final pendingNow = await repo.getPendingTransactions();
                                          final toRetry = pendingNow.where((p) => res.failedIds.contains(p.id)).toList();
                                          var retried = 0;
                                          for (final p in toRetry) {
                                            final ok2 = await remote.uploadTransaction(p);
                                            if (ok2) {
                                              await repo.markSynced(p.id);
                                              retried += 1;
                                            }
                                          }
                                          await ref.read(transactionsNotifierProvider.notifier).refresh();
                                          if (context.mounted) {
                                            sheetMessenger.showSnackBar(SnackBar(content: Text('Retried $retried of ${toRetry.length}')));
                                          }
                                          if (sheetCtx.mounted) Navigator.of(sheetCtx).pop();
                                        },
                                        child: const Text('Retry failed'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }
                    }
                  });

                  return StatefulBuilder(builder: (context, setState) {
                    return AlertDialog(
                      title: const Text('Retrying uploads'),
                      content: SizedBox(
                        height: 100,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            LinearProgressIndicator(value: total == 0 ? 0 : done / total),
                            const SizedBox(height: 12),
                            Text('$done of $total processed'),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            cancelToken.cancel();
                          },
                          child: const Text('Cancel'),
                        ),
                      ],
                    );
                  });
                },
              );
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: repo.getPendingTransactions(),
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) return const Center(child: CircularProgressIndicator());
          final list = snap.data as List? ?? [];
          if (list.isEmpty) return const Center(child: Text('No pending transactions'));
          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: list.length,
            separatorBuilder: (_, __) => const SizedBox(height: 0),
            itemBuilder: (context, idx) {
              final tx = list[idx];

              String currencySymbol(String c) {
                switch (c.toLowerCase()) {
                  case 'kzt':
                  case 'тенге':
                  case 'tg':
                    return '₸';
                  case 'rub':
                  case 'рубль':
                  case 'rur':
                    return '₽';
                  case 'eur':
                    return '€';
                  case 'usd':
                  default:
                    return r'$';
                }
              }

              final sym = currencySymbol(tx.currency ?? tx.currency.toString());

              return Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  child: Row(
                    children: [
                      // status indicator
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(colors: [Color(0xFF6C7CFF), Color(0xFF4A3DFF)]),
                        ),
                        child: const Icon(Icons.sync, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(tx.description, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 4),
                            Text(tx.timestamp.toLocal().toString().split('.').first, style: const TextStyle(fontSize: 12, color: Colors.white70)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('$sym${tx.amount.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.refresh, color: Colors.white70),
                                tooltip: 'Retry upload',
                                onPressed: () async {
                                  final remote = ref.read(remoteSourceProvider);
                                  final messenger = ScaffoldMessenger.of(context);
                                  final ok = await remote.uploadTransaction(tx);
                                  if (!context.mounted) return;
                                  if (ok) {
                                    await ref.read(transactionRepositoryProvider).markSynced(tx.id);
                                    messenger.showSnackBar(const SnackBar(content: Text('Uploaded')));
                                    await ref.read(transactionsNotifierProvider.notifier).refresh();
                                  } else {
                                    messenger.showSnackBar(const SnackBar(content: Text('Upload failed')));
                                  }
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_forever, color: Colors.redAccent),
                                tooltip: 'Skip and remove from queue',
                                onPressed: () async {
                                  final messenger = ScaffoldMessenger.of(context);
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: const Text('Remove from queue?'),
                                      content: const Text('This will remove the transaction from the sync queue (it will remain locally). Continue?'),
                                      actions: [
                                        TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel')),
                                        TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Remove')),
                                      ],
                                    ),
                                  );
                                  if (confirm != true) return;
                                  if (!context.mounted) return;
                                  messenger.showSnackBar(const SnackBar(content: Text('Removed from queue')));
                                  await ref.read(transactionRepositoryProvider).markSynced(tx.id);
                                  await ref.read(transactionsNotifierProvider.notifier).refresh();
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
