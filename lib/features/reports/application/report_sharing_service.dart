import 'dart:typed_data';
import 'dart:io';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:soloforte_app/core/services/logger_service.dart';

/// Serviço completo de compartilhamento de relatórios
class ReportSharingService {
  final Dio _dio = Dio();

  // TODO: Configurar com seu backend
  static const String _backendUrl = 'https://api.soloforte.com';
  static const String _publicShareUrl = 'https://share.soloforte.com';

  /// Compartilha relatório usando share nativo do sistema
  Future<bool> shareNative({
    required String reportTitle,
    required Uint8List pdfBytes,
    String? message,
  }) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final file = File(
        '${tempDir.path}/${_sanitizeFilename(reportTitle)}.pdf',
      );
      await file.writeAsBytes(pdfBytes);

      final result = await Share.shareXFiles(
        [XFile(file.path)],
        text: message ?? 'Compartilhando relatório: $reportTitle',
        subject: reportTitle,
      );

      return result.status == ShareResultStatus.success;
    } catch (e) {
      LoggerService.e('Error sharing natively', error: e, tag: 'SHARE');
      return false;
    }
  }

  /// Compartilha diretamente via WhatsApp
  Future<bool> shareViaWhatsApp({
    required String reportTitle,
    required Uint8List pdfBytes,
    String? phoneNumber,
    String? message,
  }) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final file = File(
        '${tempDir.path}/${_sanitizeFilename(reportTitle)}.pdf',
      );
      await file.writeAsBytes(pdfBytes);

      String text = message ?? 'Relatório: $reportTitle';
      if (phoneNumber != null) {
        // WhatsApp com número específico
        text =
            'whatsapp://send?phone=$phoneNumber&text=${Uri.encodeComponent(text)}';
      }

      final result = await Share.shareXFiles([XFile(file.path)], text: text);

      return result.status == ShareResultStatus.success;
    } catch (e) {
      LoggerService.e('Error sharing via WhatsApp', error: e, tag: 'SHARE');
      return false;
    }
  }

  /// Cria link público com senha para o relatório
  Future<PublicShareLink?> createPublicLink({
    required String reportId,
    required String reportTitle,
    required Uint8List pdfBytes,
    String? password,
    DateTime? expiresAt,
    int? maxViews,
  }) async {
    try {
      // Upload do PDF para servidor
      final uploadUrl = await _uploadToServer(
        reportId: reportId,
        pdfBytes: pdfBytes,
      );

      if (uploadUrl == null) return null;

      // Gerar hash de senha se fornecida
      String? passwordHash;
      if (password != null) {
        passwordHash = _hashPassword(password);
      }

      // Criar registro de compartilhamento no backend
      final response = await _dio.post(
        '$_backendUrl/api/shares',
        data: {
          'report_id': reportId,
          'report_title': reportTitle,
          'file_url': uploadUrl,
          'password_hash': passwordHash,
          'expires_at': expiresAt?.toIso8601String(),
          'max_views': maxViews,
        },
      );

      if (response.statusCode == 201) {
        final shareId = response.data['share_id'] as String;
        final publicUrl = '$_publicShareUrl/$shareId';

        return PublicShareLink(
          shareId: shareId,
          publicUrl: publicUrl,
          reportTitle: reportTitle,
          hasPassword: password != null,
          expiresAt: expiresAt,
          maxViews: maxViews,
          viewCount: 0,
          createdAt: DateTime.now(),
        );
      }

      return null;
    } catch (e) {
      LoggerService.e('Error creating public link', error: e, tag: 'SHARE');
      return null;
    }
  }

  /// Revoga acesso a um link público
  Future<bool> revokePublicLink(String shareId) async {
    try {
      final response = await _dio.delete('$_backendUrl/api/shares/$shareId');
      return response.statusCode == 200;
    } catch (e) {
      LoggerService.e('Error revoking link', error: e, tag: 'SHARE');
      return false;
    }
  }

  /// Envia relatório por email direto do app
  Future<bool> sendViaEmail({
    required List<String> recipients,
    required String subject,
    required String reportTitle,
    required Uint8List pdfBytes,
    String? body,
    List<String>? cc,
    List<String>? bcc,
  }) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final file = File(
        '${tempDir.path}/${_sanitizeFilename(reportTitle)}.pdf',
      );
      await file.writeAsBytes(pdfBytes);

      // Usar share_plus com intent de email
      final result = await Share.shareXFiles(
        [XFile(file.path)],
        text: body ?? 'Segue em anexo o relatório: $reportTitle',
        subject: subject,
      );

      return result.status == ShareResultStatus.success;
    } catch (e) {
      LoggerService.e('Error sending via email', error: e, tag: 'SHARE');
      return false;
    }
  }

  /// Faz upload para Google Drive
  Future<String?> uploadToGoogleDrive({
    required String reportTitle,
    required Uint8List pdfBytes,
    String? folderId,
  }) async {
    try {
      // TODO: Implementar integração com Google Drive API
      // Requer google_sign_in e googleapis packages
      // Por enquanto, retorna placeholder

      LoggerService.w('Google Drive upload not yet implemented', tag: 'SHARE');
      return null;
    } catch (e) {
      LoggerService.e(
        'Error uploading to Google Drive',
        error: e,
        tag: 'SHARE',
      );
      return null;
    }
  }

  /// Faz upload para Dropbox
  Future<String?> uploadToDropbox({
    required String reportTitle,
    required Uint8List pdfBytes,
    String? folderPath,
  }) async {
    try {
      // TODO: Implementar integração com Dropbox API
      // Requer dropbox_client package
      // Por enquanto, retorna placeholder

      LoggerService.w('Dropbox upload not yet implemented', tag: 'SHARE');
      return null;
    } catch (e) {
      LoggerService.e('Error uploading to Dropbox', error: e, tag: 'SHARE');
      return null;
    }
  }

  /// Obtém estatísticas de um link compartilhado
  Future<ShareStatistics?> getShareStatistics(String shareId) async {
    try {
      final response = await _dio.get('$_backendUrl/api/shares/$shareId/stats');

      if (response.statusCode == 200) {
        return ShareStatistics.fromJson(response.data);
      }
      return null;
    } catch (e) {
      LoggerService.e('Error getting share statistics', error: e, tag: 'SHARE');
      return null;
    }
  }

  // Métodos auxiliares privados

  Future<String?> _uploadToServer({
    required String reportId,
    required Uint8List pdfBytes,
  }) async {
    try {
      final formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(pdfBytes, filename: '$reportId.pdf'),
      });

      final response = await _dio.post(
        '$_backendUrl/api/uploads',
        data: formData,
      );

      if (response.statusCode == 200) {
        return response.data['url'] as String;
      }
      return null;
    } catch (e) {
      LoggerService.e('Error uploading to server', error: e, tag: 'SHARE');
      return null;
    }
  }

  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  String _sanitizeFilename(String filename) {
    return filename
        .replaceAll(RegExp(r'[^\w\s-]'), '')
        .replaceAll(RegExp(r'\s+'), '_')
        .toLowerCase();
  }
}

/// Modelo de link público compartilhado
class PublicShareLink {
  final String shareId;
  final String publicUrl;
  final String reportTitle;
  final bool hasPassword;
  final DateTime? expiresAt;
  final int? maxViews;
  final int viewCount;
  final DateTime createdAt;
  final bool isActive;

  PublicShareLink({
    required this.shareId,
    required this.publicUrl,
    required this.reportTitle,
    this.hasPassword = false,
    this.expiresAt,
    this.maxViews,
    this.viewCount = 0,
    required this.createdAt,
    this.isActive = true,
  });

  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  bool get hasReachedMaxViews {
    if (maxViews == null) return false;
    return viewCount >= maxViews!;
  }

  bool get canBeAccessed {
    return isActive && !isExpired && !hasReachedMaxViews;
  }

  Map<String, dynamic> toJson() {
    return {
      'share_id': shareId,
      'public_url': publicUrl,
      'report_title': reportTitle,
      'has_password': hasPassword,
      'expires_at': expiresAt?.toIso8601String(),
      'max_views': maxViews,
      'view_count': viewCount,
      'created_at': createdAt.toIso8601String(),
      'is_active': isActive,
    };
  }

  factory PublicShareLink.fromJson(Map<String, dynamic> json) {
    return PublicShareLink(
      shareId: json['share_id'] as String,
      publicUrl: json['public_url'] as String,
      reportTitle: json['report_title'] as String,
      hasPassword: json['has_password'] as bool? ?? false,
      expiresAt: json['expires_at'] != null
          ? DateTime.parse(json['expires_at'] as String)
          : null,
      maxViews: json['max_views'] as int?,
      viewCount: json['view_count'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      isActive: json['is_active'] as bool? ?? true,
    );
  }
}

/// Estatísticas de compartilhamento
class ShareStatistics {
  final int totalViews;
  final int uniqueViewers;
  final DateTime? lastViewedAt;
  final Map<String, int> viewsByCountry;
  final Map<String, int> viewsByDevice;

  ShareStatistics({
    required this.totalViews,
    required this.uniqueViewers,
    this.lastViewedAt,
    this.viewsByCountry = const {},
    this.viewsByDevice = const {},
  });

  factory ShareStatistics.fromJson(Map<String, dynamic> json) {
    return ShareStatistics(
      totalViews: json['total_views'] as int,
      uniqueViewers: json['unique_viewers'] as int,
      lastViewedAt: json['last_viewed_at'] != null
          ? DateTime.parse(json['last_viewed_at'] as String)
          : null,
      viewsByCountry: Map<String, int>.from(json['views_by_country'] ?? {}),
      viewsByDevice: Map<String, int>.from(json['views_by_device'] ?? {}),
    );
  }
}

/// Singleton do serviço
final reportSharingService = ReportSharingService();
