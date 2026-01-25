import '../trip_event.dart';

class AddItemToTrip extends TripEvent {
  final int pantryItemId;
  final double price;

  AddItemToTrip({required this.pantryItemId, required this.price});
}
