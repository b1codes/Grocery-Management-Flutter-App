// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'store_dto.dart';

class StoreDtoMapper extends ClassMapperBase<StoreDto> {
  StoreDtoMapper._();

  static StoreDtoMapper? _instance;
  static StoreDtoMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = StoreDtoMapper._());
      AddressDtoMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'StoreDto';

  static int _$id(StoreDto v) => v.id;
  static const Field<StoreDto, int> _f$id = Field('id', _$id);
  static String _$status(StoreDto v) => v.status;
  static const Field<StoreDto, String> _f$status = Field('status', _$status);
  static DateTime _$createdAt(StoreDto v) => v.createdAt;
  static const Field<StoreDto, DateTime> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
    key: r'created_at',
  );
  static DateTime _$updatedAt(StoreDto v) => v.updatedAt;
  static const Field<StoreDto, DateTime> _f$updatedAt = Field(
    'updatedAt',
    _$updatedAt,
    key: r'updated_at',
  );
  static int _$user(StoreDto v) => v.user;
  static const Field<StoreDto, int> _f$user = Field('user', _$user);
  static String _$name(StoreDto v) => v.name;
  static const Field<StoreDto, String> _f$name = Field('name', _$name);
  static AddressDto? _$address(StoreDto v) => v.address;
  static const Field<StoreDto, AddressDto> _f$address = Field(
    'address',
    _$address,
    opt: true,
  );
  static int _$tripCount(StoreDto v) => v.tripCount;
  static const Field<StoreDto, int> _f$tripCount = Field(
    'tripCount',
    _$tripCount,
    key: r'trip_count',
  );
  static int? _$createdBy(StoreDto v) => v.createdBy;
  static const Field<StoreDto, int> _f$createdBy = Field(
    'createdBy',
    _$createdBy,
    key: r'created_by',
    opt: true,
  );
  static int? _$updatedBy(StoreDto v) => v.updatedBy;
  static const Field<StoreDto, int> _f$updatedBy = Field(
    'updatedBy',
    _$updatedBy,
    key: r'updated_by',
    opt: true,
  );

  @override
  final MappableFields<StoreDto> fields = const {
    #id: _f$id,
    #status: _f$status,
    #createdAt: _f$createdAt,
    #updatedAt: _f$updatedAt,
    #user: _f$user,
    #name: _f$name,
    #address: _f$address,
    #tripCount: _f$tripCount,
    #createdBy: _f$createdBy,
    #updatedBy: _f$updatedBy,
  };

  static StoreDto _instantiate(DecodingData data) {
    return StoreDto(
      id: data.dec(_f$id),
      status: data.dec(_f$status),
      createdAt: data.dec(_f$createdAt),
      updatedAt: data.dec(_f$updatedAt),
      user: data.dec(_f$user),
      name: data.dec(_f$name),
      address: data.dec(_f$address),
      tripCount: data.dec(_f$tripCount),
      createdBy: data.dec(_f$createdBy),
      updatedBy: data.dec(_f$updatedBy),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static StoreDto fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<StoreDto>(map);
  }

  static StoreDto fromJson(String json) {
    return ensureInitialized().decodeJson<StoreDto>(json);
  }
}

mixin StoreDtoMappable {
  String toJson() {
    return StoreDtoMapper.ensureInitialized().encodeJson<StoreDto>(
      this as StoreDto,
    );
  }

  Map<String, dynamic> toMap() {
    return StoreDtoMapper.ensureInitialized().encodeMap<StoreDto>(
      this as StoreDto,
    );
  }

  StoreDtoCopyWith<StoreDto, StoreDto, StoreDto> get copyWith =>
      _StoreDtoCopyWithImpl<StoreDto, StoreDto>(
        this as StoreDto,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return StoreDtoMapper.ensureInitialized().stringifyValue(this as StoreDto);
  }

  @override
  bool operator ==(Object other) {
    return StoreDtoMapper.ensureInitialized().equalsValue(
      this as StoreDto,
      other,
    );
  }

  @override
  int get hashCode {
    return StoreDtoMapper.ensureInitialized().hashValue(this as StoreDto);
  }
}

extension StoreDtoValueCopy<$R, $Out> on ObjectCopyWith<$R, StoreDto, $Out> {
  StoreDtoCopyWith<$R, StoreDto, $Out> get $asStoreDto =>
      $base.as((v, t, t2) => _StoreDtoCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class StoreDtoCopyWith<$R, $In extends StoreDto, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  AddressDtoCopyWith<$R, AddressDto, AddressDto>? get address;
  $R call({
    int? id,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? user,
    String? name,
    AddressDto? address,
    int? tripCount,
    int? createdBy,
    int? updatedBy,
  });
  StoreDtoCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _StoreDtoCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, StoreDto, $Out>
    implements StoreDtoCopyWith<$R, StoreDto, $Out> {
  _StoreDtoCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<StoreDto> $mapper =
      StoreDtoMapper.ensureInitialized();
  @override
  AddressDtoCopyWith<$R, AddressDto, AddressDto>? get address =>
      $value.address?.copyWith.$chain((v) => call(address: v));
  @override
  $R call({
    int? id,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? user,
    String? name,
    Object? address = $none,
    int? tripCount,
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
      if (address != $none) #address: address,
      if (tripCount != null) #tripCount: tripCount,
      if (createdBy != $none) #createdBy: createdBy,
      if (updatedBy != $none) #updatedBy: updatedBy,
    }),
  );
  @override
  StoreDto $make(CopyWithData data) => StoreDto(
    id: data.get(#id, or: $value.id),
    status: data.get(#status, or: $value.status),
    createdAt: data.get(#createdAt, or: $value.createdAt),
    updatedAt: data.get(#updatedAt, or: $value.updatedAt),
    user: data.get(#user, or: $value.user),
    name: data.get(#name, or: $value.name),
    address: data.get(#address, or: $value.address),
    tripCount: data.get(#tripCount, or: $value.tripCount),
    createdBy: data.get(#createdBy, or: $value.createdBy),
    updatedBy: data.get(#updatedBy, or: $value.updatedBy),
  );

  @override
  StoreDtoCopyWith<$R2, StoreDto, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _StoreDtoCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

