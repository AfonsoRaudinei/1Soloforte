// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$weatherServiceHash() => r'ab1e9f7d61961dec069a8ce0d90c5f8c55c0881c';

/// See also [weatherService].
@ProviderFor(weatherService)
final weatherServiceProvider = AutoDisposeProvider<WeatherService>.internal(
  weatherService,
  name: r'weatherServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$weatherServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef WeatherServiceRef = AutoDisposeProviderRef<WeatherService>;
String _$weatherForecastHash() => r'5e2d3a1aeb788872ca9c7da486cf57b223553d9b';

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

/// See also [weatherForecast].
@ProviderFor(weatherForecast)
const weatherForecastProvider = WeatherForecastFamily();

/// See also [weatherForecast].
class WeatherForecastFamily extends Family<AsyncValue<WeatherForecast>> {
  /// See also [weatherForecast].
  const WeatherForecastFamily();

  /// See also [weatherForecast].
  WeatherForecastProvider call(double lat, double lon) {
    return WeatherForecastProvider(lat, lon);
  }

  @override
  WeatherForecastProvider getProviderOverride(
    covariant WeatherForecastProvider provider,
  ) {
    return call(provider.lat, provider.lon);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'weatherForecastProvider';
}

/// See also [weatherForecast].
class WeatherForecastProvider
    extends AutoDisposeFutureProvider<WeatherForecast> {
  /// See also [weatherForecast].
  WeatherForecastProvider(double lat, double lon)
    : this._internal(
        (ref) => weatherForecast(ref as WeatherForecastRef, lat, lon),
        from: weatherForecastProvider,
        name: r'weatherForecastProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$weatherForecastHash,
        dependencies: WeatherForecastFamily._dependencies,
        allTransitiveDependencies:
            WeatherForecastFamily._allTransitiveDependencies,
        lat: lat,
        lon: lon,
      );

  WeatherForecastProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.lat,
    required this.lon,
  }) : super.internal();

  final double lat;
  final double lon;

  @override
  Override overrideWith(
    FutureOr<WeatherForecast> Function(WeatherForecastRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: WeatherForecastProvider._internal(
        (ref) => create(ref as WeatherForecastRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        lat: lat,
        lon: lon,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<WeatherForecast> createElement() {
    return _WeatherForecastProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WeatherForecastProvider &&
        other.lat == lat &&
        other.lon == lon;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, lat.hashCode);
    hash = _SystemHash.combine(hash, lon.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin WeatherForecastRef on AutoDisposeFutureProviderRef<WeatherForecast> {
  /// The parameter `lat` of this provider.
  double get lat;

  /// The parameter `lon` of this provider.
  double get lon;
}

class _WeatherForecastProviderElement
    extends AutoDisposeFutureProviderElement<WeatherForecast>
    with WeatherForecastRef {
  _WeatherForecastProviderElement(super.provider);

  @override
  double get lat => (origin as WeatherForecastProvider).lat;
  @override
  double get lon => (origin as WeatherForecastProvider).lon;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
