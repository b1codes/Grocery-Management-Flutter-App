import 'package:dart_mappable/dart_mappable.dart';
import 'package:grocery_management_frontend/models/category.dart';

part 'category_dto.mapper.dart';

@MappableClass(caseStyle: CaseStyle.snakeCase)
class CategoryDto with CategoryDtoMappable {
  const CategoryDto({
    required this.id,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.name,
    this.description,
    this.createdBy,
    this.updatedBy,
  });

  final int id;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String name;
  final String? description;
  final int? createdBy;
  final int? updatedBy;

  Category toCategory() {
    return Category(
      id: id,
      name: name,
      description: description,
      createdBy: createdBy,
      updatedBy: updatedBy,
    );
  }

  static const fromMap = CategoryDtoMapper.fromMap;
  static const fromJson = CategoryDtoMapper.fromJson;
}
