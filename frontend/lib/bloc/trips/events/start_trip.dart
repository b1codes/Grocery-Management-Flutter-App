import '../trip_event.dart';

class StartTrip extends TripEvent {
  final int storeId;

  StartTrip({required this.storeId});
}
