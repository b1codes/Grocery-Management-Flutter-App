import 'package:dart_mappable/dart_mappable.dart';
import 'package:grocery_management_frontend/networking/dto/address_dto.dart';

part 'store_dto.mapper.dart';

@MappableClass(caseStyle: CaseStyle.snakeCase)
class StoreDto with StoreDtoMappable {
  const StoreDto({
    required this.id,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    required this.name,
    this.address,
    required this.tripCount,
    this.createdBy,
    this.updatedBy,
  });

  final int id;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int user;
  final String name;
  final AddressDto? address;
  final int tripCount;
  final int? createdBy;
  final int? updatedBy;

  static const fromMap = StoreDtoMapper.fromMap;
  static const fromJson = StoreDtoMapper.fromJson;
}
