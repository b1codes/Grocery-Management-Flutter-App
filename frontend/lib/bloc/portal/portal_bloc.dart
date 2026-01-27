import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'portal_event.dart';
part 'portal_state.dart';

class PortalBloc extends Bloc<PortalEvent, PortalState> {
  PortalBloc() : super(const PortalState()) {
    on<SelectTab>((event, emit) {
      emit(state.copyWith(selectedTab: event.tabItem));
    });
  }
}
