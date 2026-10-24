# GoMitra

GoMitra is an Android-first Flutter prototype for helping airport travellers
discover people going to the same or nearby destinations and coordinate a
shared journey.

## Current prototype scope

- Mumbai CSMIA Terminal 1 and Terminal 2.
- Branded welcome/onboarding, demo entry, destination selection, local demo
  matches, group/meeting-point confirmation, local chat, trips, and profile.
- Fictional passengers and SQLite data stored on the device.
- Illustrative route graphics only. There is no live map, road routing, account
  service, cross-device matching, real-time chat, support queue, or ride
  provider integration.
- No payments are collected. The app does not verify identity, guarantee safety,
  quote a fare, or book a ride.

## Run locally

Requirements: Flutter stable, Dart SDK from the Flutter installation, Android
SDK and an Android emulator or physical device.

```powershell
flutter pub get
flutter analyze
flutter test
flutter run
```

To build a local debug APK:

```powershell
flutter build apk --debug
```

The generated APK is at
`build\app\outputs\flutter-apk\app-debug.apk`.

## Data and security notes

- The app features require no account, location permission, API key, phone
  number, or payment details. They do not access the network.
- Flutter's debug and profile manifests include the standard Internet
  permission needed for development tooling/hot reload. The main app manifest
  does not declare it; no production network feature is currently implemented.
- Fictional passenger fixtures and user-entered demo chat are stored in the
  app's private SQLite database on the device. Do not enter sensitive personal
  information. Demo messages are local prototype data, not end-to-end encrypted
  communications.
- Android app backup is disabled for this prototype. The database is not
  encrypted; this is not suitable for sensitive or production user data.
- SQL queries use bound arguments for user-provided values. The app does not
  connect to a backend, so server authorization, account security, moderation,
  and abuse controls remain future work.
- The release APK can be compiled but is intentionally unsigned until a
  production keystore is managed outside the repository. Debug signing is not
  configured as a release fallback; the unsigned release APK is not ready to
  distribute or install as a signed release. To sign a release build, provide
  `GOMITRA_KEYSTORE_PATH`, `GOMITRA_KEYSTORE_PASSWORD`, `GOMITRA_KEY_ALIAS`,
  and `GOMITRA_KEY_PASSWORD` through the build environment; do not commit these
  values or the keystore.

## Project structure

- `lib/screens/` — welcome, primary tabs, matching, group, and chat screens.
- `lib/services/local_store.dart` — local SQLite storage and demo fixtures.
- `lib/models.dart` — typed passenger, trip, and chat models.
- `lib/theme.dart` and `lib/widgets/` — GoMitra visual tokens and shared UI.
- `test/widget_test.dart` — demo journey and match ordering tests.

The phased implementation requirements are documented in
[GoMitra_Phased_Development_Roadmap.md](./GoMitra_Phased_Development_Roadmap.md).
