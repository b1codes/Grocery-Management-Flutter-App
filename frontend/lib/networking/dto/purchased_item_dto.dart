import 'package:dart_mappable/dart_mappable.dart';

part 'purchased_item_dto.mapper.dart';

@MappableClass(caseStyle: CaseStyle.snakeCase)
class PurchasedItemDto with PurchasedItemDtoMappable {
  const PurchasedItemDto({
    required this.id,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.trip,
    required this.pantryItem,
    required this.purchasePrice,
    required this.quantityBought,
    this.createdBy,
    this.updatedBy,
  });

  final int id;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int trip;
  final int pantryItem;
  final double purchasePrice;
  final double quantityBought;
  final int? createdBy;
  final int? updatedBy;

  static const fromMap = PurchasedItemDtoMapper.fromMap;
  static const fromJson = PurchasedItemDtoMapper.fromJson;
}
