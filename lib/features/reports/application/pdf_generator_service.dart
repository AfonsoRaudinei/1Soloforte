import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:soloforte_app/features/map/domain/geo_area.dart';
import 'package:soloforte_app/features/reports/domain/report_models.dart';
import 'package:soloforte_app/features/occurrences/domain/entities/occurrence.dart';

/// Service responsible for generating PDF documents.
///
/// This service creates and shares PDF reports using the pdf package.
/// It receives structured data from ReportDataService and converts it to PDFs.
class PdfGeneratorService {
  /// Generate and share NDVI Report PDF
  Future<void> generateAndShareNDVIReport({
    required GeoArea area,
    required DateTime date,
    required Uint8List? ndviImageBytes,
    required Map<String, dynamic>? stats,
  }) async {
    final doc = pw.Document();

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _buildHeader(area, date),
              pw.SizedBox(height: 20),
              _buildMapSection(ndviImageBytes),
              pw.SizedBox(height: 20),
              _buildStatsSection(stats),
              pw.Spacer(),
              _buildFooter(),
            ],
          );
        },
      ),
    );

    await Printing.sharePdf(
      bytes: await doc.save(),
      filename: 'relatorio_ndvi_${area.name}.pdf',
    );
  }

  /// Generate and share Weekly Report PDF
  Future<void> generateAndShareWeeklyReport(WeeklyReportData data) async {
    final doc = pw.Document();

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          // Header
          pw.Text(
            'Relatório Semanal',
            style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 10),
          pw.Text(
            'Período: ${DateFormat('dd/MM/yyyy').format(DateTime.now().subtract(const Duration(days: 7)))} - ${DateFormat('dd/MM/yyyy').format(DateTime.now())}',
            style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey700),
          ),
          pw.Divider(),
          pw.SizedBox(height: 20),

          // Summary Statistics
          pw.Text(
            'Resumo da Semana',
            style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 10),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
            children: [
              _buildStatBox(
                'Ocorrências',
                data.occurrences.toString(),
                PdfColors.orange,
              ),
              _buildStatBox(
                'Aplicações',
                data.applications.toString(),
                PdfColors.blue,
              ),
              _buildStatBox(
                'Check-ins',
                data.teamCheckins.toString(),
                PdfColors.green,
              ),
            ],
          ),
          pw.SizedBox(height: 20),

          // Weather Summary
          _buildWeatherBox(data.weatherSummary),
          pw.SizedBox(height: 20),

          // Activities
          _buildActivitiesSection(data.activities),
          pw.SizedBox(height: 20),

          // Next Actions
          _buildNextActionsSection(data.nextActions),

          pw.Spacer(),
          _buildFooter(),
        ],
      ),
    );

    await Printing.sharePdf(
      bytes: await doc.save(),
      filename:
          'relatorio_semanal_${DateFormat('yyyyMMdd').format(DateTime.now())}.pdf',
    );
  }

  /// Generate and share Crop Summary PDF
  Future<void> generateAndShareCropSummary(CropSummaryData data) async {
    final doc = pw.Document();

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          // Header
          pw.Text(
            'Resumo de Safra',
            style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 10),
          pw.Text(
            'Gerado em: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}',
            style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey700),
          ),
          pw.Divider(),
          pw.SizedBox(height: 20),

          // Overview Cards
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
            children: [
              _buildStatBox(
                'Área Plantada',
                '${data.plantedArea.toStringAsFixed(1)} ha',
                PdfColors.green,
              ),
              _buildStatBox(
                'Custo/ha',
                'R\$ ${data.costPerHectare.toStringAsFixed(0)}',
                PdfColors.orange,
              ),
            ],
          ),
          pw.SizedBox(height: 20),

          // Phenological Stage
          _buildPhenologyBox(data.phenologicalStage),
          pw.SizedBox(height: 20),

          // Productivity Table
          _buildProductivityTable(data),
          pw.SizedBox(height: 20),

          // Problems
          if (data.problemsFaces.isNotEmpty)
            _buildProblemsSection(data.problemsFaces),
          pw.SizedBox(height: 20),

          // Lessons Learned
          if (data.lessonsLearned.isNotEmpty)
            _buildLessonsSection(data.lessonsLearned),

          pw.Spacer(),
          _buildFooter(),
        ],
      ),
    );

    await Printing.sharePdf(
      bytes: await doc.save(),
      filename:
          'resumo_safra_${DateFormat('yyyyMMdd').format(DateTime.now())}.pdf',
    );
  }

  /// Generate and share Pest Report PDF
  Future<void> generateAndSharePestReport(PestReportData data) async {
    final doc = pw.Document();

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          // Header
          pw.Text(
            'Relatório de Pragas e Doenças',
            style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 10),
          pw.Text(
            'Gerado em: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}',
            style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey700),
          ),
          pw.Divider(),
          pw.SizedBox(height: 20),

          // Summary
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
            children: [
              _buildStatBox(
                'Total de Ocorrências',
                data.totalOccurrences.toString(),
                PdfColors.red,
              ),
              _buildStatBox(
                'Severidade Média',
                data.averageSeverity,
                _getSeverityColor(data.averageSeverity),
              ),
            ],
          ),
          pw.SizedBox(height: 20),

          // Distribution Table
          if (data.distributionByType.isNotEmpty) _buildDistributionTable(data),
          pw.SizedBox(height: 20),

          // Treatments Table
          if (data.treatments.isNotEmpty)
            _buildTreatmentsTable(data.treatments),
          pw.SizedBox(height: 20),

          // Cost Summary
          _buildCostBox(data.totalCost),

          pw.Spacer(),
          _buildFooter(),
        ],
      ),
    );

    await Printing.sharePdf(
      bytes: await doc.save(),
      filename:
          'relatorio_pragas_${DateFormat('yyyyMMdd').format(DateTime.now())}.pdf',
    );
  }

  /// Generate and share Occurrence Technical Report PDF
  Future<void> generateOccurrenceTechnicalReport(Occurrence occurrence) async {
    final doc = pw.Document();

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          // Header
          pw.Text(
            'Relatório Técnico de Ocorrência',
            style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 10),
          pw.Text(
            'Gerado em: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}',
            style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey700),
          ),
          pw.Divider(),
          pw.SizedBox(height: 20),

          // Title & Type
          pw.Text(
            occurrence.title,
            style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 8),
          pw.Row(
            children: [
              _buildOccurrenceTag(
                'Tipo',
                _getOccurrenceTypeLabel(occurrence.type),
              ),
              pw.SizedBox(width: 12),
              _buildOccurrenceTag(
                'Status',
                occurrence.status.toUpperCase(),
                color: _getStatusPdfColor(occurrence.status),
              ),
            ],
          ),
          pw.SizedBox(height: 16),

          // Date & Severity
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                'Data: ${DateFormat('dd/MM/yyyy HH:mm').format(occurrence.date)}',
                style: const pw.TextStyle(fontSize: 12),
              ),
              pw.Text(
                'Severidade: ${(occurrence.severity * 100).toInt()}%',
                style: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                  color: _getSeverityPdfColor(occurrence.severity),
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 8),

          // Coordinates
          pw.Text(
            'Localização: ${occurrence.latitude.toStringAsFixed(6)}, ${occurrence.longitude.toStringAsFixed(6)}',
            style: const pw.TextStyle(fontSize: 11, color: PdfColors.grey700),
          ),
          pw.Text(
            'Área: ${occurrence.areaName}',
            style: const pw.TextStyle(fontSize: 11),
          ),
          pw.SizedBox(height: 16),

          // Phenological Stage & Temporal Type
          pw.Container(
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              color: PdfColors.grey100,
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Estádio Fenológico',
                      style: const pw.TextStyle(
                        fontSize: 10,
                        color: PdfColors.grey700,
                      ),
                    ),
                    pw.Text(
                      occurrence.phenologicalStage,
                      style: pw.TextStyle(
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text(
                      'Tipo Temporal',
                      style: const pw.TextStyle(
                        fontSize: 10,
                        color: PdfColors.grey700,
                      ),
                    ),
                    pw.Text(
                      occurrence.temporalType,
                      style: pw.TextStyle(
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 16),

          // Soil Sample
          if (occurrence.hasSoilSample)
            pw.Container(
              padding: const pw.EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              decoration: pw.BoxDecoration(
                color: PdfColors.green50,
                border: pw.Border.all(color: PdfColors.green),
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
              ),
              child: pw.Text(
                '✓ Amostra de Solo Coletada',
                style: pw.TextStyle(
                  fontSize: 11,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.green800,
                ),
              ),
            ),
          pw.SizedBox(height: 20),

          // Categories & Severities
          if (occurrence.categorySeverities.isNotEmpty) ...[
            pw.Text(
              'Categorias da Ocorrência',
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 10),
            ...occurrence.categorySeverities.entries.map((entry) {
              final category = entry.key;
              final severity = entry.value;
              final images = occurrence.categoryImages[category] ?? [];

              return pw.Container(
                margin: const pw.EdgeInsets.only(bottom: 12),
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey300),
                  borderRadius: const pw.BorderRadius.all(
                    pw.Radius.circular(6),
                  ),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          category,
                          style: pw.TextStyle(
                            fontSize: 13,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.Text(
                          '${(severity * 100).toInt()}%',
                          style: pw.TextStyle(
                            fontSize: 12,
                            fontWeight: pw.FontWeight.bold,
                            color: _getSeverityPdfColor(severity),
                          ),
                        ),
                      ],
                    ),
                    if (images.isNotEmpty) ...[
                      pw.SizedBox(height: 8),
                      pw.Text(
                        'Fotos: ${images.length} anexada(s)',
                        style: const pw.TextStyle(
                          fontSize: 10,
                          color: PdfColors.grey600,
                        ),
                      ),
                      // Note: For actual image embedding, we'd need to load bytes. For now, listing paths.
                    ],
                  ],
                ),
              );
            }),
            pw.SizedBox(height: 16),
          ],

          // Description / General Observations
          if (occurrence.description.isNotEmpty) ...[
            pw.Text(
              'Observações Gerais',
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 8),
            pw.Container(
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                color: PdfColors.grey100,
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
              ),
              child: pw.Text(
                occurrence.description,
                style: const pw.TextStyle(fontSize: 11),
              ),
            ),
            pw.SizedBox(height: 16),
          ],

          // Technical Recommendation
          if (occurrence.technicalRecommendation.isNotEmpty) ...[
            pw.Text(
              'Recomendações Técnicas',
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 8),
            pw.Container(
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                color: PdfColors.blue50,
                border: pw.Border.all(color: PdfColors.blue),
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
              ),
              child: pw.Text(
                occurrence.technicalRecommendation,
                style: const pw.TextStyle(fontSize: 11),
              ),
            ),
            pw.SizedBox(height: 16),
          ],

          // Technical Responsible
          if (occurrence.technicalResponsible.isNotEmpty) ...[
            pw.Row(
              children: [
                pw.Text(
                  'Responsável Técnico: ',
                  style: const pw.TextStyle(
                    fontSize: 11,
                    color: PdfColors.grey700,
                  ),
                ),
                pw.Text(
                  occurrence.technicalResponsible,
                  style: pw.TextStyle(
                    fontSize: 11,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 16),
          ],

          pw.Spacer(),
          _buildFooter(),
        ],
      ),
    );

    try {
      final idSuffix = occurrence.id.length >= 8
          ? occurrence.id.substring(0, 8)
          : occurrence.id;
      await Printing.sharePdf(
        bytes: await doc.save(),
        filename:
            'relatorio_ocorrencia_${idSuffix}_${DateFormat('yyyyMMdd').format(DateTime.now())}.pdf',
      );
    } catch (e) {
      // Silently fail if sharing is cancelled or fails - no crash
      debugPrint('PDF sharing failed or cancelled: $e');
    }
  }

  // Helper methods for Occurrence Report
  String _getOccurrenceTypeLabel(String type) {
    return switch (type) {
      'pest' => 'Praga',
      'disease' => 'Doença',
      'deficiency' => 'Deficiência',
      'weed' => 'Erva Daninha',
      'other' => 'Outro',
      _ => type,
    };
  }

  PdfColor _getStatusPdfColor(String status) {
    return switch (status.toLowerCase()) {
      'active' => PdfColors.red,
      'monitoring' => PdfColors.orange,
      'resolved' => PdfColors.green,
      _ => PdfColors.grey,
    };
  }

  PdfColor _getSeverityPdfColor(double severity) {
    if (severity > 0.7) return PdfColors.red;
    if (severity > 0.4) return PdfColors.orange;
    return PdfColors.green;
  }

  pw.Widget _buildOccurrenceTag(String label, String value, {PdfColor? color}) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: pw.BoxDecoration(
        color: (color ?? PdfColors.grey).shade(50),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
      ),
      child: pw.Text(
        '$label: $value',
        style: pw.TextStyle(
          fontSize: 10,
          fontWeight: pw.FontWeight.bold,
          color: color ?? PdfColors.grey800,
        ),
      ),
    );
  }

  // --- Private Helper Methods ---

  pw.Widget _buildHeader(GeoArea area, DateTime date) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Relatório de Análise NDVI',
          style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 10),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text('Área: ${area.name}'),
            pw.Text('Data da Imagem: ${DateFormat('dd/MM/yyyy').format(date)}'),
          ],
        ),
        pw.Text('Tamanho: ${area.areaHectares.toStringAsFixed(2)} ha'),
        pw.Divider(),
      ],
    );
  }

  pw.Widget _buildMapSection(Uint8List? imageBytes) {
    if (imageBytes == null) {
      return pw.Container(
        height: 300,
        alignment: pw.Alignment.center,
        decoration: pw.BoxDecoration(border: pw.Border.all()),
        child: pw.Text('Imagem NDVI indisponível'),
      );
    }
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Mapa de Vigor Vegetativo',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 8),
        pw.Container(
          height: 400,
          width: double.infinity,
          alignment: pw.Alignment.center,
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.grey300),
          ),
          child: pw.Image(pw.MemoryImage(imageBytes), fit: pw.BoxFit.contain),
        ),
        pw.SizedBox(height: 8),
        _buildLegend(),
      ],
    );
  }

  pw.Widget _buildLegend() {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.center,
      children: [
        _legendItem(PdfColors.red, '< 0.2 (Solo/Morto)'),
        pw.SizedBox(width: 10),
        _legendItem(PdfColors.yellow, '0.2-0.4 (Estresse)'),
        pw.SizedBox(width: 10),
        _legendItem(PdfColors.lightGreen, '0.4-0.6 (Moderado)'),
        pw.SizedBox(width: 10),
        _legendItem(PdfColor.fromInt(0xFF2E7D32), '> 0.6 (Vigoroso)'),
      ],
    );
  }

  pw.Widget _legendItem(PdfColor color, String label) {
    return pw.Row(
      children: [
        pw.Container(width: 10, height: 10, color: color),
        pw.SizedBox(width: 4),
        pw.Text(label, style: const pw.TextStyle(fontSize: 10)),
      ],
    );
  }

  pw.Widget _buildStatsSection(Map<String, dynamic>? stats) {
    if (stats == null ||
        stats['data'] == null ||
        (stats['data'] as List).isEmpty) {
      return pw.Text('Estatísticas indisponíveis');
    }

    try {
      final bands = stats['data'][0]['outputs']['ndvi']['bands']['B0'];
      final mean = bands['stats']['mean'];
      final std = bands['stats']['stDev'];
      final min = bands['stats']['min'];
      final max = bands['stats']['max'];

      return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Estatísticas do Talhão',
            style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 10),
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey300),
            children: [
              pw.TableRow(
                children: [
                  _tableCell('Média NDVI'),
                  _tableCell(mean?.toStringAsFixed(3) ?? "-"),
                ],
              ),
              pw.TableRow(
                children: [
                  _tableCell('Desvio Padrão'),
                  _tableCell(std?.toStringAsFixed(3) ?? "-"),
                ],
              ),
              pw.TableRow(
                children: [
                  _tableCell('Mínimo'),
                  _tableCell(min?.toStringAsFixed(3) ?? "-"),
                ],
              ),
              pw.TableRow(
                children: [
                  _tableCell('Máximo'),
                  _tableCell(max?.toStringAsFixed(3) ?? "-"),
                ],
              ),
            ],
          ),
        ],
      );
    } catch (e) {
      return pw.Text('Erro ao processar estatísticas');
    }
  }

  pw.Widget _tableCell(String text, {bool bold = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(5),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }

  pw.Widget _buildFooter() {
    return pw.Column(
      children: [
        pw.Divider(),
        pw.Center(
          child: pw.Text(
            'Gerado por Solo Forte App - ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}',
            style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey),
          ),
        ),
      ],
    );
  }

  pw.Widget _buildStatBox(String label, String value, PdfColor color) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: color),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
      ),
      child: pw.Column(
        children: [
          pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: 20,
              fontWeight: pw.FontWeight.bold,
              color: color,
            ),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            label,
            style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildWeatherBox(String summary) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey200,
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Clima da Semana',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 4),
          pw.Text(summary, style: const pw.TextStyle(fontSize: 10)),
        ],
      ),
    );
  }

  pw.Widget _buildActivitiesSection(List<String> activities) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Atividades Realizadas',
          style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 10),
        ...activities.map(
          (a) => pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 8),
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Container(
                  width: 6,
                  height: 6,
                  margin: const pw.EdgeInsets.only(top: 4, right: 8),
                  decoration: const pw.BoxDecoration(
                    color: PdfColors.green,
                    shape: pw.BoxShape.circle,
                  ),
                ),
                pw.Expanded(
                  child: pw.Text(a, style: const pw.TextStyle(fontSize: 11)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  pw.Widget _buildNextActionsSection(List<String> actions) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Próximas Ações',
          style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 10),
        ...actions.map(
          (a) => pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 8),
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Icon(
                  const pw.IconData(0xe5c8),
                  size: 12,
                  color: PdfColors.grey,
                ),
                pw.SizedBox(width: 8),
                pw.Expanded(
                  child: pw.Text(a, style: const pw.TextStyle(fontSize: 11)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  pw.Widget _buildPhenologyBox(String stage) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: PdfColors.green50,
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
        border: pw.Border.all(color: PdfColors.green),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Estágio Fenológico',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 4),
          pw.Text(stage, style: const pw.TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  pw.Widget _buildProductivityTable(CropSummaryData data) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Produtividade',
          style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 10),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey300),
          children: [
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.grey200),
              children: [
                _tableCell('Métrica', bold: true),
                _tableCell('Valor', bold: true),
              ],
            ),
            pw.TableRow(
              children: [
                _tableCell('Produtividade Estimada'),
                _tableCell(
                  '${data.estimatedProductivity.toStringAsFixed(1)} sacas/ha',
                ),
              ],
            ),
            pw.TableRow(
              children: [
                _tableCell('Produtividade Real'),
                _tableCell(
                  data.realProductivity > 0
                      ? '${data.realProductivity.toStringAsFixed(1)} sacas/ha'
                      : 'Aguardando colheita',
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildProblemsSection(List<String> problems) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Problemas Enfrentados',
          style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 10),
        ...problems.map(
          (p) => pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 6),
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Icon(
                  const pw.IconData(0xe002),
                  size: 12,
                  color: PdfColors.red,
                ),
                pw.SizedBox(width: 8),
                pw.Expanded(
                  child: pw.Text(p, style: const pw.TextStyle(fontSize: 10)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  pw.Widget _buildLessonsSection(List<String> lessons) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Lições Aprendidas',
          style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 10),
        ...lessons.map(
          (l) => pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 6),
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Icon(
                  const pw.IconData(0xe0f0),
                  size: 12,
                  color: PdfColors.amber,
                ),
                pw.SizedBox(width: 8),
                pw.Expanded(
                  child: pw.Text(l, style: const pw.TextStyle(fontSize: 10)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  PdfColor _getSeverityColor(String severity) {
    return switch (severity.toLowerCase()) {
      'alta' => PdfColors.red,
      'média' => PdfColors.orange,
      'baixa' => PdfColors.green,
      _ => PdfColors.grey,
    };
  }

  pw.Widget _buildDistributionTable(PestReportData data) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Distribuição por Tipo',
          style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 10),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey300),
          children: [
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.grey200),
              children: [
                _tableCell('Tipo', bold: true),
                _tableCell('Quantidade', bold: true),
                _tableCell('Percentual', bold: true),
              ],
            ),
            ...data.distributionByType.entries.map((entry) {
              final percentage = (entry.value / data.totalOccurrences * 100)
                  .toStringAsFixed(1);
              return pw.TableRow(
                children: [
                  _tableCell(entry.key),
                  _tableCell(entry.value.toString()),
                  _tableCell('$percentage%'),
                ],
              );
            }),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildTreatmentsTable(List<TreatmentData> treatments) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Tratamentos Realizados',
          style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 10),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey300),
          children: [
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.grey200),
              children: [
                _tableCell('Tratamento', bold: true),
                _tableCell('Data', bold: true),
                _tableCell('Eficácia', bold: true),
              ],
            ),
            ...treatments.map(
              (t) => pw.TableRow(
                children: [
                  _tableCell(t.name),
                  _tableCell(DateFormat('dd/MM/yyyy').format(t.date)),
                  _tableCell('${(t.efficacy * 100).toInt()}%'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildCostBox(double totalCost) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            'Custo Total de Controle',
            style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
          ),
          pw.Text(
            'R\$ ${totalCost.toStringAsFixed(2)}',
            style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

// Provider
final pdfGeneratorServiceProvider = Provider<PdfGeneratorService>((ref) {
  return PdfGeneratorService();
});
