// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$appPackageInfoHash() => r'f68e0449eca755182143d16ee3ba36b99ff3be0d';

/// See also [appPackageInfo].
@ProviderFor(appPackageInfo)
final appPackageInfoProvider = AutoDisposeFutureProvider<PackageInfo>.internal(
  appPackageInfo,
  name: r'appPackageInfoProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$appPackageInfoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AppPackageInfoRef = AutoDisposeFutureProviderRef<PackageInfo>;
String _$settingsControllerHash() =>
    r'bc8d5c23a6267c8e1fa59d1f4776311ec51fb0a6';

/// Settings Controller
/// Holds every method meant to mutate the state of the app settings
///
/// Copied from [SettingsController].
@ProviderFor(SettingsController)
final settingsControllerProvider =
    AutoDisposeNotifierProvider<SettingsController, SettingsState>.internal(
  SettingsController.new,
  name: r'settingsControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$settingsControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SettingsController = AutoDisposeNotifier<SettingsState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
