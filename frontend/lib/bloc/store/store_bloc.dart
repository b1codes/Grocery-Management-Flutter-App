import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_management_frontend/models/store.dart';
import 'package:grocery_management_frontend/services/managers/store_manager.dart';

import 'store_event.dart';
import 'store_state.dart';

export 'store_event.dart';
export 'store_state.dart';

class StoreBloc extends Bloc<StoreEvent, StoreState> {
  final StoreManager _storeManager;

  StoreBloc({required StoreManager storeManager})
    : _storeManager = storeManager,
      super(const StoreState()) {
    on<FetchStores>(_onFetchStores);
    on<AddStore>(_onAddStore);
  }

  void _onFetchStores(FetchStores event, Emitter<StoreState> emit) async {
    emit(state.copyWith(status: StoreStatus.loading));
    try {
      final stores = await _storeManager.getStores();
      emit(state.copyWith(status: StoreStatus.success, stores: stores));
    } catch (e) {
      emit(state.copyWith(status: StoreStatus.failure));
    }
  }

  void _onAddStore(AddStore event, Emitter<StoreState> emit) async {
    try {
      final newStore = await _storeManager.createStore(
        event.name,
        event.address,
        event.city,
        event.state,
        event.zipCode,
      );
      final updatedStores = List<Store>.from(state.stores)..add(newStore);
      emit(state.copyWith(status: StoreStatus.success, stores: updatedStores));
    } catch (e) {
      // Handle error, maybe emit a failure state
    }
  }
}
