part of 'dashboard_cubit.dart';

/// What the dashboard is showing.
///
/// There is no repository behind this yet, so the readings arrive through
/// [DashboardCubit.show] rather than being fetched. Nothing here invents a
/// value: an unsupplied dashboard renders empty.
class DashboardState extends Equatable {
  const DashboardState({
    this.status = SystemStatus.healthy,
    this.consumptionKw,
    this.sources = const <EnergySource>[],
    this.breakers = const <CircuitBreaker>[],
    this.sourcesExpanded = false,
  });

  final SystemStatus status;

  /// Null until a reading exists.
  final double? consumptionKw;

  final List<EnergySource> sources;
  final List<CircuitBreaker> breakers;

  /// Whether the Energy sources section is showing its per-source cards.
  final bool sourcesExpanded;

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
    breakers: <CircuitBreaker>[
      CircuitBreaker(
        name: 'office pcs',
        device: BreakerDevice.pc,
        priority: 1,
        kilowatts: 2.3,
        isOn: true,
      ),
      CircuitBreaker(
        name: 'server room',
        device: BreakerDevice.server,
        priority: 2,
        kilowatts: 2.3,
        isOn: true,
      ),
      CircuitBreaker(
        name: 'air conditioner',
        device: BreakerDevice.airConditioner,
        priority: 3,
        kilowatts: 2.3,
        isOn: false,
      ),
    ],
  );

  DashboardState copyWith({
    SystemStatus? status,
    double? consumptionKw,
    List<EnergySource>? sources,
    List<CircuitBreaker>? breakers,
    bool? sourcesExpanded,
  }) => DashboardState(
    status: status ?? this.status,
    consumptionKw: consumptionKw ?? this.consumptionKw,
    sources: sources ?? this.sources,
    breakers: breakers ?? this.breakers,
    sourcesExpanded: sourcesExpanded ?? this.sourcesExpanded,
  );

  @override
  List<Object?> get props => <Object?>[
    status,
    consumptionKw,
    sources,
    breakers,
    sourcesExpanded,
  ];
}
