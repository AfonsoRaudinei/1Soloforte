// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analysis_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(analysisRepository)
const analysisRepositoryProvider = AnalysisRepositoryProvider._();

final class AnalysisRepositoryProvider
    extends
        $FunctionalProvider<
          AnalysisRepository,
          AnalysisRepository,
          AnalysisRepository
        >
    with $Provider<AnalysisRepository> {
  const AnalysisRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'analysisRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$analysisRepositoryHash();

  @$internal
  @override
  $ProviderElement<AnalysisRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AnalysisRepository create(Ref ref) {
    return analysisRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AnalysisRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AnalysisRepository>(value),
    );
  }
}

String _$analysisRepositoryHash() =>
    r'920cb9dcb6e3544a4ef2e985e814f8ee660e1c33';
