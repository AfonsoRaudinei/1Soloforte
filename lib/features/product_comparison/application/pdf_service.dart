import 'dart:convert';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../domain/comparison_models.dart';

class PdfService {
  static Future<void> exportToPDF(Relatorio relatorio) async {
    final pdf = pw.Document();
    
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(1.5 * PdfPageFormat.cm),
        build: (context) => [
          _buildProducerHeader(relatorio.meta),
          pw.SizedBox(height: 20),
          ...relatorio.avaliacoes.map((av) => _buildAvaliacao(av)),
          if (relatorio.conclusao != null) _buildConclusao(relatorio.conclusao!),
          if (relatorio.roi != null) _buildROI(relatorio.roi!, relatorio.meta.tamanhoHa),
          pw.Spacer(),
          _buildFooter(relatorio.consultor),
        ],
      ),
    );
    
    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
      name: 'Relatorio_Soja_${relatorio.meta.produtor}.pdf',
    );
  }

  static pw.Widget _buildProducerHeader(Meta meta) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('RELATÓRIO DE COMPARAÇÃO - SOJA', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16)),
          pw.SizedBox(height: 10),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Produtor: ${meta.produtor}'),
                  pw.Text('Fazenda: ${meta.fazenda}'),
                ],
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Cidade: ${meta.cidade}'),
                  pw.Text('Área: ${meta.tamanhoHa} ha'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildAvaliacao(Avaliacao av) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 16),
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('Avaliação ${av.id}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 8),
          if (av.layout == 1)
            _buildSide(av.ladoEsquerdo)
          else
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(child: _buildSide(av.ladoEsquerdo)),
                pw.SizedBox(width: 12),
                pw.Expanded(child: _buildSide(av.ladoDireito)),
              ],
            ),
        ],
      ),
    );
  }

  static pw.Widget _buildSide(LadoAvaliacao lado) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(lado.titulo, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
        pw.SizedBox(height: 4),
        if (lado.fotoBase64 != null)
          pw.Container(
            height: 120,
            width: double.infinity,
            child: pw.Image(
              pw.MemoryImage(base64Decode(lado.fotoBase64!)),
              fit: pw.BoxFit.cover,
            ),
          ),
        pw.SizedBox(height: 4),
        pw.Text('Estádio: ${lado.estadio}', style: const pw.TextStyle(fontSize: 9)),
        pw.Text('Obs: ${lado.anotacao}', style: const pw.TextStyle(fontSize: 9)),
      ],
    );
  }

  static pw.Widget _buildConclusao(Conclusao conclusao) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(top: 10),
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(color: PdfColors.grey50),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('CONCLUSÃO', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 5),
          pw.Text(conclusao.texto),
        ],
      ),
    );
  }

  static pw.Widget _buildROI(ROI roi, double area) {
    final roiPercent = ((roi.retorno - roi.investimento) / (roi.investimento == 0 ? 1 : roi.investimento)) * 100;
    return pw.Container(
      margin: const pw.EdgeInsets.only(top: 10),
      padding: const pw.EdgeInsets.all(10),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
        children: [
          pw.Text('ROI: ${roiPercent.toStringAsFixed(1)}%', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: roiPercent >= 0 ? PdfColors.green : PdfColors.red)),
          pw.Text('Retorno Total: R\$ ${(roi.retorno - roi.investimento) * area}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        ],
      ),
    );
  }

  static pw.Widget _buildFooter(Consultor consultor) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.end,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Text(consultor.nome, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Text('Consultor SoloForte', style: const pw.TextStyle(fontSize: 10)),
          ],
        ),
        if (consultor.fotoBase64 != null)
          pw.Padding(
            padding: const pw.EdgeInsets.only(left: 10),
            child: pw.Container(
              width: 40,
              height: 40,
              child: pw.Image(pw.MemoryImage(base64Decode(consultor.fotoBase64!))),
            ),
          ),
      ],
    );
  }
}
