import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:soloforte_app/features/map/domain/geo_area.dart';
import 'package:soloforte_app/features/reports/domain/report_models.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soloforte_app/features/harvests/data/harvest_repository.dart';
import 'package:soloforte_app/features/harvests/domain/harvest_model.dart';
import 'package:soloforte_app/features/harvests/data/firestore_harvest_repository.dart';
import 'package:soloforte_app/features/occurrences/data/repositories/occurrence_repository_impl.dart';
import 'package:soloforte_app/features/occurrences/domain/repositories/occurrence_repository.dart';
import 'package:soloforte_app/features/visits/data/repositories/visit_repository_impl.dart';
import 'package:soloforte_app/features/visits/domain/repositories/visit_repository.dart';

import 'package:soloforte_app/features/ndvi/data/services/sentinel_service.dart';
import 'package:soloforte_app/features/ndvi/data/satellite_service.dart';
import 'package:soloforte_app/features/ndvi/domain/ndvi_heatmap_point.dart';
import 'package:soloforte_app/features/map/application/geometry_utils.dart';

class ReportService {
  final OccurrenceRepository _occurrenceRepository;
  final HarvestRepository _harvestRepository;
  final VisitRepository _visitRepository;
  final SentinelService _sentinelService;
  final SatelliteService _satelliteService;

  ReportService({
    required OccurrenceRepository occurrenceRepository,
    required HarvestRepository harvestRepository,
    required VisitRepository visitRepository,
    required SentinelService sentinelService,
    required SatelliteService satelliteService,
  }) : _occurrenceRepository = occurrenceRepository,
       _harvestRepository = harvestRepository,
       _visitRepository = visitRepository,
       _sentinelService = sentinelService,
       _satelliteService = satelliteService;

  // ... (keep generateAndShareNDVIReport same or similar)

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

  // --- PDF Generation Methods ---

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
          pw.Container(
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              color: PdfColors.grey200,
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
            ),
            child: pw.Row(
              children: [
                pw.Icon(const pw.IconData(0xe3a9), size: 24),
                pw.SizedBox(width: 10),
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'Clima da Semana',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        data.weatherSummary,
                        style: const pw.TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 20),

          // Activities
          pw.Text(
            'Atividades Realizadas',
            style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 10),
          ...data.activities.map(
            (activity) => pw.Padding(
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
                    child: pw.Text(
                      activity,
                      style: const pw.TextStyle(fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),
          ),
          pw.SizedBox(height: 20),

          // Next Actions
          pw.Text(
            'Próximas Ações',
            style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 10),
          ...data.nextActions.map(
            (action) => pw.Padding(
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
                    child: pw.Text(
                      action,
                      style: const pw.TextStyle(fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),
          ),

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
          pw.Container(
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              color: PdfColors.green50,
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
              border: pw.Border.all(color: PdfColors.green),
            ),
            child: pw.Row(
              children: [
                pw.Icon(
                  const pw.IconData(0xe1be),
                  size: 24,
                  color: PdfColors.green,
                ),
                pw.SizedBox(width: 10),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Estágio Fenológico',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      data.phenologicalStage,
                      style: const pw.TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 20),

          // Productivity
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
          pw.SizedBox(height: 20),

          // Problems
          if (data.problemsFaces.isNotEmpty) ...[
            pw.Text(
              'Problemas Enfrentados',
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 10),
            ...data.problemsFaces.map(
              (problem) => pw.Padding(
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
                      child: pw.Text(
                        problem,
                        style: const pw.TextStyle(fontSize: 10),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            pw.SizedBox(height: 20),
          ],

          // Lessons Learned
          if (data.lessonsLearned.isNotEmpty) ...[
            pw.Text(
              'Lições Aprendidas',
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 10),
            ...data.lessonsLearned.map(
              (lesson) => pw.Padding(
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
                      child: pw.Text(
                        lesson,
                        style: const pw.TextStyle(fontSize: 10),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],

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

          // Distribution by Type
          pw.Text(
            'Distribuição por Tipo',
            style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 10),
          if (data.distributionByType.isNotEmpty)
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
          pw.SizedBox(height: 20),

          // Treatments
          if (data.treatments.isNotEmpty) ...[
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
                ...data.treatments.map(
                  (treatment) => pw.TableRow(
                    children: [
                      _tableCell(treatment.name),
                      _tableCell(
                        DateFormat('dd/MM/yyyy').format(treatment.date),
                      ),
                      _tableCell('${(treatment.efficacy * 100).toInt()}%'),
                    ],
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 20),
          ],

          // Cost Summary
          pw.Container(
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
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Text(
                  'R\$ ${data.totalCost.toStringAsFixed(2)}',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

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

  // Helper methods for PDF generation
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

  /// Generate and share Custom Report PDF based on user-selected sections
  Future<void> generateAndShareCustomReport({
    required List<ReportSection> sections,
    required WeeklyReportData weeklyData,
    required CropSummaryData cropData,
    required PestReportData pestData,
  }) async {
    final doc = pw.Document();

    // Build sections dynamically based on user selection and order
    final pdfSections = <pw.Widget>[];

    for (final section in sections) {
      switch (section.id) {
        case '1': // Resumo Executivo
          pdfSections.addAll([
            pw.Text(
              section.title,
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 10),
            pw.Text(
              'Este relatório consolida as principais métricas e atividades do período.',
              style: const pw.TextStyle(fontSize: 11),
            ),
            pw.SizedBox(height: 8),
            pw.Container(
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                color: PdfColors.grey100,
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Destaques:',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    '• ${weeklyData.occurrences} ocorrências registradas',
                    style: const pw.TextStyle(fontSize: 10),
                  ),
                  pw.Text(
                    '• ${cropData.plantedArea.toStringAsFixed(1)} ha de área plantada',
                    style: const pw.TextStyle(fontSize: 10),
                  ),
                  pw.Text(
                    '• ${pestData.totalOccurrences} ocorrências de pragas/doenças',
                    style: const pw.TextStyle(fontSize: 10),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 20),
          ]);
          break;

        case '2': // Gráfico de Produtividade
          pdfSections.addAll([
            pw.Text(
              section.title,
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
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
                      '${cropData.estimatedProductivity.toStringAsFixed(1)} sacas/ha',
                    ),
                  ],
                ),
                pw.TableRow(
                  children: [
                    _tableCell('Produtividade Real'),
                    _tableCell(
                      cropData.realProductivity > 0
                          ? '${cropData.realProductivity.toStringAsFixed(1)} sacas/ha'
                          : 'Aguardando colheita',
                    ),
                  ],
                ),
                pw.TableRow(
                  children: [
                    _tableCell('Área Total'),
                    _tableCell('${cropData.plantedArea.toStringAsFixed(1)} ha'),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 20),
          ]);
          break;

        case '3': // Mapa de Calor NDVI
          pdfSections.addAll([
            pw.Text(
              section.title,
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 10),
            pw.Container(
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                color: PdfColors.blue50,
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
              ),
              child: pw.Text(
                'Análise NDVI disponível através do relatório específico de NDVI.\nCrie áreas no mapa e acesse o relatório NDVI para visualização detalhada.',
                style: const pw.TextStyle(fontSize: 10),
              ),
            ),
            pw.SizedBox(height: 20),
          ]);
          break;

        case '4': // Tabela de Custos
          pdfSections.addAll([
            pw.Text(
              section.title,
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 10),
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey300),
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                  children: [
                    _tableCell('Categoria', bold: true),
                    _tableCell('Valor', bold: true),
                  ],
                ),
                pw.TableRow(
                  children: [
                    _tableCell('Custo por Hectare'),
                    _tableCell(
                      'R\$ ${cropData.costPerHectare.toStringAsFixed(2)}',
                    ),
                  ],
                ),
                pw.TableRow(
                  children: [
                    _tableCell('Custo Total da Safra'),
                    _tableCell(
                      'R\$ ${(cropData.costPerHectare * cropData.plantedArea).toStringAsFixed(2)}',
                    ),
                  ],
                ),
                pw.TableRow(
                  children: [
                    _tableCell('Custo de Controle de Pragas'),
                    _tableCell('R\$ ${pestData.totalCost.toStringAsFixed(2)}'),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 20),
          ]);
          break;

        case '5': // Lista de Ocorrências
          pdfSections.addAll([
            pw.Text(
              section.title,
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 10),
            if (pestData.distributionByType.isNotEmpty)
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey300),
                children: [
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(
                      color: PdfColors.grey200,
                    ),
                    children: [
                      _tableCell('Tipo de Ocorrência', bold: true),
                      _tableCell('Quantidade', bold: true),
                    ],
                  ),
                  ...pestData.distributionByType.entries.map(
                    (entry) => pw.TableRow(
                      children: [
                        _tableCell(entry.key),
                        _tableCell(entry.value.toString()),
                      ],
                    ),
                  ),
                ],
              )
            else
              pw.Text(
                'Nenhuma ocorrência registrada.',
                style: const pw.TextStyle(fontSize: 10),
              ),
            pw.SizedBox(height: 20),
          ]);
          break;

        case '6': // Métricas de Clima
          pdfSections.addAll([
            pw.Text(
              section.title,
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 10),
            pw.Container(
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                color: PdfColors.grey100,
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Resumo Climático:',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    weeklyData.weatherSummary,
                    style: const pw.TextStyle(fontSize: 10),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 20),
          ]);
          break;
      }
    }

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          // Header
          pw.Text(
            'Relatório Personalizado',
            style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 10),
          pw.Text(
            'Gerado em: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}',
            style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey700),
          ),
          pw.Divider(),
          pw.SizedBox(height: 20),

          // Dynamic sections
          ...pdfSections,

          pw.Spacer(),
          _buildFooter(),
        ],
      ),
    );

    await Printing.sharePdf(
      bytes: await doc.save(),
      filename:
          'relatorio_personalizado_${DateFormat('yyyyMMdd').format(DateTime.now())}.pdf',
    );
  }

  PdfColor _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'alta':
        return PdfColors.red;
      case 'moderada':
        return PdfColors.orange;
      case 'baixa':
        return PdfColors.green;
      default:
        return PdfColors.grey;
    }
  }

  // --- Real Data Methods ---

  Future<WeeklyReportData> getWeeklyReport({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final now = DateTime.now();
      final start = startDate ?? now.subtract(const Duration(days: 7));
      final end = endDate ?? now;

      // Fetch Data
      final allOccurrences = await _occurrenceRepository.getOccurrences();
      final recentOccurrences = allOccurrences
          .where((o) => o.date.isAfter(start) && o.date.isBefore(end))
          .toList();

      final allVisits = await _visitRepository.getVisits();
      final recentVisits = allVisits
          .where(
            (v) => v.checkInTime.isAfter(start) && v.checkInTime.isBefore(end),
          )
          .toList();

      // Aggregate Activities
      List<String> activities = [];
      activities.addAll(
        recentVisits.map(
          (v) =>
              'Visita: ${v.client.name} - ${DateFormat('dd/MM').format(v.checkInTime)}',
        ),
      );
      activities.addAll(
        recentOccurrences.map(
          (o) =>
              'Ocorrência: ${o.title} - ${DateFormat('dd/MM').format(o.date)}',
        ),
      );

      // Fallback if empty
      if (activities.isEmpty) {
        activities = ['Nenhuma atividade registrada neste período.'];
      }

      return WeeklyReportData(
        activities: activities.take(5).toList(), // Limit to top 5
        occurrences: recentOccurrences.length,
        applications: 0,
        teamCheckins: recentVisits.length,
        weatherSummary:
            'Clima predominantemente ensolarado com temperaturas entre 22°C e 30°C.',
        nextActions: [
          'Monitorar áreas com alta incidência de pragas',
          'Planejar próxima aplicação de defensivos',
          'Verificar níveis de umidade do solo',
        ],
      );
    } catch (e) {
      print('Error generating weekly report: $e');
      return WeeklyReportData(
        activities: ['Erro ao carregar atividades'],
        occurrences: 0,
        applications: 0,
        teamCheckins: 0,
        weatherSummary: 'Dados climáticos indisponíveis',
        nextActions: [],
      );
    }
  }

  Future<NdviAnalysisData> getNdviAnalysis({
    required List<GeoArea> areas,
  }) async {
    if (areas.isEmpty) {
      // Return empty/placeholder if no areas
      return NdviAnalysisData(
        temporalEvolution: [],
        areaComparisons: [],
        attentionZoneImageBytes: null,
        correlationWithWeather: 0.0,
      );
    }

    // Pick first area as main analysis target
    final mainArea = areas.first;

    // Fetch Temporal Evolution (last 30 days)
    final now = DateTime.now();
    final oneMonthAgo = now.subtract(const Duration(days: 30));

    // We will simulate temporal evolution for now using 1 real point if possible + history
    // Since history api is costly or complex to iterate for 30 days, we might just fetch ONE real point for today/recent
    // and mock others, or try to fetch distribution.
    // For simplicity and performance, let's fetch stats for *last valid image* and assume some history or just return 1 point.

    List<NdviDataPoint> temporalData = [];
    Uint8List? imageBytes; // Keep for fallback or PDF
    List<NdviHeatmapPoint>? heatmapPoints;

    try {
      // 1. Fetch Server-Side Statistics for Time Series (60 days)
      final endDate = DateTime.now();
      final startDate = endDate.subtract(const Duration(days: 60));

      final statsMap = await _satelliteService.fetchStatistics(
        mainArea.points,
        startDate: startDate,
        endDate: endDate,
      );

      if (statsMap != null && statsMap['C0'] != null) {
        final results = statsMap['C0'] as List;
        // FIS returns list of date-based results
        for (var item in results) {
          if (item['date'] != null && item['basicStats'] != null) {
            final dateStr = item['date'] as String;
            final mean = (item['basicStats']['mean'] as num).toDouble();

            // If mean is 'NaN' (our cloud mask), Sentinel Hub usually returns "NoData" or specific value?
            // Actually `basicStats.mean` will be calculated based on valid pixels.
            // If all pixels are cloud masked (NaN), the response might have sampleCount=0 or mean="NaN".

            // Let's check sampleCount to filter empty/cloudy days
            final sampleCount = (item['basicStats']['sampleCount'] as num)
                .toInt();

            if (sampleCount > 0 && !mean.isNaN) {
              temporalData.add(NdviDataPoint(DateTime.parse(dateStr), mean));
            }
          }
        }

        // Sort by date ascending
        temporalData.sort((a, b) => a.date.compareTo(b.date));

        // Keep only last 5 valid points for the chart to be clean
        if (temporalData.length > 5) {
          temporalData = temporalData.sublist(temporalData.length - 5);
        }
      }

      // 2. Fetch Real Raw Data for Heatmap (Visual)
      // Only if we need visual heatmap, which is heavier to download.
      // We do it here as per user flow.
      final rawTiff = await _satelliteService.fetchRawSatelliteData(
        mainArea.points,
      );
      if (rawTiff != null) {
        heatmapPoints = _satelliteService.parseNdviData(rawTiff);
      }

      // 1. Get stats for main area (last 30 days aggregation?)
      // SentinelService.fetchStatistics returns simple object. Let's try to get recent stats.
      final stats = await _sentinelService.fetchStatistics(
        geoJsonGeometry: GeometryUtils.toGeoJsonGeometry(mainArea.points),
        startDate: oneMonthAgo,
        endDate: now,
      );

      // Parsing stats is complex without knowing exact structure returned by Sentinel service
      // Assuming we get a time series. If not implemented in service, let's fallback to current day.
      // The service implementation seemed to aggregate?
      // "aggregationInterval": {"of": "P1D"} -> Daily

      if (stats.isNotEmpty && stats['data'] != null) {
        final dataList = stats['data'] as List;
        for (var dayData in dataList) {
          final dateStr = dayData['interval']['from'];
          final date = DateTime.parse(dateStr);
          final bands = dayData['outputs']['ndvi']['bands']['B0'];
          final mean = bands['stats']['mean'];
          if (mean != null) {
            temporalData.add(NdviDataPoint(date, (mean as num).toDouble()));
          }
        }
      }

      // If no data (e.g. clouds or error), add a dummy point or leave empty
      if (temporalData.isEmpty) {
        temporalData.add(NdviDataPoint(now, 0.5)); // Fallback
      }

      // 2. Fetch Image for main area (latest date)
      final latestDate = temporalData.isNotEmpty ? temporalData.last.date : now;

      imageBytes = await _sentinelService.fetchNDVIImage(
        bbox: GeometryUtils.calculateBBox(mainArea.points),
        geometry: GeometryUtils.toGeoJsonGeometry(mainArea.points),
        date: latestDate,
        width: 512,
        height: 512,
      );
    } catch (e) {
      print('Error fetching Sentinel data: $e');
      // Fallback
      temporalData = [NdviDataPoint(now, 0.0)];
    }

    // 3. Comparisons
    List<AreaComparison> comparisons = [];
    // Only compare if we have multiple areas, limit to top 5
    for (var area in areas.take(5)) {
      // Ideally fetch stats for each. To avoid rate limits/slow load, we might mock or skip.
      // Let's try to fetch just LATEST stats for comparison.
      try {
        final stats = await _sentinelService.fetchStatistics(
          geoJsonGeometry: GeometryUtils.toGeoJsonGeometry(area.points),
          date: now.subtract(const Duration(days: 1)), // Yesterday/Today
        );

        double mean = 0;
        if (stats.isNotEmpty &&
            stats['data'] != null &&
            (stats['data'] as List).isNotEmpty) {
          final bands = stats['data'][0]['outputs']['ndvi']['bands']['B0'];
          mean = (bands['stats']['mean'] as num?)?.toDouble() ?? 0.0;
        }

        // Calculate growth (mocked for now as we don't have historical for all easily)
        double growth =
            (mean - 0.5) * 10; // Pseudo random growth based on value

        comparisons.add(
          AreaComparison(
            areaName: area.name,
            currentNdvi: mean,
            growth: growth,
          ),
        );
      } catch (e) {
        // Skip
      }
    }

    return NdviAnalysisData(
      temporalEvolution: temporalData,
      areaComparisons: comparisons,
      attentionZoneImageBytes: imageBytes,
      heatmapPoints: heatmapPoints,
      correlationWithWeather: 0.85, // Still mocked as no weather API connected
    );
  }

  Future<CropSummaryData> getCropSummary() async {
    try {
      final harvests = await _harvestRepository.getHarvests();

      if (harvests.isEmpty) {
        return CropSummaryData(
          plantedArea: 0,
          phenologicalStage: 'Sem Dados',
          estimatedProductivity: 0,
          realProductivity: 0,
          costPerHectare: 0,
          problemsFaces: [],
          lessonsLearned: [],
        );
      }

      // Aggregate data from all active/recent harvests
      final activeHarvests = harvests
          .where((h) => h.status == 'active' || h.status == 'harvested')
          .toList();

      if (activeHarvests.isEmpty) {
        // Fallback to most recent harvest
        final currentHarvest = harvests.first;
        return _buildSummaryFromSingleHarvest(currentHarvest);
      }

      // Calculate aggregated metrics
      double totalArea = 0;
      double totalCost = 0;
      double totalEstimatedProduction = 0;
      double totalRealProduction = 0;
      double harvestedArea = 0;
      List<String> allProblems = [];
      List<String> allLessons = [];

      for (var harvest in activeHarvests) {
        totalArea += harvest.plantedAreaHa;
        totalCost += harvest.totalCost;
        totalEstimatedProduction += harvest.totalProductionBags;

        // Only count real production for harvested crops
        if (harvest.status == 'harvested' && harvest.harvestDate != null) {
          totalRealProduction += harvest.totalProductionBags;
          harvestedArea += harvest.plantedAreaHa;
        }

        // Collect problems and lessons
        allProblems.addAll(
          harvest.notes.where((n) => n.toLowerCase().contains('problema:')),
        );
        allLessons.addAll(
          harvest.notes.where((n) => n.toLowerCase().contains('lição:')),
        );
      }

      // Determine phenological stage based on most recent active harvest
      final mostRecentActive = activeHarvests.first;
      String phenologyStage = _mapStatusToPhenology(mostRecentActive.status);

      return CropSummaryData(
        plantedArea: totalArea,
        phenologicalStage: phenologyStage,
        estimatedProductivity: totalArea > 0
            ? totalEstimatedProduction / totalArea
            : 0,
        realProductivity: harvestedArea > 0
            ? totalRealProduction / harvestedArea
            : 0,
        costPerHectare: totalArea > 0 ? totalCost / totalArea : 0,
        problemsFaces: allProblems.take(5).toList(), // Limit to top 5
        lessonsLearned: allLessons.take(5).toList(), // Limit to top 5
      );
    } catch (e) {
      print('Error generating crop summary: $e');
      return CropSummaryData(
        plantedArea: 0,
        phenologicalStage: 'Erro',
        estimatedProductivity: 0,
        realProductivity: 0,
        costPerHectare: 0,
        problemsFaces: [],
        lessonsLearned: [],
      );
    }
  }

  CropSummaryData _buildSummaryFromSingleHarvest(Harvest harvest) {
    final productivity = harvest.plantedAreaHa > 0
        ? harvest.totalProductionBags / harvest.plantedAreaHa
        : 0;

    return CropSummaryData(
      plantedArea: harvest.plantedAreaHa,
      phenologicalStage: _mapStatusToPhenology(harvest.status),
      estimatedProductivity: productivity.toDouble(),
      realProductivity: harvest.status == 'harvested'
          ? productivity.toDouble()
          : 0.0,
      costPerHectare: harvest.plantedAreaHa > 0
          ? harvest.totalCost / harvest.plantedAreaHa
          : 0,
      problemsFaces: harvest.notes
          .where((n) => n.toLowerCase().contains('problema:'))
          .toList(),
      lessonsLearned: harvest.notes
          .where((n) => n.toLowerCase().contains('lição:'))
          .toList(),
    );
  }

  String _mapStatusToPhenology(String status) {
    switch (status.toLowerCase()) {
      case 'planned':
        return 'Planejado';
      case 'active':
        return 'Desenvolvimento Vegetativo';
      case 'harvested':
        return 'Colhido';
      default:
        return status;
    }
  }

  Future<PestReportData> getPestReport() async {
    try {
      final occurrences = await _occurrenceRepository.getOccurrences();
      final pestOccurrences = occurrences
          .where((o) => o.type == 'pest' || o.type == 'disease')
          .toList();

      Map<String, int> distribution = {};
      double severitySum = 0;

      for (var o in pestOccurrences) {
        distribution[o.title] = (distribution[o.title] ?? 0) + 1;
        severitySum += o.severity;
      }

      String severityLabel = 'Baixa';
      if (pestOccurrences.isNotEmpty) {
        final avgSev = severitySum / pestOccurrences.length;
        if (avgSev > 0.7) {
          severityLabel = 'Alta';
        } else if (avgSev > 0.4)
          severityLabel = 'Moderada';
      }

      return PestReportData(
        totalOccurrences: pestOccurrences.length,
        distributionByType: distribution,
        averageSeverity: severityLabel,
        treatments: [], // No Treatment Repository yet
        totalCost: 0, // No Cost data yet
      );
    } catch (e) {
      return PestReportData(
        totalOccurrences: 0,
        distributionByType: {},
        averageSeverity: '-',
        treatments: [],
        totalCost: 0,
      );
    }
  }
}

final reportServiceProvider = Provider<ReportService>((ref) {
  return ReportService(
    occurrenceRepository: ref.watch(occurrenceRepositoryProvider),
    harvestRepository: ref.watch(harvestRepositoryProvider),
    visitRepository: ref.watch(visitRepositoryProvider),
    sentinelService: ref.watch(sentinelServiceProvider),
    satelliteService: SatelliteService(), // Simple injection for now
  );
});
