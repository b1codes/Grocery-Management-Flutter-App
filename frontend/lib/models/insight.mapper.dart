// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'insight.dart';

class InsightMapper extends ClassMapperBase<Insight> {
  InsightMapper._();

  static InsightMapper? _instance;
  static InsightMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = InsightMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'Insight';

  static String _$original(Insight v) => v.original;
  static const Field<Insight, String> _f$original = Field(
    'original',
    _$original,
  );
  static String _$swap(Insight v) => v.swap;
  static const Field<Insight, String> _f$swap = Field('swap', _$swap);
  static String _$reason(Insight v) => v.reason;
  static const Field<Insight, String> _f$reason = Field('reason', _$reason);

  @override
  final MappableFields<Insight> fields = const {
    #original: _f$original,
    #swap: _f$swap,
    #reason: _f$reason,
  };

  static Insight _instantiate(DecodingData data) {
    return Insight(
      original: data.dec(_f$original),
      swap: data.dec(_f$swap),
      reason: data.dec(_f$reason),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static Insight fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Insight>(map);
  }

  static Insight fromJson(String json) {
    return ensureInitialized().decodeJson<Insight>(json);
  }
}

mixin InsightMappable {
  String toJson() {
    return InsightMapper.ensureInitialized().encodeJson<Insight>(
      this as Insight,
    );
  }

  Map<String, dynamic> toMap() {
    return InsightMapper.ensureInitialized().encodeMap<Insight>(
      this as Insight,
    );
  }

  InsightCopyWith<Insight, Insight, Insight> get copyWith =>
      _InsightCopyWithImpl<Insight, Insight>(
        this as Insight,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return InsightMapper.ensureInitialized().stringifyValue(this as Insight);
  }

  @override
  bool operator ==(Object other) {
    return InsightMapper.ensureInitialized().equalsValue(
      this as Insight,
      other,
    );
  }

  @override
  int get hashCode {
    return InsightMapper.ensureInitialized().hashValue(this as Insight);
  }
}

extension InsightValueCopy<$R, $Out> on ObjectCopyWith<$R, Insight, $Out> {
  InsightCopyWith<$R, Insight, $Out> get $asInsight =>
      $base.as((v, t, t2) => _InsightCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class InsightCopyWith<$R, $In extends Insight, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? original, String? swap, String? reason});
  InsightCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _InsightCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, Insight, $Out>
    implements InsightCopyWith<$R, Insight, $Out> {
  _InsightCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Insight> $mapper =
      InsightMapper.ensureInitialized();
  @override
  $R call({String? original, String? swap, String? reason}) => $apply(
    FieldCopyWithData({
      if (original != null) #original: original,
      if (swap != null) #swap: swap,
      if (reason != null) #reason: reason,
    }),
  );
  @override
  Insight $make(CopyWithData data) => Insight(
    original: data.get(#original, or: $value.original),
    swap: data.get(#swap, or: $value.swap),
    reason: data.get(#reason, or: $value.reason),
  );

  @override
  InsightCopyWith<$R2, Insight, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _InsightCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

