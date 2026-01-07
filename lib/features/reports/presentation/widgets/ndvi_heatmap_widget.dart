import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:soloforte_app/features/ndvi/domain/ndvi_heatmap_point.dart';

/// Widget que gera um mapa de calor NDVI visual sem necessidade de assets
class NdviHeatmapWidget extends StatelessWidget {
  final double width;
  final double height;
  final List<NdviHeatmapPoint>? dataPoints;
  final bool showGrid;

  const NdviHeatmapWidget({
    super.key,
    this.width = double.infinity,
    this.height = 200,
    this.dataPoints,
    this.showGrid = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CustomPaint(
          painter: NdviHeatmapPainter(
            dataPoints: dataPoints ?? _generateMockData(),
            showGrid: showGrid,
          ),
          child: Container(),
        ),
      ),
    );
  }

  /// Gera dados mock para demonstração
  List<NdviHeatmapPoint> _generateMockData() {
    final random = math.Random(42); // Seed fixo para consistência
    final points = <NdviHeatmapPoint>[];

    // Gera grid de pontos com valores NDVI variados
    for (var x = 0.0; x <= 1.0; x += 0.1) {
      for (var y = 0.0; y <= 1.0; y += 0.1) {
        // Cria padrões interessantes
        final centerDistance = math.sqrt(
          math.pow(x - 0.5, 2) + math.pow(y - 0.5, 2),
        );

        // Valor NDVI baseado na distância do centro + ruído
        var ndviValue = 0.8 - (centerDistance * 0.6);
        ndviValue += (random.nextDouble() - 0.5) * 0.2; // Adiciona variação
        ndviValue = ndviValue.clamp(0.0, 1.0);

        points.add(NdviHeatmapPoint(x: x, y: y, ndviValue: ndviValue));
      }
    }

    // Adiciona algumas zonas de atenção (baixo NDVI)
    points.add(NdviHeatmapPoint(x: 0.2, y: 0.3, ndviValue: 0.25));
    points.add(NdviHeatmapPoint(x: 0.8, y: 0.7, ndviValue: 0.30));
    points.add(NdviHeatmapPoint(x: 0.6, y: 0.2, ndviValue: 0.35));

    return points;
  }
}

// Internal class removed as it is now in domain
// class NdviDataPoint { ... }

/// Painter customizado para desenhar o mapa de calor NDVI
class NdviHeatmapPainter extends CustomPainter {
  final List<NdviHeatmapPoint> dataPoints;
  final bool showGrid;

  NdviHeatmapPainter({required this.dataPoints, this.showGrid = true});
  // ...

  @override
  void paint(Canvas canvas, Size size) {
    // Desenha o gradiente de fundo
    _drawBackground(canvas, size);

    // Desenha os pontos de dados como círculos com gradiente
    _drawDataPoints(canvas, size);

    // Desenha grid se habilitado
    if (showGrid) {
      _drawGrid(canvas, size);
    }

    // Desenha zonas de atenção (baixo NDVI)
    _drawAttentionZones(canvas, size);
  }

  void _drawBackground(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
        colors: [Colors.brown[200]!, Colors.yellow[100]!, Colors.green[100]!],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  void _drawDataPoints(Canvas canvas, Size size) {
    for (final point in dataPoints) {
      final x = point.x * size.width;
      final y = point.y * size.height;
      final color = _getNdviColor(point.ndviValue);

      // Desenha círculo com gradiente radial
      final paint = Paint()
        ..shader = RadialGradient(
          colors: [
            color.withValues(alpha: 0.8),
            color.withValues(alpha: 0.3),
            color.withValues(alpha: 0.0),
          ],
          stops: const [0.0, 0.5, 1.0],
        ).createShader(Rect.fromCircle(center: Offset(x, y), radius: 30));

      canvas.drawCircle(Offset(x, y), 30, paint);
    }
  }

  void _drawGrid(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.2)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    // Linhas verticais
    for (var i = 0; i <= 10; i++) {
      final x = (i / 10) * size.width;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Linhas horizontais
    for (var i = 0; i <= 10; i++) {
      final y = (i / 10) * size.height;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  void _drawAttentionZones(Canvas canvas, Size size) {
    final lowNdviPoints = dataPoints.where((p) => p.ndviValue < 0.4).toList();

    for (final point in lowNdviPoints) {
      final x = point.x * size.width;
      final y = point.y * size.height;

      // Desenha ícone de alerta
      final paint = Paint()
        ..color = Colors.red.withValues(alpha: 0.7)
        ..style = PaintingStyle.fill;

      // Círculo de fundo
      canvas.drawCircle(Offset(x, y), 12, paint);

      // Triângulo de alerta (simplificado)
      final trianglePaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;

      final path = Path()
        ..moveTo(x, y - 6)
        ..lineTo(x - 5, y + 4)
        ..lineTo(x + 5, y + 4)
        ..close();

      canvas.drawPath(path, trianglePaint);

      // Ponto de exclamação
      final exclamationPaint = Paint()
        ..color = Colors.red
        ..strokeWidth = 1.5
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(Offset(x, y - 2), Offset(x, y + 1), exclamationPaint);

      canvas.drawCircle(Offset(x, y + 3), 0.8, exclamationPaint);
    }
  }

  /// Retorna cor baseada no valor NDVI
  /// 0.0-0.3: Vermelho (baixo vigor)
  /// 0.3-0.6: Amarelo (moderado)
  /// 0.6-1.0: Verde (saudável)
  Color _getNdviColor(double ndviValue) {
    if (ndviValue < 0.3) {
      // Vermelho para marrom
      return Color.lerp(
        Colors.brown[800]!,
        Colors.red[700]!,
        (ndviValue / 0.3).clamp(0.0, 1.0),
      )!;
    } else if (ndviValue < 0.6) {
      // Amarelo
      return Color.lerp(
        Colors.orange[600]!,
        Colors.yellow[600]!,
        ((ndviValue - 0.3) / 0.3).clamp(0.0, 1.0),
      )!;
    } else {
      // Verde
      return Color.lerp(
        Colors.lightGreen[500]!,
        Colors.green[700]!,
        ((ndviValue - 0.6) / 0.4).clamp(0.0, 1.0),
      )!;
    }
  }

  @override
  bool shouldRepaint(NdviHeatmapPainter oldDelegate) {
    return dataPoints != oldDelegate.dataPoints ||
        showGrid != oldDelegate.showGrid;
  }
}
