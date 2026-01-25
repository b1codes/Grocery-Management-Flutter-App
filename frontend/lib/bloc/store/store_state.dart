import 'package:grocery_management_frontend/models/store.dart';

enum StoreStatus { initial, loading, success, failure }

class StoreState {
  final List<Store> stores;
  final StoreStatus status;

  const StoreState({this.stores = const [], this.status = StoreStatus.initial});

  StoreState copyWith({List<Store>? stores, StoreStatus? status}) {
    return StoreState(
      stores: stores ?? this.stores,
      status: status ?? this.status,
    );
  }
}
