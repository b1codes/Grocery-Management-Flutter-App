// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'purchased_item_dto.dart';

class PurchasedItemDtoMapper extends ClassMapperBase<PurchasedItemDto> {
  PurchasedItemDtoMapper._();

  static PurchasedItemDtoMapper? _instance;
  static PurchasedItemDtoMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PurchasedItemDtoMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'PurchasedItemDto';

  static int _$id(PurchasedItemDto v) => v.id;
  static const Field<PurchasedItemDto, int> _f$id = Field('id', _$id);
  static String _$status(PurchasedItemDto v) => v.status;
  static const Field<PurchasedItemDto, String> _f$status = Field(
    'status',
    _$status,
  );
  static DateTime _$createdAt(PurchasedItemDto v) => v.createdAt;
  static const Field<PurchasedItemDto, DateTime> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
    key: r'created_at',
  );
  static DateTime _$updatedAt(PurchasedItemDto v) => v.updatedAt;
  static const Field<PurchasedItemDto, DateTime> _f$updatedAt = Field(
    'updatedAt',
    _$updatedAt,
    key: r'updated_at',
  );
  static int _$trip(PurchasedItemDto v) => v.trip;
  static const Field<PurchasedItemDto, int> _f$trip = Field('trip', _$trip);
  static int _$pantryItem(PurchasedItemDto v) => v.pantryItem;
  static const Field<PurchasedItemDto, int> _f$pantryItem = Field(
    'pantryItem',
    _$pantryItem,
    key: r'pantry_item',
  );
  static double _$purchasePrice(PurchasedItemDto v) => v.purchasePrice;
  static const Field<PurchasedItemDto, double> _f$purchasePrice = Field(
    'purchasePrice',
    _$purchasePrice,
    key: r'purchase_price',
  );
  static double _$quantityBought(PurchasedItemDto v) => v.quantityBought;
  static const Field<PurchasedItemDto, double> _f$quantityBought = Field(
    'quantityBought',
    _$quantityBought,
    key: r'quantity_bought',
  );
  static int? _$createdBy(PurchasedItemDto v) => v.createdBy;
  static const Field<PurchasedItemDto, int> _f$createdBy = Field(
    'createdBy',
    _$createdBy,
    key: r'created_by',
    opt: true,
  );
  static int? _$updatedBy(PurchasedItemDto v) => v.updatedBy;
  static const Field<PurchasedItemDto, int> _f$updatedBy = Field(
    'updatedBy',
    _$updatedBy,
    key: r'updated_by',
    opt: true,
  );

  @override
  final MappableFields<PurchasedItemDto> fields = const {
    #id: _f$id,
    #status: _f$status,
    #createdAt: _f$createdAt,
    #updatedAt: _f$updatedAt,
    #trip: _f$trip,
    #pantryItem: _f$pantryItem,
    #purchasePrice: _f$purchasePrice,
    #quantityBought: _f$quantityBought,
    #createdBy: _f$createdBy,
    #updatedBy: _f$updatedBy,
  };

  static PurchasedItemDto _instantiate(DecodingData data) {
    return PurchasedItemDto(
      id: data.dec(_f$id),
      status: data.dec(_f$status),
      createdAt: data.dec(_f$createdAt),
      updatedAt: data.dec(_f$updatedAt),
      trip: data.dec(_f$trip),
      pantryItem: data.dec(_f$pantryItem),
      purchasePrice: data.dec(_f$purchasePrice),
      quantityBought: data.dec(_f$quantityBought),
      createdBy: data.dec(_f$createdBy),
      updatedBy: data.dec(_f$updatedBy),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static PurchasedItemDto fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PurchasedItemDto>(map);
  }

  static PurchasedItemDto fromJson(String json) {
    return ensureInitialized().decodeJson<PurchasedItemDto>(json);
  }
}

mixin PurchasedItemDtoMappable {
  String toJson() {
    return PurchasedItemDtoMapper.ensureInitialized()
        .encodeJson<PurchasedItemDto>(this as PurchasedItemDto);
  }

  Map<String, dynamic> toMap() {
    return PurchasedItemDtoMapper.ensureInitialized()
        .encodeMap<PurchasedItemDto>(this as PurchasedItemDto);
  }

  PurchasedItemDtoCopyWith<PurchasedItemDto, PurchasedItemDto, PurchasedItemDto>
  get copyWith =>
      _PurchasedItemDtoCopyWithImpl<PurchasedItemDto, PurchasedItemDto>(
        this as PurchasedItemDto,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return PurchasedItemDtoMapper.ensureInitialized().stringifyValue(
      this as PurchasedItemDto,
    );
  }

  @override
  bool operator ==(Object other) {
    return PurchasedItemDtoMapper.ensureInitialized().equalsValue(
      this as PurchasedItemDto,
      other,
    );
  }

  @override
  int get hashCode {
    return PurchasedItemDtoMapper.ensureInitialized().hashValue(
      this as PurchasedItemDto,
    );
  }
}

extension PurchasedItemDtoValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PurchasedItemDto, $Out> {
  PurchasedItemDtoCopyWith<$R, PurchasedItemDto, $Out>
  get $asPurchasedItemDto =>
      $base.as((v, t, t2) => _PurchasedItemDtoCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class PurchasedItemDtoCopyWith<$R, $In extends PurchasedItemDto, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    int? id,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? trip,
    int? pantryItem,
    double? purchasePrice,
    double? quantityBought,
    int? createdBy,
    int? updatedBy,
  });
  PurchasedItemDtoCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _PurchasedItemDtoCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PurchasedItemDto, $Out>
    implements PurchasedItemDtoCopyWith<$R, PurchasedItemDto, $Out> {
  _PurchasedItemDtoCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<PurchasedItemDto> $mapper =
      PurchasedItemDtoMapper.ensureInitialized();
  @override
  $R call({
    int? id,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? trip,
    int? pantryItem,
    double? purchasePrice,
    double? quantityBought,
    Object? createdBy = $none,
    Object? updatedBy = $none,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (status != null) #status: status,
      if (createdAt != null) #createdAt: createdAt,
      if (updatedAt != null) #updatedAt: updatedAt,
      if (trip != null) #trip: trip,
      if (pantryItem != null) #pantryItem: pantryItem,
      if (purchasePrice != null) #purchasePrice: purchasePrice,
      if (quantityBought != null) #quantityBought: quantityBought,
      if (createdBy != $none) #createdBy: createdBy,
      if (updatedBy != $none) #updatedBy: updatedBy,
    }),
  );
  @override
  PurchasedItemDto $make(CopyWithData data) => PurchasedItemDto(
    id: data.get(#id, or: $value.id),
    status: data.get(#status, or: $value.status),
    createdAt: data.get(#createdAt, or: $value.createdAt),
    updatedAt: data.get(#updatedAt, or: $value.updatedAt),
    trip: data.get(#trip, or: $value.trip),
    pantryItem: data.get(#pantryItem, or: $value.pantryItem),
    purchasePrice: data.get(#purchasePrice, or: $value.purchasePrice),
    quantityBought: data.get(#quantityBought, or: $value.quantityBought),
    createdBy: data.get(#createdBy, or: $value.createdBy),
    updatedBy: data.get(#updatedBy, or: $value.updatedBy),
  );

  @override
  PurchasedItemDtoCopyWith<$R2, PurchasedItemDto, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _PurchasedItemDtoCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

