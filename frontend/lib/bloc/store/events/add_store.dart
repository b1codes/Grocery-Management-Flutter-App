import '../store_event.dart';

class AddStore extends StoreEvent {
  final String name;
  final String address;
  final String city;
  final String state;
  final String zipCode;

  AddStore({
    required this.name,
    required this.address,
    required this.city,
    required this.state,
    required this.zipCode,
  });
}
