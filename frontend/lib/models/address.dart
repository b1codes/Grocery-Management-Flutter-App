import 'package:dart_mappable/dart_mappable.dart';

part 'address.mapper.dart';

@MappableClass(caseStyle: CaseStyle.snakeCase)
class Address with AddressMappable {
  const Address({
    required this.id,
    required this.addressLine,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
    this.createdBy,
    this.updatedBy,
  });

  final int id;
  final String addressLine;
  final String city;
  final String state;
  final String zipCode;
  final String country;
  final int? createdBy;
  final int? updatedBy;
}
