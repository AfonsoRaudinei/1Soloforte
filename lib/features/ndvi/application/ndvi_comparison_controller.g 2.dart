// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ndvi_comparison_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(NdviComparisonController)
const ndviComparisonControllerProvider = NdviComparisonControllerProvider._();

final class NdviComparisonControllerProvider
    extends $NotifierProvider<NdviComparisonController, NdviComparisonState> {
  const NdviComparisonControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ndviComparisonControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ndviComparisonControllerHash();

  @$internal
  @override
  NdviComparisonController create() => NdviComparisonController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NdviComparisonState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NdviComparisonState>(value),
    );
  }
}

String _$ndviComparisonControllerHash() =>
    r'a6d381917b9a8b9d05854019be6d7e2795218dc6';

abstract class _$NdviComparisonController
    extends $Notifier<NdviComparisonState> {
  NdviComparisonState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<NdviComparisonState, NdviComparisonState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<NdviComparisonState, NdviComparisonState>,
              NdviComparisonState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
