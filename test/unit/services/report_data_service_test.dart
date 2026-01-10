import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:soloforte_app/features/reports/application/report_data_service.dart';
import 'package:soloforte_app/features/occurrences/domain/repositories/occurrence_repository.dart';
import 'package:soloforte_app/features/harvests/data/harvest_repository.dart';
import 'package:soloforte_app/features/visits/domain/repositories/visit_repository.dart';
import 'package:soloforte_app/features/ndvi/data/services/sentinel_service.dart';
import 'package:soloforte_app/features/map/domain/geo_area.dart';
import 'package:latlong2/latlong.dart';

// Import gerado p/ mocks
import 'report_data_service_test.mocks.dart';

@GenerateMocks([
  OccurrenceRepository,
  HarvestRepository,
  VisitRepository,
  SentinelService,
])
void main() {
  late ReportDataService service;
  late MockOccurrenceRepository mockOccurrenceRepo;
  late MockHarvestRepository mockHarvestRepo;
  late MockVisitRepository mockVisitRepo;
  late MockSentinelService mockSentinelService;

  setUp(() {
    mockOccurrenceRepo = MockOccurrenceRepository();
    mockHarvestRepo = MockHarvestRepository();
    mockVisitRepo = MockVisitRepository();
    mockSentinelService = MockSentinelService();

    service = ReportDataService(
      occurrenceRepository: mockOccurrenceRepo,
      harvestRepository: mockHarvestRepo,
      visitRepository: mockVisitRepo,
      sentinelService: mockSentinelService,
    );
  });

  group('ReportDataService - NDVI Analysis', () {
    test('should return default data when areas list is empty', () async {
      final result = await service.getNdviAnalysis(areas: []);
      expect(result.temporalEvolution.length, 1);
      expect(result.temporalEvolution.single.value, 0.0);
      expect(result.areaComparisons, isEmpty);
    });

    test('should process Sentinel data correctly', () async {
      final area = GeoArea(
        id: '1',
        name: 'Area 1',
        points: [const LatLng(0, 0)],
        center: const LatLng(0, 0),

        areaHectares: 10,
      );

      // Mock Sentinel response
      when(
        mockSentinelService.fetchStatistics(
          geoJsonGeometry: anyNamed('geoJsonGeometry'),
          startDate: anyNamed('startDate'),
          endDate: anyNamed('endDate'),
        ),
      ).thenAnswer(
        (_) async => {
          'data': [
            {
              'interval': {'from': '2023-01-01T00:00:00Z'},
              'outputs': {
                'ndvi': {
                  'bands': {
                    'B0': {
                      'stats': {'mean': 0.75},
                    },
                  },
                },
              },
            },
          ],
        },
      );

      final result = await service.getNdviAnalysis(areas: [area]);

      expect(result.temporalEvolution, isNotEmpty);
      expect(result.temporalEvolution.first.value, 0.75);
    });

    test('should handle Sentinel service error gracefully', () async {
      final area = GeoArea(
        id: '1',
        name: 'Area 1',
        points: [],
        center: const LatLng(0, 0),
        areaHectares: 10,
      );

      when(
        mockSentinelService.fetchStatistics(
          geoJsonGeometry: anyNamed('geoJsonGeometry'),
          startDate: anyNamed('startDate'),
          endDate: anyNamed('endDate'),
        ),
      ).thenThrow(Exception('API Error'));

      final result = await service.getNdviAnalysis(areas: [area]);

      // Should return default fallback
      expect(result.temporalEvolution.length, 1);
      expect(result.temporalEvolution.first.value, 0.0);
    });
  });
}
