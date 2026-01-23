import 'package:soloforte_app/core/services/logger_service.dart';

class MarketingInteractionTracker {
  MarketingInteractionTracker._();

  static void pinOpened({required String publicationId}) {
    _log('pin_opened', publicationId: publicationId);
  }

  static void sheetOpened({required String publicationId}) {
    _log('sheet_opened', publicationId: publicationId);
  }

  static void sheetClosed({required String publicationId}) {
    _log('sheet_closed', publicationId: publicationId);
  }

  static void ctaClicked({required String publicationId}) {
    _log('cta_clicked', publicationId: publicationId);
  }

  static void _log(String eventType, {required String publicationId}) {
    LoggerService.i(
      'marketing_interaction=$eventType publication_id=$publicationId origin=map',
      tag: 'Marketing',
    );
  }
}
