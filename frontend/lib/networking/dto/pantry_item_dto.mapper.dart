// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'pantry_item_dto.dart';

class PantryItemDtoMapper extends ClassMapperBase<PantryItemDto> {
  PantryItemDtoMapper._();

  static PantryItemDtoMapper? _instance;
  static PantryItemDtoMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PantryItemDtoMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'PantryItemDto';

  static int _$id(PantryItemDto v) => v.id;
  static const Field<PantryItemDto, int> _f$id = Field('id', _$id);
  static String _$status(PantryItemDto v) => v.status;
  static const Field<PantryItemDto, String> _f$status = Field(
    'status',
    _$status,
  );
  static DateTime _$createdAt(PantryItemDto v) => v.createdAt;
  static const Field<PantryItemDto, DateTime> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
    key: r'created_at',
  );
  static DateTime _$updatedAt(PantryItemDto v) => v.updatedAt;
  static const Field<PantryItemDto, DateTime> _f$updatedAt = Field(
    'updatedAt',
    _$updatedAt,
    key: r'updated_at',
  );
  static int _$user(PantryItemDto v) => v.user;
  static const Field<PantryItemDto, int> _f$user = Field('user', _$user);
  static String _$name(PantryItemDto v) => v.name;
  static const Field<PantryItemDto, String> _f$name = Field('name', _$name);
  static int? _$category(PantryItemDto v) => v.category;
  static const Field<PantryItemDto, int> _f$category = Field(
    'category',
    _$category,
    opt: true,
  );
  static int _$quantity(PantryItemDto v) => v.quantity;
  static const Field<PantryItemDto, int> _f$quantity = Field(
    'quantity',
    _$quantity,
  );
  static int _$minThreshold(PantryItemDto v) => v.minThreshold;
  static const Field<PantryItemDto, int> _f$minThreshold = Field(
    'minThreshold',
    _$minThreshold,
    key: r'min_threshold',
    opt: true,
    def: 1,
  );
  static double _$regularPrice(PantryItemDto v) => v.regularPrice;
  static const Field<PantryItemDto, double> _f$regularPrice = Field(
    'regularPrice',
    _$regularPrice,
    key: r'regular_price',
  );
  static DateTime _$lastUpdated(PantryItemDto v) => v.lastUpdated;
  static const Field<PantryItemDto, DateTime> _f$lastUpdated = Field(
    'lastUpdated',
    _$lastUpdated,
    key: r'last_updated',
  );
  static String? _$upc(PantryItemDto v) => v.upc;
  static const Field<PantryItemDto, String> _f$upc = Field(
    'upc',
    _$upc,
    opt: true,
  );
  static String? _$brand(PantryItemDto v) => v.brand;
  static const Field<PantryItemDto, String> _f$brand = Field(
    'brand',
    _$brand,
    opt: true,
  );
  static String? _$imageUrl(PantryItemDto v) => v.imageUrl;
  static const Field<PantryItemDto, String> _f$imageUrl = Field(
    'imageUrl',
    _$imageUrl,
    key: r'image_url',
    opt: true,
  );
  static int? _$createdBy(PantryItemDto v) => v.createdBy;
  static const Field<PantryItemDto, int> _f$createdBy = Field(
    'createdBy',
    _$createdBy,
    key: r'created_by',
    opt: true,
  );
  static int? _$updatedBy(PantryItemDto v) => v.updatedBy;
  static const Field<PantryItemDto, int> _f$updatedBy = Field(
    'updatedBy',
    _$updatedBy,
    key: r'updated_by',
    opt: true,
  );

  @override
  final MappableFields<PantryItemDto> fields = const {
    #id: _f$id,
    #status: _f$status,
    #createdAt: _f$createdAt,
    #updatedAt: _f$updatedAt,
    #user: _f$user,
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

  static PantryItemDto _instantiate(DecodingData data) {
    return PantryItemDto(
      id: data.dec(_f$id),
      status: data.dec(_f$status),
      createdAt: data.dec(_f$createdAt),
      updatedAt: data.dec(_f$updatedAt),
      user: data.dec(_f$user),
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

  static PantryItemDto fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PantryItemDto>(map);
  }

  static PantryItemDto fromJson(String json) {
    return ensureInitialized().decodeJson<PantryItemDto>(json);
  }
}

mixin PantryItemDtoMappable {
  String toJson() {
    return PantryItemDtoMapper.ensureInitialized().encodeJson<PantryItemDto>(
      this as PantryItemDto,
    );
  }

  Map<String, dynamic> toMap() {
    return PantryItemDtoMapper.ensureInitialized().encodeMap<PantryItemDto>(
      this as PantryItemDto,
    );
  }

  PantryItemDtoCopyWith<PantryItemDto, PantryItemDto, PantryItemDto>
  get copyWith => _PantryItemDtoCopyWithImpl<PantryItemDto, PantryItemDto>(
    this as PantryItemDto,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return PantryItemDtoMapper.ensureInitialized().stringifyValue(
      this as PantryItemDto,
    );
  }

  @override
  bool operator ==(Object other) {
    return PantryItemDtoMapper.ensureInitialized().equalsValue(
      this as PantryItemDto,
      other,
    );
  }

  @override
  int get hashCode {
    return PantryItemDtoMapper.ensureInitialized().hashValue(
      this as PantryItemDto,
    );
  }
}

extension PantryItemDtoValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PantryItemDto, $Out> {
  PantryItemDtoCopyWith<$R, PantryItemDto, $Out> get $asPantryItemDto =>
      $base.as((v, t, t2) => _PantryItemDtoCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class PantryItemDtoCopyWith<$R, $In extends PantryItemDto, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    int? id,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? user,
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
  PantryItemDtoCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _PantryItemDtoCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PantryItemDto, $Out>
    implements PantryItemDtoCopyWith<$R, PantryItemDto, $Out> {
  _PantryItemDtoCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<PantryItemDto> $mapper =
      PantryItemDtoMapper.ensureInitialized();
  @override
  $R call({
    int? id,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? user,
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
      if (status != null) #status: status,
      if (createdAt != null) #createdAt: createdAt,
      if (updatedAt != null) #updatedAt: updatedAt,
      if (user != null) #user: user,
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
  PantryItemDto $make(CopyWithData data) => PantryItemDto(
    id: data.get(#id, or: $value.id),
    status: data.get(#status, or: $value.status),
    createdAt: data.get(#createdAt, or: $value.createdAt),
    updatedAt: data.get(#updatedAt, or: $value.updatedAt),
    user: data.get(#user, or: $value.user),
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
  PantryItemDtoCopyWith<$R2, PantryItemDto, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _PantryItemDtoCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

