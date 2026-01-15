// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agenda_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$filteredAgendaHash() => r'd90f2a7828fdea13e6cf3b2e78c54b709a8ce17c';

/// See also [filteredAgenda].
@ProviderFor(filteredAgenda)
final filteredAgendaProvider =
    AutoDisposeProvider<AsyncValue<List<Event>>>.internal(
      filteredAgenda,
      name: r'filteredAgendaProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$filteredAgendaHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FilteredAgendaRef = AutoDisposeProviderRef<AsyncValue<List<Event>>>;
String _$agendaControllerHash() => r'd72d9eb40541e95d1265518e459aabcf0517bde7';

/// See also [AgendaController].
@ProviderFor(AgendaController)
final agendaControllerProvider =
    AutoDisposeAsyncNotifierProvider<AgendaController, List<Event>>.internal(
      AgendaController.new,
      name: r'agendaControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$agendaControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AgendaController = AutoDisposeAsyncNotifier<List<Event>>;
String _$agendaFilterHash() => r'2a995aecf08de557c5e61338c9f5f7090cfe5b96';

/// See also [AgendaFilter].
@ProviderFor(AgendaFilter)
final agendaFilterProvider =
    AutoDisposeNotifierProvider<AgendaFilter, AgendaFilterState>.internal(
      AgendaFilter.new,
      name: r'agendaFilterProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$agendaFilterHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AgendaFilter = AutoDisposeNotifier<AgendaFilterState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
