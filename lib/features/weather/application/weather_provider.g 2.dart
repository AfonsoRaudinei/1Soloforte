// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(weatherService)
const weatherServiceProvider = WeatherServiceProvider._();

final class WeatherServiceProvider
    extends $FunctionalProvider<WeatherService, WeatherService, WeatherService>
    with $Provider<WeatherService> {
  const WeatherServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'weatherServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$weatherServiceHash();

  @$internal
  @override
  $ProviderElement<WeatherService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  WeatherService create(Ref ref) {
    return weatherService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WeatherService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WeatherService>(value),
    );
  }
}

String _$weatherServiceHash() => r'2fd79056223350f17986c2e598357fb950e6c4dc';

@ProviderFor(weatherForecast)
const weatherForecastProvider = WeatherForecastFamily._();

final class WeatherForecastProvider
    extends
        $FunctionalProvider<
          AsyncValue<WeatherForecast>,
          WeatherForecast,
          FutureOr<WeatherForecast>
        >
    with $FutureModifier<WeatherForecast>, $FutureProvider<WeatherForecast> {
  const WeatherForecastProvider._({
    required WeatherForecastFamily super.from,
    required (double, double) super.argument,
  }) : super(
         retry: null,
         name: r'weatherForecastProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$weatherForecastHash();

  @override
  String toString() {
    return r'weatherForecastProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<WeatherForecast> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<WeatherForecast> create(Ref ref) {
    final argument = this.argument as (double, double);
    return weatherForecast(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is WeatherForecastProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$weatherForecastHash() => r'6ac53afd88be45f95230b6e691f191996b129920';

final class WeatherForecastFamily extends $Family
    with
        $FunctionalFamilyOverride<FutureOr<WeatherForecast>, (double, double)> {
  const WeatherForecastFamily._()
    : super(
        retry: null,
        name: r'weatherForecastProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  WeatherForecastProvider call(double lat, double lon) =>
      WeatherForecastProvider._(argument: (lat, lon), from: this);

  @override
  String toString() => r'weatherForecastProvider';
}
