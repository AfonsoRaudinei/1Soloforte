// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_history_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(clientHistoryRepository)
const clientHistoryRepositoryProvider = ClientHistoryRepositoryProvider._();

final class ClientHistoryRepositoryProvider
    extends
        $FunctionalProvider<
          ClientHistoryRepository,
          ClientHistoryRepository,
          ClientHistoryRepository
        >
    with $Provider<ClientHistoryRepository> {
  const ClientHistoryRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'clientHistoryRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$clientHistoryRepositoryHash();

  @$internal
  @override
  $ProviderElement<ClientHistoryRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ClientHistoryRepository create(Ref ref) {
    return clientHistoryRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ClientHistoryRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ClientHistoryRepository>(value),
    );
  }
}

String _$clientHistoryRepositoryHash() =>
    r'd87c3ac8a5c6ad268341f53c1e7bce474e98d0c8';
