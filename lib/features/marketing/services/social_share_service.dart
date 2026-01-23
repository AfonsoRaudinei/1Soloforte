import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:soloforte_app/core/services/logger_service.dart';

class SocialShareService {
  /// Compartilha imagens e texto usando o Share nativo (WhatsApp, Instagram Feed, etc.)
  Future<void> shareToFeed({
    required List<String> imagePaths,
    required String text,
  }) async {
    if (imagePaths.isEmpty) {
      await Share.share(text);
    } else {
      final files = imagePaths.map((path) => XFile(path)).toList();
      await Share.shareXFiles(files, text: text);
    }
  }

  /// Tenta abrir o Twitter para postar
  Future<void> shareToTwitter(String text) async {
    final Uri url = Uri.parse(
      'twitter://post?message=${Uri.encodeComponent(text)}',
    );
    final Uri webUrl = Uri.parse(
      'https://twitter.com/intent/tweet?text=${Uri.encodeComponent(text)}',
    );

    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        await launchUrl(webUrl, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      LoggerService.e('Erro ao abrir Twitter', error: e, tag: 'MARKETING');
    }
  }

  /// Tenta abrir o LinkedIn para postar
  Future<void> shareToLinkedIn(String text, String? urlToShare) async {
    // LinkedIn não aceita texto direto pre-fill facilmente sem API paga,
    // mas aceita compartilhamento de URL. Se tivermos uma URL pública do post (ex: web view),
    // é o ideal. Caso contrário, usamos share_plus.

    if (urlToShare != null) {
      final Uri webUrl = Uri.parse(
        'https://www.linkedin.com/sharing/share-offsite/?url=${Uri.encodeComponent(urlToShare)}',
      );
      await launchUrl(webUrl, mode: LaunchMode.externalApplication);
    } else {
      // Fallback para share genérico pois LinkedIn via URL Scheme é limitado
      await Share.share(text);
    }
  }

  /// Instagram Stories requer um fluxo específico de "Stickers"
  /// Isso é uma implementação simplificada que usa o share genérico,
  /// pois a integração "Background Asset" requer configuração nativa pesada no Info.plist/AndroidManifest.
  Future<void> shareToInstagramStory(String imagePath) async {
    await Share.shareXFiles([XFile(imagePath)], text: '#SoloForte');
  }

  Future<void> publishMultiple({
    required List<String> imagePaths,
    required String text,
    required bool toInstagram,
    required bool toFacebook,
    required bool toLinkedIn,
    required bool toTwitter,
  }) async {
    // Fluxo "Multi-Post" simulado:
    // Como não podemos postar background em todos simultaneamente no client-side sem API,
    // o padrão UX é abrir a share sheet principal que permite ao usuário escolher o app.
    // Se o usuário selecionou múltiplos, avisamos que ele precisará compartilhar um por um ou usar o Share central.

    // Prioridade: Se selecionou Twitter, abrimos Twitter.
    if (toTwitter) {
      await shareToTwitter(text);
      // Pausa pequena para UX
      await Future.delayed(const Duration(seconds: 1));
    }

    // Para Instagram/Facebook/LinkedIn com mídia, o melhor é o Share Sheet nativo
    // pois ele já lista todos esses apps se instalados.
    if (toInstagram || toFacebook || toLinkedIn) {
      // Usamos o share nativo que é a implementação mais honesta e robusta sem backend.
      await shareToFeed(imagePaths: imagePaths, text: text);
    }
  }
}
