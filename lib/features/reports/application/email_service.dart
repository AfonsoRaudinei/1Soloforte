import 'package:dio/dio.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'package:soloforte_app/core/services/logger_service.dart';

/// Serviço para envio de emails com relatórios
class EmailService {
  final Dio _dio = Dio();
  // TODO: Configurar com suas credenciais de email
  static const String _apiEndpoint = 'https://api.sendgrid.com/v3/mail/send';
  static const String _apiKey = 'YOUR_SENDGRID_API_KEY'; // Configurar
  static const String _fromEmail = 'reports@soloforte.com'; // Configurar
  static const String _fromName = 'SoloForte Relatórios';

  /// Envia relatório por email
  Future<bool> sendReportEmail({
    required List<String> recipients,
    required String subject,
    required String reportTitle,
    required Uint8List pdfBytes,
    String? message,
  }) async {
    try {
      final base64Pdf = _bytesToBase64(pdfBytes);

      final emailData = {
        'personalizations': [
          {
            'to': recipients.map((email) => {'email': email}).toList(),
            'subject': subject,
          },
        ],
        'from': {'email': _fromEmail, 'name': _fromName},
        'content': [
          {'type': 'text/html', 'value': _buildEmailHtml(reportTitle, message)},
        ],
        'attachments': [
          {
            'content': base64Pdf,
            'filename': '${_sanitizeFilename(reportTitle)}.pdf',
            'type': 'application/pdf',
            'disposition': 'attachment',
          },
        ],
      };

      final response = await _dio.post(
        _apiEndpoint,
        data: emailData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $_apiKey',
            'Content-Type': 'application/json',
          },
        ),
      );

      return response.statusCode == 202;
    } catch (e) {
      LoggerService.e('Error sending email', error: e, tag: 'EmailService');
      return false;
    }
  }

  /// Envia notificação de relatório agendado
  Future<bool> sendScheduledReportNotification({
    required List<String> recipients,
    required String reportTitle,
    required Uint8List pdfBytes,
  }) async {
    return await sendReportEmail(
      recipients: recipients,
      subject: 'Relatório Agendado: $reportTitle',
      reportTitle: reportTitle,
      pdfBytes: pdfBytes,
      message: 'Este é um relatório gerado automaticamente pelo SoloForte.',
    );
  }

  /// Constrói HTML do email
  String _buildEmailHtml(String reportTitle, String? message) {
    return '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <style>
    body {
      font-family: Arial, sans-serif;
      line-height: 1.6;
      color: #333;
      max-width: 600px;
      margin: 0 auto;
      padding: 20px;
    }
    .header {
      background: linear-gradient(135deg, #2E7D32 0%, #66BB6A 100%);
      color: white;
      padding: 30px;
      border-radius: 10px 10px 0 0;
      text-align: center;
    }
    .content {
      background: #f9f9f9;
      padding: 30px;
      border-radius: 0 0 10px 10px;
    }
    .button {
      display: inline-block;
      background: #2E7D32;
      color: white;
      padding: 12px 30px;
      text-decoration: none;
      border-radius: 5px;
      margin-top: 20px;
    }
    .footer {
      text-align: center;
      margin-top: 30px;
      color: #666;
      font-size: 12px;
    }
  </style>
</head>
<body>
  <div class="header">
    <h1>🌱 SoloForte</h1>
    <p>Gestão Agrícola Inteligente</p>
  </div>
  <div class="content">
    <h2>$reportTitle</h2>
    <p>${message ?? 'Seu relatório está pronto!'}</p>
    <p>O relatório está anexado a este email em formato PDF.</p>
    <p>Você pode visualizar, baixar ou imprimir o arquivo conforme necessário.</p>
    ${message != null ? '<p><em>$message</em></p>' : ''}
  </div>
  <div class="footer">
    <p>Este é um email automático. Por favor, não responda.</p>
    <p>&copy; ${DateTime.now().year} SoloForte. Todos os direitos reservados.</p>
  </div>
</body>
</html>
    ''';
  }

  /// Converte bytes para base64
  String _bytesToBase64(Uint8List bytes) {
    return base64Encode(bytes);
  }

  /// Sanitiza nome de arquivo
  String _sanitizeFilename(String filename) {
    return filename
        .replaceAll(RegExp(r'[^\w\s-]'), '')
        .replaceAll(RegExp(r'\s+'), '_')
        .toLowerCase();
  }
}

/// Singleton do serviço
final emailService = EmailService();
