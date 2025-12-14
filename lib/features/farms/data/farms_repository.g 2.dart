// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'farms_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(farmsRepository)
const farmsRepositoryProvider = FarmsRepositoryProvider._();

final class FarmsRepositoryProvider
    extends
        $FunctionalProvider<FarmsRepository, FarmsRepository, FarmsRepository>
    with $Provider<FarmsRepository> {
  const FarmsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'farmsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$farmsRepositoryHash();

  @$internal
  @override
  $ProviderElement<FarmsRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  FarmsRepository create(Ref ref) {
    return farmsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FarmsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FarmsRepository>(value),
    );
  }
}

String _$farmsRepositoryHash() => r'361f410f487f36f59e92a04c4f4066560688caa6';
