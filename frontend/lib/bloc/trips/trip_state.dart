import 'package:grocery_management_frontend/models/grocery_trip.dart';
import 'package:grocery_management_frontend/models/purchased_item.dart';

enum TripStatus { initial, active, finished, error }

class TripState {
  final TripStatus status;
  final GroceryTrip? trip;
  final List<PurchasedItem> purchasedItems;
  final List<GroceryTrip> trips;

  const TripState({
    this.status = TripStatus.initial,
    this.trip,
    this.purchasedItems = const [],
    this.trips = const [],
  });

  TripState copyWith({
    TripStatus? status,
    GroceryTrip? trip,
    List<PurchasedItem>? purchasedItems,
    List<GroceryTrip>? trips,
  }) {
    return TripState(
      status: status ?? this.status,
      trip: trip ?? this.trip,
      purchasedItems: purchasedItems ?? this.purchasedItems,
      trips: trips ?? this.trips,
    );
  }
}
