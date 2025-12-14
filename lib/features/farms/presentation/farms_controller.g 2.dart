// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'farms_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(FarmsController)
const farmsControllerProvider = FarmsControllerProvider._();

final class FarmsControllerProvider
    extends $AsyncNotifierProvider<FarmsController, List<Farm>> {
  const FarmsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'farmsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$farmsControllerHash();

  @$internal
  @override
  FarmsController create() => FarmsController();
}

String _$farmsControllerHash() => r'9095c6a11c9ec9ef9e83043f53f021763caa2ce9';

abstract class _$FarmsController extends $AsyncNotifier<List<Farm>> {
  FutureOr<List<Farm>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<Farm>>, List<Farm>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Farm>>, List<Farm>>,
              AsyncValue<List<Farm>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(farmsByClient)
const farmsByClientProvider = FarmsByClientFamily._();

final class FarmsByClientProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Farm>>,
          List<Farm>,
          FutureOr<List<Farm>>
        >
    with $FutureModifier<List<Farm>>, $FutureProvider<List<Farm>> {
  const FarmsByClientProvider._({
    required FarmsByClientFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'farmsByClientProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$farmsByClientHash();

  @override
  String toString() {
    return r'farmsByClientProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Farm>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Farm>> create(Ref ref) {
    final argument = this.argument as String;
    return farmsByClient(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is FarmsByClientProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$farmsByClientHash() => r'3e05986e2e0e42143b6c686853b1adcf221dde57';

final class FarmsByClientFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Farm>>, String> {
  const FarmsByClientFamily._()
    : super(
        retry: null,
        name: r'farmsByClientProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  FarmsByClientProvider call(String clientId) =>
      FarmsByClientProvider._(argument: clientId, from: this);

  @override
  String toString() => r'farmsByClientProvider';
}

@ProviderFor(farmById)
const farmByIdProvider = FarmByIdFamily._();

final class FarmByIdProvider
    extends $FunctionalProvider<AsyncValue<Farm?>, Farm?, FutureOr<Farm?>>
    with $FutureModifier<Farm?>, $FutureProvider<Farm?> {
  const FarmByIdProvider._({
    required FarmByIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'farmByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$farmByIdHash();

  @override
  String toString() {
    return r'farmByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Farm?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Farm?> create(Ref ref) {
    final argument = this.argument as String;
    return farmById(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is FarmByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$farmByIdHash() => r'a3d2071dd992a5c08b093718f8305168170afd27';

final class FarmByIdFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Farm?>, String> {
  const FarmByIdFamily._()
    : super(
        retry: null,
        name: r'farmByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  FarmByIdProvider call(String id) =>
      FarmByIdProvider._(argument: id, from: this);

  @override
  String toString() => r'farmByIdProvider';
}
