part of 'portal_bloc.dart';

enum TabItem { dashboard, pantry, meals, stores, trips, budget, settings }

final class PortalState extends Equatable {
  final TabItem selectedTab;

  const PortalState({this.selectedTab = TabItem.dashboard});

  PortalState copyWith({TabItem? selectedTab}) {
    return PortalState(selectedTab: selectedTab ?? this.selectedTab);
  }

  @override
  List<Object> get props => [selectedTab];
}
