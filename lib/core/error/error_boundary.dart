import 'package:flutter/material.dart';
import 'package:soloforte_app/core/services/logger_service.dart';

/// Global error boundary to catch and handle uncaught errors
class ErrorBoundary extends StatefulWidget {
  final Widget child;
  final Widget Function(FlutterErrorDetails)? errorBuilder;

  const ErrorBoundary({super.key, required this.child, this.errorBuilder});

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  FlutterErrorDetails? _errorDetails;

  @override
  void initState() {
    super.initState();

    // Capture Flutter framework errors
    FlutterError.onError = (details) {
      if (mounted) {
        setState(() {
          _errorDetails = details;
        });
      }
      // Log to console in debug mode
      LoggerService.e(
        'Flutter Error',
        error: details.exception,
        stackTrace: details.stack,
        tag: 'ERROR',
      );
    };
  }

  @override
  Widget build(BuildContext context) {
    if (_errorDetails != null) {
      return widget.errorBuilder?.call(_errorDetails!) ??
          _DefaultErrorWidget(errorDetails: _errorDetails!);
    }

    return widget.child;
  }
}

class _DefaultErrorWidget extends StatelessWidget {
  final FlutterErrorDetails errorDetails;

  const _DefaultErrorWidget({required this.errorDetails});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 64),
                const SizedBox(height: 24),
                const Text(
                  'Ops! Algo deu errado',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'Estamos trabalhando para resolver o problema.',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    // Restart app or navigate to home
                  },
                  child: const Text('Tentar Novamente'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Extension for safe async operations with error handling
extension SafeAsync<T> on Future<T> {
  Future<T?> catchError({
    void Function(Object error, StackTrace stack)? onError,
  }) async {
    try {
      return await this;
    } catch (error, stack) {
      LoggerService.e(
        'Error caught',
        error: error,
        stackTrace: stack,
        tag: 'ASYNC',
      );
      onError?.call(error, stack);
      return null;
    }
  }

  Future<T?> withRetry({
    int maxAttempts = 3,
    Duration delay = const Duration(seconds: 1),
  }) async {
    int attempts = 0;

    while (attempts < maxAttempts) {
      try {
        return await this;
      } catch (e) {
        attempts++;
        if (attempts >= maxAttempts) {
          rethrow;
        }
        await Future.delayed(delay * attempts);
      }
    }

    return null;
  }
}
