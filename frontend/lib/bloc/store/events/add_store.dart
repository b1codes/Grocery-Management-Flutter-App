import '../store_event.dart';

class AddStore extends StoreEvent {
  final String name;
  final String address;

  AddStore({required this.name, required this.address});
}
