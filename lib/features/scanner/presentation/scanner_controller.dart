import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soloforte_app/features/scanner/data/scanner_repository.dart';
import 'package:soloforte_app/features/scanner/domain/scan_result_model.dart';

// --- State Class ---
class ScannerState {
  final bool isAnalyzing;
  final String statusMessage;
  final double progress;
  final ScanResult? result;
  final String? error;

  const ScannerState({
    this.isAnalyzing = false,
    this.statusMessage = '',
    this.progress = 0.0,
    this.result,
    this.error,
  });

  ScannerState copyWith({
    bool? isAnalyzing,
    String? statusMessage,
    double? progress,
    ScanResult? result,
    String? error,
  }) {
    return ScannerState(
      isAnalyzing: isAnalyzing ?? this.isAnalyzing,
      statusMessage: statusMessage ?? this.statusMessage,
      progress: progress ?? this.progress,
      result: result ?? this.result,
      error:
          error, // Clear error if not provided (or explicit null handling if needed)
    );
  }
}

// --- Repository Provider ---
final scannerRepositoryProvider = Provider<ScannerRepository>((ref) {
  return ScannerRepository();
});

// --- Controller Provider ---
final scannerControllerProvider =
    StateNotifierProvider<ScannerController, ScannerState>((ref) {
      final repository = ref.watch(scannerRepositoryProvider);
      return ScannerController(repository);
    });

// --- Controller Implementation ---
class ScannerController extends StateNotifier<ScannerState> {
  final ScannerRepository _repository;

  ScannerController(this._repository) : super(const ScannerState());

  Future<void> analyzeImage(String imagePath) async {
    // Reset state
    state = const ScannerState(
      isAnalyzing: true,
      statusMessage: 'Iniciando...',
      progress: 0.0,
    );

    // Listen to repository stream
    try {
      await for (final event in _repository.analyzeImage(imagePath)) {
        if (event is AnalysisProgress) {
          state = state.copyWith(
            statusMessage: event.message,
            progress: event.progress,
            isAnalyzing: true,
          );
        } else if (event is AnalysisComplete) {
          state = state.copyWith(
            isAnalyzing: false, // Finished
            statusMessage: 'Concluído',
            progress: 1.0,
            result: event.result,
          );
        } else if (event is AnalysisError) {
          state = state.copyWith(
            isAnalyzing: false,
            error: event.message,
            statusMessage: 'Erro',
          );
        }
      }
    } catch (e) {
      state = state.copyWith(
        isAnalyzing: false,
        error: e.toString(),
        statusMessage: 'Falha inesperada',
      );
    }
  }

  void reset() {
    state = const ScannerState();
  }
}
