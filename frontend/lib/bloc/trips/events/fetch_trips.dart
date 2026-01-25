import '../trip_event.dart';

class FetchTrips extends TripEvent {
  final bool? completed;

  FetchTrips({this.completed});
}
