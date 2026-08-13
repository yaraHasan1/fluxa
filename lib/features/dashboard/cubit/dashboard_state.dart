part of 'dashboard_cubit.dart';

/// What the dashboard is showing.
///
/// The breakers are real — fetched from the API. Consumption and the energy
/// sources still arrive through [DashboardCubit.show], because there is no
/// telemetry service behind them yet.
class DashboardState extends Equatable {
  const DashboardState({
    this.status = SystemStatus.healthy,
    this.consumptionKw,
    this.sources = const <EnergySource>[],
    this.breakers = const <Breaker>[],
    this.sourcesExpanded = false,
    this.breakersStatus = RequestStatus.idle,
    this.error,
    this.switching = const <String>{},
  });

  final SystemStatus status;

  /// Null until a reading exists.
  final double? consumptionKw;

  final List<EnergySource> sources;

  /// Every breaker on the account, in the order the API listed them.
  final List<Breaker> breakers;

  /// Whether the Energy sources section is showing its per-source cards.
  final bool sourcesExpanded;

  /// How the breaker list request is going.
  final RequestStatus breakersStatus;

  /// The last failure, from either the list or a switch.
  final String? error;

  /// Device ids with a switch in flight, so a row can lock while it lands.
  final Set<String> switching;

  bool isSwitching(String deviceId) => switching.contains(deviceId);

  /// The breaker with this id, or null once it has left the list.
  Breaker? breakerFor(String deviceId) {
    for (final Breaker b in breakers) {
      if (b.deviceId == deviceId) return b;
    }
    return null;
  }

  /// TEMPORARY: the figures from the design frame, so the screen can be seen
  /// before the telemetry service exists. Delete once readings are real.
  factory DashboardState.placeholder() => const DashboardState(
    consumptionKw: 2.3,
    sources: <EnergySource>[
      EnergySource(kind: EnergySourceKind.solar, kilowatts: 2.3),
      EnergySource(kind: EnergySourceKind.wind, kilowatts: 2.3),
      EnergySource(
        kind: EnergySourceKind.battery,
        kilowatts: 2.3,
        chargePercent: 85,
      ),
    ],
  );

  DashboardState copyWith({
    SystemStatus? status,
    double? consumptionKw,
    List<EnergySource>? sources,
    List<Breaker>? breakers,
    bool? sourcesExpanded,
    RequestStatus? breakersStatus,
    String? error,
    bool clearError = false,
    Set<String>? switching,
  }) => DashboardState(
    status: status ?? this.status,
    consumptionKw: consumptionKw ?? this.consumptionKw,
    sources: sources ?? this.sources,
    breakers: breakers ?? this.breakers,
    sourcesExpanded: sourcesExpanded ?? this.sourcesExpanded,
    breakersStatus: breakersStatus ?? this.breakersStatus,
    error: clearError ? null : error ?? this.error,
    switching: switching ?? this.switching,
  );

  @override
  List<Object?> get props => <Object?>[
    status,
    consumptionKw,
    sources,
    breakers,
    sourcesExpanded,
    breakersStatus,
    error,
    switching,
  ];
}
