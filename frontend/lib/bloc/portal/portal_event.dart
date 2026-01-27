part of 'portal_bloc.dart';

sealed class PortalEvent extends Equatable {
  const PortalEvent();

  @override
  List<Object> get props => [];
}

final class SelectTab extends PortalEvent {
  final TabItem tabItem;

  const SelectTab(this.tabItem);

  @override
  List<Object> get props => [tabItem];
}
