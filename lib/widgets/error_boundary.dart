import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../theme.dart';

class GlobalErrorBoundary extends StatefulWidget {
  const GlobalErrorBoundary({required this.child, super.key});

  final Widget child;

  @override
  State<GlobalErrorBoundary> createState() => _GlobalErrorBoundaryState();
}

class _GlobalErrorBoundaryState extends State<GlobalErrorBoundary> {
  FlutterExceptionHandler? _oldOnError;

  @override
  void initState() {
    super.initState();
    _oldOnError = FlutterError.onError;
    FlutterError.onError = (details) {
      FlutterError.presentError(details);
      _oldOnError?.call(details);
    };
  }

  @override
  Widget build(BuildContext context) {
    return ErrorWidgetBuilder(child: widget.child);
  }
}

class ErrorWidgetBuilder extends StatefulWidget {
  const ErrorWidgetBuilder({required this.child, super.key});

  final Widget child;

  @override
  State<ErrorWidgetBuilder> createState() => _ErrorWidgetBuilderState();
}

class _ErrorWidgetBuilderState extends State<ErrorWidgetBuilder> {
  @override
  void initState() {
    super.initState();
    ErrorWidget.builder = (details) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: buildGoMitraTheme(),
        home: Scaffold(
          backgroundColor: GoMitraColors.ink,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: GoMitraColors.red.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.shield_outlined,
                        color: GoMitraColors.red,
                        size: 48,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Protected Application State',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'GoMitra crash protection safely isolated a rendering notice. Your journey data remains safe on this device.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: () {
                        runApp(widget.child);
                      },
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('Reload Journey View'),
                      style: FilledButton.styleFrom(
                        backgroundColor: GoMitraColors.green,
                        minimumSize: const Size(200, 48),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    };
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
