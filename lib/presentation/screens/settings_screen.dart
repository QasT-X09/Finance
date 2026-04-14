import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finance/core/auth/token_storage.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _controller = TextEditingController();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await TokenStorage.instance.init();
    _controller.text = TokenStorage.instance.token ?? '';
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _controller,
                    decoration: const InputDecoration(labelText: 'API Token (optional)'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      final scaffold = ScaffoldMessenger.of(context);
                      await TokenStorage.instance.setToken(_controller.text.trim().isEmpty ? null : _controller.text.trim());
                      scaffold.showSnackBar(const SnackBar(content: Text('Saved')));
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
            ),
    );
  }
}
