// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ndvi_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(NdviController)
const ndviControllerProvider = NdviControllerProvider._();

final class NdviControllerProvider
    extends $NotifierProvider<NdviController, NdviState> {
  const NdviControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ndviControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ndviControllerHash();

  @$internal
  @override
  NdviController create() => NdviController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NdviState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NdviState>(value),
    );
  }
}

String _$ndviControllerHash() => r'a2a5158bd8937605e94046e152c372f1e9b8fa5b';

abstract class _$NdviController extends $Notifier<NdviState> {
  NdviState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<NdviState, NdviState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<NdviState, NdviState>,
              NdviState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
