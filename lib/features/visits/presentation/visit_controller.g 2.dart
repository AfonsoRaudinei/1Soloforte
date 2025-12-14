// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visit_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(VisitController)
const visitControllerProvider = VisitControllerProvider._();

final class VisitControllerProvider
    extends $NotifierProvider<VisitController, Visit?> {
  const VisitControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'visitControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$visitControllerHash();

  @$internal
  @override
  VisitController create() => VisitController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Visit? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Visit?>(value),
    );
  }
}

String _$visitControllerHash() => r'dbbd9f6325c724887517929a32e2906eac769e4c';

abstract class _$VisitController extends $Notifier<Visit?> {
  Visit? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Visit?, Visit?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Visit?, Visit?>,
              Visit?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
