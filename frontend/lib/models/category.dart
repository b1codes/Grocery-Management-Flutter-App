import 'package:dart_mappable/dart_mappable.dart';

part 'category.mapper.dart';

@MappableClass(caseStyle: CaseStyle.snakeCase)
class Category with CategoryMappable {
  const Category({
    required this.id,
    required this.name,
    this.description,
    this.createdBy,
    this.updatedBy,
  });

  final int id;
  final String name;
  final String? description;
  final int? createdBy;
  final int? updatedBy;
}
