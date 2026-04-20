import 'package:grocery_management_frontend/models/store.dart';
import 'package:grocery_management_frontend/networking/api/store_api.dart';
import 'package:grocery_management_frontend/networking/dto/store_dto.dart';

class StoreManager {
  final StoreApi _storeApi;

  StoreManager({StoreApi? storeApi}) : _storeApi = storeApi ?? StoreApi();

  Future<List<Store>> getStores() async {
    final response = await _storeApi.getStores();
    final storeDtos = (response.data as List)
        .map((e) => StoreDto.fromMap(e))
        .toList();
    return storeDtos.map((dto) => dto.toStore()).toList();
  }

  Future<Store> createStore(
    String name,
    String address,
    String city,
    String state,
    String zipCode,
  ) async {
    final response = await _storeApi.createStore(
      name,
      address,
      city,
      state,
      zipCode,
    );
    final storeDto = StoreDto.fromMap(response.data);
    return storeDto.toStore();
  }
}

extension on StoreDto {
  Store toStore() {
    return Store(
      id: id,
      name: name,
      address: address?.toAddress(),
      tripCount: tripCount,
      createdBy: createdBy,
      updatedBy: updatedBy,
    );
  }
}
