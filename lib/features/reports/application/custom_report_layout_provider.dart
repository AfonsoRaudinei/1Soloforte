import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soloforte_app/features/reports/domain/report_models.dart';
import 'package:soloforte_app/core/services/logger_service.dart';

class CustomReportLayoutNotifier extends ChangeNotifier {
  static const String _storageKey = 'custom_report_layout';
  final SharedPreferences _prefs;
  List<ReportSection> _sections = [];

  CustomReportLayoutNotifier(this._prefs) {
    _loadLayout();
  }

  List<ReportSection> get sections => List.unmodifiable(_sections);

  // Default sections
  List<ReportSection> get _defaultSections => [
    ReportSection(
      id: '1',
      title: 'Resumo Executivo',
      type: ReportSectionType.text,
    ),
    ReportSection(
      id: '2',
      title: 'Gráfico de Produtividade',
      type: ReportSectionType.chart,
    ),
    ReportSection(
      id: '3',
      title: 'Mapa de Calor NDVI',
      type: ReportSectionType.map,
    ),
    ReportSection(
      id: '4',
      title: 'Tabela de Custos',
      type: ReportSectionType.table,
    ),
    ReportSection(
      id: '5',
      title: 'Lista de Ocorrências',
      type: ReportSectionType.table,
    ),
    ReportSection(
      id: '6',
      title: 'Métricas de Clima',
      type: ReportSectionType.metrics,
    ),
  ];

  void _loadLayout() {
    final savedJson = _prefs.getString(_storageKey);
    if (savedJson != null) {
      try {
        final List<dynamic> decoded = json.decode(savedJson);
        _sections = decoded.map((item) {
          return ReportSection(
            id: item['id'] as String,
            title: item['title'] as String,
            type: ReportSectionType.values.firstWhere(
              (e) => e.toString() == item['type'],
            ),
            isVisible: item['isVisible'] as bool? ?? true,
          );
        }).toList();
      } catch (e) {
        LoggerService.e(
          'Error loading custom report layout',
          error: e,
          tag: 'REPORTS',
        );
        _sections = _defaultSections;
      }
    } else {
      _sections = _defaultSections;
    }
    notifyListeners();
  }

  Future<void> _saveLayout() async {
    final encoded = json.encode(
      _sections.map((section) {
        return {
          'id': section.id,
          'title': section.title,
          'type': section.type.toString(),
          'isVisible': section.isVisible,
        };
      }).toList(),
    );
    await _prefs.setString(_storageKey, encoded);
  }

  void reorderSections(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final item = _sections.removeAt(oldIndex);
    _sections.insert(newIndex, item);
    notifyListeners();
    _saveLayout();
  }

  void toggleVisibility(String sectionId) {
    _sections = _sections.map((section) {
      if (section.id == sectionId) {
        return ReportSection(
          id: section.id,
          title: section.title,
          type: section.type,
          isVisible: !section.isVisible,
        );
      }
      return section;
    }).toList();
    notifyListeners();
    _saveLayout();
  }

  Future<void> resetToDefault() async {
    _sections = _defaultSections;
    notifyListeners();
    await _saveLayout();
  }
}

// SharedPreferences provider
final sharedPreferencesProvider = FutureProvider<SharedPreferences>((
  ref,
) async {
  return await SharedPreferences.getInstance();
});

// Custom report layout provider
final customReportLayoutProvider =
    ChangeNotifierProvider<CustomReportLayoutNotifier>((ref) {
      final prefs = ref.watch(sharedPreferencesProvider).value;
      if (prefs == null) {
        throw Exception('SharedPreferences not initialized');
      }
      return CustomReportLayoutNotifier(prefs);
    });
