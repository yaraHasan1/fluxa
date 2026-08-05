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
  });

  final SystemStatus status;

  /// Null until a reading exists.
  final double? consumptionKw;

  final List<EnergySource> sources;
  final List<CircuitBreaker> breakers;

  DashboardState copyWith({
    SystemStatus? status,
    double? consumptionKw,
    List<EnergySource>? sources,
    List<CircuitBreaker>? breakers,
  }) => DashboardState(
    status: status ?? this.status,
    consumptionKw: consumptionKw ?? this.consumptionKw,
    sources: sources ?? this.sources,
    breakers: breakers ?? this.breakers,
  );

  @override
  List<Object?> get props => <Object?>[
    status,
    consumptionKw,
    sources,
    breakers,
  ];
}
