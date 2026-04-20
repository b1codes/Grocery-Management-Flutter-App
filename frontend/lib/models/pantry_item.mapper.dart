// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'pantry_item.dart';

class PantryItemMapper extends ClassMapperBase<PantryItem> {
  PantryItemMapper._();

  static PantryItemMapper? _instance;
  static PantryItemMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PantryItemMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'PantryItem';

  static int _$id(PantryItem v) => v.id;
  static const Field<PantryItem, int> _f$id = Field('id', _$id);
  static String _$name(PantryItem v) => v.name;
  static const Field<PantryItem, String> _f$name = Field('name', _$name);
  static int? _$category(PantryItem v) => v.category;
  static const Field<PantryItem, int> _f$category = Field(
    'category',
    _$category,
    opt: true,
  );
  static int _$quantity(PantryItem v) => v.quantity;
  static const Field<PantryItem, int> _f$quantity = Field(
    'quantity',
    _$quantity,
  );
  static int _$minThreshold(PantryItem v) => v.minThreshold;
  static const Field<PantryItem, int> _f$minThreshold = Field(
    'minThreshold',
    _$minThreshold,
    key: r'min_threshold',
    opt: true,
    def: 1,
  );
  static double _$regularPrice(PantryItem v) => v.regularPrice;
  static const Field<PantryItem, double> _f$regularPrice = Field(
    'regularPrice',
    _$regularPrice,
    key: r'regular_price',
  );
  static DateTime _$lastUpdated(PantryItem v) => v.lastUpdated;
  static const Field<PantryItem, DateTime> _f$lastUpdated = Field(
    'lastUpdated',
    _$lastUpdated,
    key: r'last_updated',
  );
  static String? _$upc(PantryItem v) => v.upc;
  static const Field<PantryItem, String> _f$upc = Field(
    'upc',
    _$upc,
    opt: true,
  );
  static String? _$brand(PantryItem v) => v.brand;
  static const Field<PantryItem, String> _f$brand = Field(
    'brand',
    _$brand,
    opt: true,
  );
  static String? _$imageUrl(PantryItem v) => v.imageUrl;
  static const Field<PantryItem, String> _f$imageUrl = Field(
    'imageUrl',
    _$imageUrl,
    key: r'image_url',
    opt: true,
  );
  static int? _$createdBy(PantryItem v) => v.createdBy;
  static const Field<PantryItem, int> _f$createdBy = Field(
    'createdBy',
    _$createdBy,
    key: r'created_by',
    opt: true,
  );
  static int? _$updatedBy(PantryItem v) => v.updatedBy;
  static const Field<PantryItem, int> _f$updatedBy = Field(
    'updatedBy',
    _$updatedBy,
    key: r'updated_by',
    opt: true,
  );

  @override
  final MappableFields<PantryItem> fields = const {
    #id: _f$id,
    #name: _f$name,
    #category: _f$category,
    #quantity: _f$quantity,
    #minThreshold: _f$minThreshold,
    #regularPrice: _f$regularPrice,
    #lastUpdated: _f$lastUpdated,
    #upc: _f$upc,
    #brand: _f$brand,
    #imageUrl: _f$imageUrl,
    #createdBy: _f$createdBy,
    #updatedBy: _f$updatedBy,
  };

  static PantryItem _instantiate(DecodingData data) {
    return PantryItem(
      id: data.dec(_f$id),
      name: data.dec(_f$name),
      category: data.dec(_f$category),
      quantity: data.dec(_f$quantity),
      minThreshold: data.dec(_f$minThreshold),
      regularPrice: data.dec(_f$regularPrice),
      lastUpdated: data.dec(_f$lastUpdated),
      upc: data.dec(_f$upc),
      brand: data.dec(_f$brand),
      imageUrl: data.dec(_f$imageUrl),
      createdBy: data.dec(_f$createdBy),
      updatedBy: data.dec(_f$updatedBy),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static PantryItem fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PantryItem>(map);
  }

  static PantryItem fromJson(String json) {
    return ensureInitialized().decodeJson<PantryItem>(json);
  }
}

mixin PantryItemMappable {
  String toJson() {
    return PantryItemMapper.ensureInitialized().encodeJson<PantryItem>(
      this as PantryItem,
    );
  }

  Map<String, dynamic> toMap() {
    return PantryItemMapper.ensureInitialized().encodeMap<PantryItem>(
      this as PantryItem,
    );
  }

  PantryItemCopyWith<PantryItem, PantryItem, PantryItem> get copyWith =>
      _PantryItemCopyWithImpl<PantryItem, PantryItem>(
        this as PantryItem,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return PantryItemMapper.ensureInitialized().stringifyValue(
      this as PantryItem,
    );
  }

  @override
  bool operator ==(Object other) {
    return PantryItemMapper.ensureInitialized().equalsValue(
      this as PantryItem,
      other,
    );
  }

  @override
  int get hashCode {
    return PantryItemMapper.ensureInitialized().hashValue(this as PantryItem);
  }
}

extension PantryItemValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PantryItem, $Out> {
  PantryItemCopyWith<$R, PantryItem, $Out> get $asPantryItem =>
      $base.as((v, t, t2) => _PantryItemCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class PantryItemCopyWith<$R, $In extends PantryItem, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    int? id,
    String? name,
    int? category,
    int? quantity,
    int? minThreshold,
    double? regularPrice,
    DateTime? lastUpdated,
    String? upc,
    String? brand,
    String? imageUrl,
    int? createdBy,
    int? updatedBy,
  });
  PantryItemCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _PantryItemCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PantryItem, $Out>
    implements PantryItemCopyWith<$R, PantryItem, $Out> {
  _PantryItemCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<PantryItem> $mapper =
      PantryItemMapper.ensureInitialized();
  @override
  $R call({
    int? id,
    String? name,
    Object? category = $none,
    int? quantity,
    int? minThreshold,
    double? regularPrice,
    DateTime? lastUpdated,
    Object? upc = $none,
    Object? brand = $none,
    Object? imageUrl = $none,
    Object? createdBy = $none,
    Object? updatedBy = $none,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (name != null) #name: name,
      if (category != $none) #category: category,
      if (quantity != null) #quantity: quantity,
      if (minThreshold != null) #minThreshold: minThreshold,
      if (regularPrice != null) #regularPrice: regularPrice,
      if (lastUpdated != null) #lastUpdated: lastUpdated,
      if (upc != $none) #upc: upc,
      if (brand != $none) #brand: brand,
      if (imageUrl != $none) #imageUrl: imageUrl,
      if (createdBy != $none) #createdBy: createdBy,
      if (updatedBy != $none) #updatedBy: updatedBy,
    }),
  );
  @override
  PantryItem $make(CopyWithData data) => PantryItem(
    id: data.get(#id, or: $value.id),
    name: data.get(#name, or: $value.name),
    category: data.get(#category, or: $value.category),
    quantity: data.get(#quantity, or: $value.quantity),
    minThreshold: data.get(#minThreshold, or: $value.minThreshold),
    regularPrice: data.get(#regularPrice, or: $value.regularPrice),
    lastUpdated: data.get(#lastUpdated, or: $value.lastUpdated),
    upc: data.get(#upc, or: $value.upc),
    brand: data.get(#brand, or: $value.brand),
    imageUrl: data.get(#imageUrl, or: $value.imageUrl),
    createdBy: data.get(#createdBy, or: $value.createdBy),
    updatedBy: data.get(#updatedBy, or: $value.updatedBy),
  );

  @override
  PantryItemCopyWith<$R2, PantryItem, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _PantryItemCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

