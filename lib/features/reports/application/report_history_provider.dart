import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soloforte_app/features/reports/domain/report_history.dart';
import 'package:soloforte_app/features/reports/domain/report_configuration.dart';
import 'package:soloforte_app/core/services/logger_service.dart';
import 'dart:convert';

/// Notifier para gerenciar o histórico de relatórios
class ReportHistoryNotifier extends ChangeNotifier {
  static const String _storageKey = 'report_history';
  final SharedPreferences _prefs;
  List<SavedReport> _reports = [];
  List<ReportSchedule> _schedules = [];

  ReportHistoryNotifier(this._prefs) {
    _loadHistory();
  }

  List<SavedReport> get reports => List.unmodifiable(_reports);
  List<SavedReport> get favorites =>
      _reports.where((r) => r.isFavorite).toList();
  List<ReportSchedule> get schedules => List.unmodifiable(_schedules);
  List<ReportSchedule> get activeSchedules =>
      _schedules.where((s) => s.isActive).toList();

  void _loadHistory() {
    final savedJson = _prefs.getString(_storageKey);
    if (savedJson != null) {
      try {
        final Map<String, dynamic> data = json.decode(savedJson);
        _reports =
            (data['reports'] as List?)
                ?.map((item) => SavedReport.fromJson(item))
                .toList() ??
            [];
        _schedules =
            (data['schedules'] as List?)
                ?.map((item) => ReportSchedule.fromJson(item))
                .toList() ??
            [];
      } catch (e) {
        LoggerService.e(
          'Error loading report history',
          error: e,
          tag: 'REPORTS',
        );
        _reports = [];
        _schedules = [];
      }
    }
    notifyListeners();
  }

  Future<void> _saveHistory() async {
    final data = {
      'reports': _reports.map((r) => r.toJson()).toList(),
      'schedules': _schedules.map((s) => s.toJson()).toList(),
    };
    await _prefs.setString(_storageKey, json.encode(data));
  }

  // Gerenciamento de Relatórios
  Future<void> addReport(SavedReport report) async {
    final index = _reports.indexWhere((r) => r.id == report.id);
    if (index != -1) {
      final existing = _reports[index];
      _reports[index] = existing.copyWith(
        title: report.title,
        template: report.template,
        createdAt: report.createdAt,
        configuration: report.configuration,
        pdfPath: report.pdfPath ?? existing.pdfPath,
        fileSizeBytes: report.fileSizeBytes ?? existing.fileSizeBytes,
        sharedLink: report.sharedLink ?? existing.sharedLink,
      );
    } else {
      _reports.insert(0, report); // Mais recente primeiro
    }
    notifyListeners();
    await _saveHistory();
  }

  Future<void> deleteReport(String reportId) async {
    _reports.removeWhere((r) => r.id == reportId);
    notifyListeners();
    await _saveHistory();
  }

  Future<void> toggleFavorite(String reportId) async {
    final index = _reports.indexWhere((r) => r.id == reportId);
    if (index != -1) {
      _reports[index] = _reports[index].copyWith(
        isFavorite: !_reports[index].isFavorite,
      );
      notifyListeners();
      await _saveHistory();
    }
  }

  Future<void> updateViewCount(String reportId) async {
    final index = _reports.indexWhere((r) => r.id == reportId);
    if (index != -1) {
      _reports[index] = _reports[index].copyWith(
        viewCount: _reports[index].viewCount + 1,
        lastViewedAt: DateTime.now(),
      );
      notifyListeners();
      await _saveHistory();
    }
  }

  Future<SavedReport> duplicateReport(String reportId) async {
    final original = _reports.firstWhere((r) => r.id == reportId);
    final duplicate = SavedReport(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: '${original.title} (Cópia)',
      template: original.template,
      createdAt: DateTime.now(),
      configuration: original.configuration,
      isFavorite: false,
    );
    await addReport(duplicate);
    return duplicate;
  }

  // Gerenciamento de Agendamentos
  Future<void> addSchedule(ReportSchedule schedule) async {
    _schedules.add(schedule);
    notifyListeners();
    await _saveHistory();
  }

  Future<void> deleteSchedule(String scheduleId) async {
    _schedules.removeWhere((s) => s.id == scheduleId);
    notifyListeners();
    await _saveHistory();
  }

  Future<void> toggleScheduleActive(String scheduleId) async {
    final index = _schedules.indexWhere((s) => s.id == scheduleId);
    if (index != -1) {
      _schedules[index] = _schedules[index].copyWith(
        isActive: !_schedules[index].isActive,
      );
      notifyListeners();
      await _saveHistory();
    }
  }

  Future<void> updateScheduleLastRun(
    String scheduleId,
    DateTime lastRun,
  ) async {
    final index = _schedules.indexWhere((s) => s.id == scheduleId);
    if (index != -1) {
      _schedules[index] = _schedules[index].copyWith(
        lastRunAt: lastRun,
        nextRunAt: _calculateNextRun(_schedules[index].frequency, lastRun),
      );
      notifyListeners();
      await _saveHistory();
    }
  }

  DateTime _calculateNextRun(ScheduleFrequency frequency, DateTime lastRun) {
    switch (frequency) {
      case ScheduleFrequency.daily:
        return lastRun.add(const Duration(days: 1));
      case ScheduleFrequency.weekly:
        return lastRun.add(const Duration(days: 7));
      case ScheduleFrequency.monthly:
        return DateTime(lastRun.year, lastRun.month + 1, lastRun.day);
      case ScheduleFrequency.custom:
        return lastRun.add(const Duration(days: 1)); // Default
    }
  }

  // Busca e Filtros
  List<SavedReport> searchReports(String query) {
    if (query.isEmpty) return _reports;
    return _reports
        .where((r) => r.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  List<SavedReport> filterByTemplate(ReportTemplate template) {
    return _reports.where((r) => r.template == template).toList();
  }

  List<SavedReport> filterByDateRange(DateTime start, DateTime end) {
    return _reports
        .where((r) => r.createdAt.isAfter(start) && r.createdAt.isBefore(end))
        .toList();
  }
}

// Provider para SharedPreferences (reutilizando do custom_report_layout_provider)
final sharedPreferencesProvider = FutureProvider<SharedPreferences>((
  ref,
) async {
  return await SharedPreferences.getInstance();
});

// Provider para histórico de relatórios
final reportHistoryProvider = ChangeNotifierProvider<ReportHistoryNotifier>((
  ref,
) {
  final prefs = ref.watch(sharedPreferencesProvider).value;
  if (prefs == null) {
    throw Exception('SharedPreferences not initialized');
  }
  return ReportHistoryNotifier(prefs);
});
