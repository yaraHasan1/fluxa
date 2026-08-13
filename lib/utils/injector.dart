import 'package:get_it/get_it.dart';

import 'package:fluxa/api/api_client.dart';
import 'package:fluxa/api/auth_api.dart';
import 'package:fluxa/api/token_store.dart';
import 'package:fluxa/api/breakers_api.dart';

/// Global service locator.
final GetIt sl = GetIt.instance;

/// Wires the object graph before `runApp`.
///
/// Registration order is fixed: the HTTP client first, then the endpoint
/// wrappers that use it, then anything holding session state. Cubits are not
/// registered — each screen constructs its own from these.
Future<void> configureDependencies() async {
  // Idempotent: tests configure the graph once per file, and a hot restart
  // can run this again.
  if (sl.isRegistered<ApiClient>()) return;

  sl
    ..registerLazySingleton<TokenStore>(TokenStore.new)
    ..registerLazySingleton<ApiClient>(
      () => ApiClient(tokens: sl<TokenStore>()),
    )
    ..registerLazySingleton<BreakersApi>(() => BreakersApi(sl<ApiClient>()))
    ..registerLazySingleton<AuthApi>(() => AuthApi(sl<ApiClient>()));
}
