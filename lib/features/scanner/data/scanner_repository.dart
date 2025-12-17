import 'dart:async';

import 'package:soloforte_app/features/scanner/domain/scan_result_model.dart';

abstract class AnalysisEvent {}

class AnalysisProgress extends AnalysisEvent {
  final String message;
  final double progress; // 0.0 to 1.0

  AnalysisProgress(this.message, this.progress);
}

class AnalysisComplete extends AnalysisEvent {
  final ScanResult result;

  AnalysisComplete(this.result);
}

class AnalysisError extends AnalysisEvent {
  final String message;

  AnalysisError(this.message);
}

class ScannerRepository {
  // Simulate AI Analysis
  Stream<AnalysisEvent> analyzeImage(String imagePath) async* {
    try {
      // Step 1: Uploading
      yield AnalysisProgress('Comprimindo imagem...', 0.1);
      await Future.delayed(const Duration(milliseconds: 500));

      yield AnalysisProgress('Enviando para o servidor...', 0.3);
      await Future.delayed(const Duration(milliseconds: 1000));

      // Step 2: Processing
      yield AnalysisProgress('Processando com IA...', 0.6);
      await Future.delayed(const Duration(milliseconds: 1500));

      yield AnalysisProgress('Identificando padrões...', 0.8);
      await Future.delayed(const Duration(milliseconds: 800));

      // Step 3: Result
      yield AnalysisProgress('Finalizando análise...', 0.95);
      await Future.delayed(const Duration(milliseconds: 400));

      // Mock Random Result
      final result = _getMockResult(imagePath);
      yield AnalysisComplete(result);
    } catch (e) {
      yield AnalysisError("Falha na análise: $e");
    }
  }

  ScanResult _getMockResult(String imagePath) {
    // Randomize slightly for "realism" if needed, but fixed for now
    return ScanResult(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      imagePath: imagePath,
      scientificName: 'Spodoptera frugiperda',
      commonName: 'Lagarta-do-cartucho',
      confidence: 0.98,
      severity: 0.75, // 75% severity
      description:
          'A lagarta-do-cartucho é uma das principais pragas do milho. '
          'As larvas alimentam-se das folhas e do cartucho da planta, causando danos severos.',
      symptoms: [
        'Folhas com áreas raspadas e perfuradas',
        'Presença de excrementos no cartucho',
        'Destruição do ponto de crescimento',
      ],
      recommendation:
          'Aplicar inseticida do grupo das Diamidas ou Espinosinas. '
          'Realizar monitoramento constante. Considerar controle biológico com Trichogramma.',
      scanDate: DateTime.now(),
      type: ScanType.pest,
      detections: [
        // Simulated Bounding Box (Example: centered on the image)
        BoundingBox(
          x: 0.25,
          y: 0.3,
          width: 0.5,
          height: 0.4,
          label: 'Spodoptera frugiperda',
          confidence: 0.98,
        ),
      ],
    );
  }
}
