import 'package:dart_mappable/dart_mappable.dart';

part 'pantry_item_dto.mapper.dart';

@MappableClass(caseStyle: CaseStyle.snakeCase)
class PantryItemDto with PantryItemDtoMappable {
  const PantryItemDto({
    required this.id,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    required this.name,
    this.category,
    required this.quantity,
    this.unit = 'count',
    this.minThreshold = 1.0,
    required this.regularPrice,
    required this.lastUpdated,
    this.upc,
    this.brand,
    this.imageUrl,
    this.createdBy,
    this.updatedBy,
  });

  final int id;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int user;
  final String name;
  final int? category;
  final double quantity;
  final String unit;
  final double minThreshold;
  final double regularPrice;
  final DateTime lastUpdated;
  final String? upc;
  final String? brand;
  final String? imageUrl;
  final int? createdBy;
  final int? updatedBy;

  static const fromMap = PantryItemDtoMapper.fromMap;
  static const fromJson = PantryItemDtoMapper.fromJson;
}
