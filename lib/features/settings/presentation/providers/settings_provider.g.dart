// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$settingsLocalDataSourceHash() =>
    r'13202009f588cf153db75740a2678844179728b6';

/// See also [settingsLocalDataSource].
@ProviderFor(settingsLocalDataSource)
final settingsLocalDataSourceProvider =
    AutoDisposeProvider<ISettingsLocalDataSource>.internal(
      settingsLocalDataSource,
      name: r'settingsLocalDataSourceProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$settingsLocalDataSourceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SettingsLocalDataSourceRef =
    AutoDisposeProviderRef<ISettingsLocalDataSource>;
String _$settingsRemoteDataSourceHash() =>
    r'1ea0915fff37fa4532f5061a9c3a65595bd06d20';

/// See also [settingsRemoteDataSource].
@ProviderFor(settingsRemoteDataSource)
final settingsRemoteDataSourceProvider =
    AutoDisposeProvider<ISettingsRemoteDataSource>.internal(
      settingsRemoteDataSource,
      name: r'settingsRemoteDataSourceProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$settingsRemoteDataSourceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SettingsRemoteDataSourceRef =
    AutoDisposeProviderRef<ISettingsRemoteDataSource>;
String _$settingsRepositoryHash() =>
    r'7ba8d43577408d49d0059d43fb8e7d16e3697b8c';

/// See also [settingsRepository].
@ProviderFor(settingsRepository)
final settingsRepositoryProvider =
    AutoDisposeProvider<ISettingsRepository>.internal(
      settingsRepository,
      name: r'settingsRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$settingsRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SettingsRepositoryRef = AutoDisposeProviderRef<ISettingsRepository>;
String _$settingsControllerHash() =>
    r'48fad100ae6c437d14b821de84dff3577e3a3e0c';

/// See also [SettingsController].
@ProviderFor(SettingsController)
final settingsControllerProvider =
    AutoDisposeAsyncNotifierProvider<SettingsController, AppSettings>.internal(
      SettingsController.new,
      name: r'settingsControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$settingsControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SettingsController = AutoDisposeAsyncNotifier<AppSettings>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
