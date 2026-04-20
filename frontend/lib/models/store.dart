import 'package:dart_mappable/dart_mappable.dart';
import 'package:grocery_management_frontend/models/address.dart';

part 'store.mapper.dart';

@MappableClass(caseStyle: CaseStyle.snakeCase)
class Store with StoreMappable {
  const Store({
    required this.id,
    required this.name,
    this.address,
    required this.tripCount,
    this.createdBy,
    this.updatedBy,
  });

  final int id;
  final String name;
  final Address? address;
  final int tripCount;
  final int? createdBy;
  final int? updatedBy;
}
