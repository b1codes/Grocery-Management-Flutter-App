import '../trip_event.dart';

class AddItemToTrip extends TripEvent {
  final int pantryItemId;
  final double price;
  final double quantity;

  AddItemToTrip({
    required this.pantryItemId,
    required this.price,
    this.quantity = 1.0,
  });
}
