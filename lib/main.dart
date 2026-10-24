import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gomitra/screens/app_flow.dart';
import 'package:gomitra/services/local_store.dart';
import 'package:gomitra/theme.dart';
import 'package:gomitra/widgets/error_boundary.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // High-Level Global Exception & Crash Protection
  PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint('GoMitra Protected Event: $error');
    return true; // Prevents crash propagation
  };

  runApp(
    const GlobalErrorBoundary(
      child: StoreBootstrap(),
    ),
  );
}

class GoMitraApp extends StatelessWidget {
  const GoMitraApp({required this.store, super.key});

  final LocalStore store;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GoMitra',
      debugShowCheckedModeBanner: false,
      theme: buildGoMitraTheme(),
      home: AppFlow(store: store),
    );
  }
}

class StoreBootstrap extends StatefulWidget {
  const StoreBootstrap({super.key});

  @override
  State<StoreBootstrap> createState() => _StoreBootstrapState();
}

class _StoreBootstrapState extends State<StoreBootstrap> {
  late Future<LocalStore> _storeFuture;

  @override
  void initState() {
    super.initState();
    _storeFuture = SqliteStore.open();
  }

  void _retry() => setState(() => _storeFuture = SqliteStore.open());

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LocalStore>(
      future: _storeFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) return GoMitraApp(store: snapshot.data!);
        return MaterialApp(
          title: 'GoMitra',
          debugShowCheckedModeBanner: false,
          theme: buildGoMitraTheme(),
          home: Scaffold(
            backgroundColor: GoMitraColors.ink,
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: snapshot.hasError
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: GoMitraColors.red,
                            size: 48,
                          ),
                          const SizedBox(height: 14),
                          const Text(
                            'GoMitra could not open local storage.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${snapshot.error}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 20),
                          FilledButton(
                            onPressed: _retry,
                            style: FilledButton.styleFrom(
                              backgroundColor: GoMitraColors.green,
                            ),
                            child: const Text('Retry Connection'),
                          ),
                        ],
                      )
                    : const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(color: GoMitraColors.green),
                          SizedBox(height: 16),
                          Text(
                            'Initializing GoMitra Engine…',
                            style: TextStyle(color: Colors.white70, fontSize: 13),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        );
      },
    );
  }
}
