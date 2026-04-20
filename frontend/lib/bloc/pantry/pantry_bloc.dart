import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_management_frontend/models/pantry_item.dart';
import 'package:grocery_management_frontend/models/category.dart';
import 'package:grocery_management_frontend/services/managers/pantry_manager.dart';

import 'pantry_event.dart';
import 'pantry_state.dart';

export 'pantry_event.dart';
export 'pantry_state.dart';

class PantryBloc extends Bloc<PantryEvent, PantryState> {
  final PantryManager _pantryManager;

  PantryBloc({required PantryManager pantryManager})
    : _pantryManager = pantryManager,
      super(const PantryState()) {
    on<FetchPantryItems>(_onFetchPantryItems);
    on<FetchCategories>(_onFetchCategories);
    on<AddPantryItem>(_onAddPantryItem);
    on<UpdatePantryItem>(_onUpdatePantryItem);
    on<DeletePantryItem>(_onDeletePantryItem);
    on<SetCategoryFilter>(_onSetCategoryFilter);
  }

  void _onFetchPantryItems(
    FetchPantryItems event,
    Emitter<PantryState> emit,
  ) async {
    emit(state.copyWith(status: PantryStatus.loading));
    try {
      final itemsFuture = _pantryManager.getPantryItems();
      final categoriesFuture = _pantryManager.getCategories();
      
      final results = await Future.wait([itemsFuture, categoriesFuture]);
      
      emit(state.copyWith(
        status: PantryStatus.success,
        items: results[0] as List<PantryItem>,
        categories: results[1] as List<Category>,
      ));
    } catch (e) {
      emit(state.copyWith(status: PantryStatus.failure));
    }
  }

  void _onFetchCategories(
    FetchCategories event,
    Emitter<PantryState> emit,
  ) async {
    try {
      final categories = await _pantryManager.getCategories();
      emit(state.copyWith(categories: categories));
    } catch (e) {
      // Handle error
    }
  }

  void _onSetCategoryFilter(
    SetCategoryFilter event,
    Emitter<PantryState> emit,
  ) {
    emit(state.copyWith(
      selectedCategoryId: event.categoryId,
      clearCategoryFilter: event.categoryId == null,
    ));
  }

  void _onAddPantryItem(AddPantryItem event, Emitter<PantryState> emit) async {
    try {
      final newItem = await _pantryManager.createPantryItem(
        event.name,
        event.quantity,
        event.categoryId,
      );
      final updatedItems = List<PantryItem>.from(state.items)..add(newItem);
      emit(state.copyWith(status: PantryStatus.success, items: updatedItems));
    } catch (e) {
      // Handle error
    }
  }

  void _onUpdatePantryItem(
    UpdatePantryItem event,
    Emitter<PantryState> emit,
  ) async {
    try {
      final updatedItem = await _pantryManager.updatePantryItemQuantity(
        event.id,
        event.quantity,
      );
      final newItems = state.items.map((item) {
        return item.id == updatedItem.id ? updatedItem : item;
      }).toList();
      emit(state.copyWith(items: newItems));
    } catch (e) {
      // Handle error
    }
  }

  void _onDeletePantryItem(
    DeletePantryItem event,
    Emitter<PantryState> emit,
  ) async {
    try {
      await _pantryManager.deletePantryItem(event.id);
      final updatedItems = state.items
          .where((item) => item.id != event.id)
          .toList();
      emit(state.copyWith(items: updatedItems, status: PantryStatus.success));
    } catch (e) {
      // Handle error
    }
  }
}
