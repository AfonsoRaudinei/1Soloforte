// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_detail_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(clientById)
const clientByIdProvider = ClientByIdFamily._();

final class ClientByIdProvider
    extends $FunctionalProvider<AsyncValue<Client?>, Client?, FutureOr<Client?>>
    with $FutureModifier<Client?>, $FutureProvider<Client?> {
  const ClientByIdProvider._({
    required ClientByIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'clientByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$clientByIdHash();

  @override
  String toString() {
    return r'clientByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Client?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Client?> create(Ref ref) {
    final argument = this.argument as String;
    return clientById(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ClientByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$clientByIdHash() => r'b696ea76b2f4d7e9f5255a9f3e670e4a17f50b2a';

final class ClientByIdFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Client?>, String> {
  const ClientByIdFamily._()
    : super(
        retry: null,
        name: r'clientByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ClientByIdProvider call(String clientId) =>
      ClientByIdProvider._(argument: clientId, from: this);

  @override
  String toString() => r'clientByIdProvider';
}

@ProviderFor(clientFarms)
const clientFarmsProvider = ClientFarmsFamily._();

final class ClientFarmsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Farm>>,
          List<Farm>,
          FutureOr<List<Farm>>
        >
    with $FutureModifier<List<Farm>>, $FutureProvider<List<Farm>> {
  const ClientFarmsProvider._({
    required ClientFarmsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'clientFarmsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$clientFarmsHash();

  @override
  String toString() {
    return r'clientFarmsProvider'
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
    return clientFarms(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ClientFarmsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$clientFarmsHash() => r'65a03358fffa890a58c4d1b0e480f88ae1ff83c9';

final class ClientFarmsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Farm>>, String> {
  const ClientFarmsFamily._()
    : super(
        retry: null,
        name: r'clientFarmsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ClientFarmsProvider call(String clientId) =>
      ClientFarmsProvider._(argument: clientId, from: this);

  @override
  String toString() => r'clientFarmsProvider';
}

@ProviderFor(clientHistory)
const clientHistoryProvider = ClientHistoryFamily._();

final class ClientHistoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ClientHistory>>,
          List<ClientHistory>,
          FutureOr<List<ClientHistory>>
        >
    with
        $FutureModifier<List<ClientHistory>>,
        $FutureProvider<List<ClientHistory>> {
  const ClientHistoryProvider._({
    required ClientHistoryFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'clientHistoryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$clientHistoryHash();

  @override
  String toString() {
    return r'clientHistoryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<ClientHistory>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ClientHistory>> create(Ref ref) {
    final argument = this.argument as String;
    return clientHistory(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ClientHistoryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$clientHistoryHash() => r'5d5af64078e6d54df148da9b4eb6c76195dcb3e8';

final class ClientHistoryFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<ClientHistory>>, String> {
  const ClientHistoryFamily._()
    : super(
        retry: null,
        name: r'clientHistoryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ClientHistoryProvider call(String clientId) =>
      ClientHistoryProvider._(argument: clientId, from: this);

  @override
  String toString() => r'clientHistoryProvider';
}

@ProviderFor(clientStats)
const clientStatsProvider = ClientStatsFamily._();

final class ClientStatsProvider
    extends
        $FunctionalProvider<
          AsyncValue<ClientStats>,
          ClientStats,
          FutureOr<ClientStats>
        >
    with $FutureModifier<ClientStats>, $FutureProvider<ClientStats> {
  const ClientStatsProvider._({
    required ClientStatsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'clientStatsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$clientStatsHash();

  @override
  String toString() {
    return r'clientStatsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<ClientStats> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ClientStats> create(Ref ref) {
    final argument = this.argument as String;
    return clientStats(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ClientStatsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$clientStatsHash() => r'15b6045674783984567bdb6c4398f981914935ce';

final class ClientStatsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<ClientStats>, String> {
  const ClientStatsFamily._()
    : super(
        retry: null,
        name: r'clientStatsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ClientStatsProvider call(String clientId) =>
      ClientStatsProvider._(argument: clientId, from: this);

  @override
  String toString() => r'clientStatsProvider';
}
