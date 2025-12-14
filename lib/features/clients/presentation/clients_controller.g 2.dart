// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clients_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ClientsController)
const clientsControllerProvider = ClientsControllerProvider._();

final class ClientsControllerProvider
    extends $AsyncNotifierProvider<ClientsController, List<Client>> {
  const ClientsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'clientsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$clientsControllerHash();

  @$internal
  @override
  ClientsController create() => ClientsController();
}

String _$clientsControllerHash() => r'9c550da26c14d85560eb938aab2987abfbd985a9';

abstract class _$ClientsController extends $AsyncNotifier<List<Client>> {
  FutureOr<List<Client>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<Client>>, List<Client>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Client>>, List<Client>>,
              AsyncValue<List<Client>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
