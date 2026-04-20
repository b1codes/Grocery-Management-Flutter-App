import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_management_frontend/models/purchased_item.dart';
import 'package:grocery_management_frontend/services/managers/trip_manager.dart';

import 'trip_event.dart';
import 'trip_state.dart';

export 'trip_event.dart';
export 'trip_state.dart';

class TripBloc extends Bloc<TripEvent, TripState> {
  final TripManager _tripManager;

  TripBloc({required TripManager tripManager})
    : _tripManager = tripManager,
      super(const TripState()) {
    on<StartTrip>(_onStartTrip);
    on<AddItemToTrip>(_onAddItemToTrip);
    on<FinishTrip>(_onFinishTrip);
    on<FetchTrips>(_onFetchTrips);
  }

  void _onStartTrip(StartTrip event, Emitter<TripState> emit) async {
    try {
      final trip = await _tripManager.startTrip(event.storeId);
      emit(state.copyWith(status: TripStatus.active, trip: trip));
    } catch (e) {
      emit(state.copyWith(status: TripStatus.error));
    }
  }

  void _onAddItemToTrip(AddItemToTrip event, Emitter<TripState> emit) async {
    if (state.trip == null) return;
    try {
      final newItem = await _tripManager.addItemToTrip(
        state.trip!.id,
        event.pantryItemId,
        event.price,
        quantity: event.quantity,
      );
      final updatedItems = List<PurchasedItem>.from(state.purchasedItems)
        ..add(newItem);
      emit(state.copyWith(purchasedItems: updatedItems));
    } catch (e) {
      // Handle error
    }
  }

  void _onFinishTrip(FinishTrip event, Emitter<TripState> emit) async {
    if (state.trip == null) return;
    try {
      await _tripManager.finishTrip(state.trip!.id);
      emit(state.copyWith(status: TripStatus.finished));
    } catch (e) {
      emit(state.copyWith(status: TripStatus.error));
    }
  }

  void _onFetchTrips(FetchTrips event, Emitter<TripState> emit) async {
    emit(
      state.copyWith(status: TripStatus.active),
    ); // Or loading status if desired
    try {
      final trips = await _tripManager.getTrips(completed: event.completed);
      emit(state.copyWith(trips: trips));
    } catch (e) {
      // Handle error if needed, but maybe don't change overall status if it interrupts active trip flow?
      // Assuming separate status might be better or just use 'error'
      emit(state.copyWith(status: TripStatus.error));
    }
  }
}
