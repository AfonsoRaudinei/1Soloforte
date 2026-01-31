// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'occurrence_detail_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$occurrenceDetailHash() => r'3ccbbfd7364cbed7a97e71af2653bc47743bb6dc';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [occurrenceDetail].
@ProviderFor(occurrenceDetail)
const occurrenceDetailProvider = OccurrenceDetailFamily();

/// See also [occurrenceDetail].
class OccurrenceDetailFamily extends Family<AsyncValue<Occurrence?>> {
  /// See also [occurrenceDetail].
  const OccurrenceDetailFamily();

  /// See also [occurrenceDetail].
  OccurrenceDetailProvider call(String id) {
    return OccurrenceDetailProvider(id);
  }

  @override
  OccurrenceDetailProvider getProviderOverride(
    covariant OccurrenceDetailProvider provider,
  ) {
    return call(provider.id);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'occurrenceDetailProvider';
}

/// See also [occurrenceDetail].
class OccurrenceDetailProvider extends AutoDisposeFutureProvider<Occurrence?> {
  /// See also [occurrenceDetail].
  OccurrenceDetailProvider(String id)
    : this._internal(
        (ref) => occurrenceDetail(ref as OccurrenceDetailRef, id),
        from: occurrenceDetailProvider,
        name: r'occurrenceDetailProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$occurrenceDetailHash,
        dependencies: OccurrenceDetailFamily._dependencies,
        allTransitiveDependencies:
            OccurrenceDetailFamily._allTransitiveDependencies,
        id: id,
      );

  OccurrenceDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(
    FutureOr<Occurrence?> Function(OccurrenceDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: OccurrenceDetailProvider._internal(
        (ref) => create(ref as OccurrenceDetailRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Occurrence?> createElement() {
    return _OccurrenceDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is OccurrenceDetailProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin OccurrenceDetailRef on AutoDisposeFutureProviderRef<Occurrence?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _OccurrenceDetailProviderElement
    extends AutoDisposeFutureProviderElement<Occurrence?>
    with OccurrenceDetailRef {
  _OccurrenceDetailProviderElement(super.provider);

  @override
  String get id => (origin as OccurrenceDetailProvider).id;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
