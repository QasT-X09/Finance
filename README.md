# Smart Finance Coach

This is a Flutter app (cross-platform) with an offline-first architecture.

Key features:

- Local storage with Hive (encrypted)
- Sync queue with pendingSync flag and retry/backoff
- Engines: Categorization, Decision, Behavioral, Simulation
- Riverpod for DI and state management

Quick start

1. Install Flutter and ensure PATH is set.
2. Fetch dependencies:

```bash
flutter pub get
```

3. Run tests and analyzer:

```bash
flutter test
flutter analyze
```

4. To run with a remote API endpoint and token (production):

```bash
flutter run --dart-define=API_URL=https://api.example.com/transactions --dart-define=API_TOKEN=YOUR_TOKEN
```

5. Build release with env:

```bash
flutter build apk --release --dart-define=API_URL=https://api.example.com/transactions --dart-define=API_TOKEN=$API_TOKEN
```

CI

A GitHub Actions workflow is provided at `.github/workflows/flutter-ci.yml` that runs analyzer, tests and builds a debug APK on pushes and PRs to main/master.

Native notifications (Android)

- There is a `MethodChannel` wrapper `lib/platform/notification_channel.dart`.
- To integrate native Android notification parsing, add a BroadcastReceiver or Service that parses the notification and calls the method channel with `onNotification` and a Map payload. Example Kotlin skeleton is in `docs/android-notification-sample.kt`.

If you want, I can scaffold the native Android files in `android/` and wire the MethodChannel — tell me and I will add the skeleton files and manifest snippets.
