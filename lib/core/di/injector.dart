import 'package:get_it/get_it.dart';

/// Global service locator.
final GetIt sl = GetIt.instance;

/// Wires the object graph before `runApp`.
///
/// Registration order is fixed: external clients first (Dio, Firebase,
/// storage), then data sources, then repositories, then use cases, then
/// Cubits/Blocs — each layer depending only on the one below it.
///
/// Nothing is registered yet. No client is constructed and no fake is
/// substituted until a real dependency exists to register.
Future<void> configureDependencies() async {
  _registerExternal();
  _registerDataSources();
  _registerRepositories();
  _registerUseCases();
  _registerBlocs();
}

/// Third-party singletons: HTTP client, Firebase apps, secure storage.
void _registerExternal() {}

/// Remote and local data sources, one per feature.
void _registerDataSources() {}

/// `domain` repository contracts bound to their `data` implementations.
void _registerRepositories() {}

/// Single-responsibility interactors consumed by the presentation layer.
void _registerUseCases() {}

/// Cubits/Blocs — registered as factories so each route gets a fresh instance.
void _registerBlocs() {}
