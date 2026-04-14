import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finance/core/di/providers.dart';

class TransactionsScreen extends ConsumerWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final txState = ref.watch(transactionsNotifierProvider);
  final bg = ref.read(backgroundSyncProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Transactions'), actions: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            StreamBuilder<bool>(
          stream: bg.syncing,
          initialData: false,
          builder: (context, snap) {
            final syncing = snap.data ?? false;
            return IconButton(
              icon: syncing ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Icon(Icons.sync),
              tooltip: 'Sync now',
              onPressed: syncing
                  ? null
                  : () async {
                      final scaffold = ScaffoldMessenger.of(context);
                      scaffold.showSnackBar(const SnackBar(content: Text('Starting sync...')));
                      try {
                        await bg.triggerNow();
                        scaffold.showSnackBar(const SnackBar(content: Text('Sync completed')));
                        // refresh list
                        ref.read(transactionsNotifierProvider.notifier).refresh();
                      } catch (e) {
                        scaffold.showSnackBar(SnackBar(content: Text('Sync failed: $e')));
                      }
                    },
            );
          },
        ),
            IconButton(
              icon: const Icon(Icons.queue),
              tooltip: 'Show queue',
              onPressed: () {
                Navigator.of(context).pushNamed('/sync_queue');
              },
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              tooltip: 'Settings',
              onPressed: () {
                Navigator.of(context).pushNamed('/settings');
              },
            ),
          ],
        ),
      ]),
      body: SafeArea(
        child: txState.when(
          data: (list) => ListView.separated(
            itemCount: list.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final t = list[index];
              return ListTile(
                title: Text(t.description),
                subtitle: Text('${t.timestamp}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (t.pendingSync == true) ...[
                      const Icon(Icons.cloud_upload, color: Colors.orange, size: 18),
                      const SizedBox(width: 8),
                    ],
                    Text('${t.amount.toStringAsFixed(0)} ${t.currency}'),
                  ],
                ),
              );
            },
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, st) => Center(child: Text('Error: $e')),
        ),
      ),
    );
  }
}
