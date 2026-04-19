import 'package:dart_mappable/dart_mappable.dart';

part 'insight.mapper.dart';

@MappableClass(caseStyle: CaseStyle.snakeCase)
class Insight with InsightMappable {
  const Insight({
    required this.original,
    required this.swap,
    required this.reason,
  });

  final String original;
  final String swap;
  final String reason;
}
