// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'store.dart';

class StoreMapper extends ClassMapperBase<Store> {
  StoreMapper._();

  static StoreMapper? _instance;
  static StoreMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = StoreMapper._());
      AddressMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'Store';

  static int _$id(Store v) => v.id;
  static const Field<Store, int> _f$id = Field('id', _$id);
  static String _$name(Store v) => v.name;
  static const Field<Store, String> _f$name = Field('name', _$name);
  static Address? _$address(Store v) => v.address;
  static const Field<Store, Address> _f$address = Field(
    'address',
    _$address,
    opt: true,
  );
  static int _$tripCount(Store v) => v.tripCount;
  static const Field<Store, int> _f$tripCount = Field(
    'tripCount',
    _$tripCount,
    key: r'trip_count',
  );
  static int? _$createdBy(Store v) => v.createdBy;
  static const Field<Store, int> _f$createdBy = Field(
    'createdBy',
    _$createdBy,
    key: r'created_by',
    opt: true,
  );
  static int? _$updatedBy(Store v) => v.updatedBy;
  static const Field<Store, int> _f$updatedBy = Field(
    'updatedBy',
    _$updatedBy,
    key: r'updated_by',
    opt: true,
  );

  @override
  final MappableFields<Store> fields = const {
    #id: _f$id,
    #name: _f$name,
    #address: _f$address,
    #tripCount: _f$tripCount,
    #createdBy: _f$createdBy,
    #updatedBy: _f$updatedBy,
  };

  static Store _instantiate(DecodingData data) {
    return Store(
      id: data.dec(_f$id),
      name: data.dec(_f$name),
      address: data.dec(_f$address),
      tripCount: data.dec(_f$tripCount),
      createdBy: data.dec(_f$createdBy),
      updatedBy: data.dec(_f$updatedBy),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static Store fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Store>(map);
  }

  static Store fromJson(String json) {
    return ensureInitialized().decodeJson<Store>(json);
  }
}

mixin StoreMappable {
  String toJson() {
    return StoreMapper.ensureInitialized().encodeJson<Store>(this as Store);
  }

  Map<String, dynamic> toMap() {
    return StoreMapper.ensureInitialized().encodeMap<Store>(this as Store);
  }

  StoreCopyWith<Store, Store, Store> get copyWith =>
      _StoreCopyWithImpl<Store, Store>(this as Store, $identity, $identity);
  @override
  String toString() {
    return StoreMapper.ensureInitialized().stringifyValue(this as Store);
  }

  @override
  bool operator ==(Object other) {
    return StoreMapper.ensureInitialized().equalsValue(this as Store, other);
  }

  @override
  int get hashCode {
    return StoreMapper.ensureInitialized().hashValue(this as Store);
  }
}

extension StoreValueCopy<$R, $Out> on ObjectCopyWith<$R, Store, $Out> {
  StoreCopyWith<$R, Store, $Out> get $asStore =>
      $base.as((v, t, t2) => _StoreCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class StoreCopyWith<$R, $In extends Store, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  AddressCopyWith<$R, Address, Address>? get address;
  $R call({
    int? id,
    String? name,
    Address? address,
    int? tripCount,
    int? createdBy,
    int? updatedBy,
  });
  StoreCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _StoreCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, Store, $Out>
    implements StoreCopyWith<$R, Store, $Out> {
  _StoreCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Store> $mapper = StoreMapper.ensureInitialized();
  @override
  AddressCopyWith<$R, Address, Address>? get address =>
      $value.address?.copyWith.$chain((v) => call(address: v));
  @override
  $R call({
    int? id,
    String? name,
    Object? address = $none,
    int? tripCount,
    Object? createdBy = $none,
    Object? updatedBy = $none,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (name != null) #name: name,
      if (address != $none) #address: address,
      if (tripCount != null) #tripCount: tripCount,
      if (createdBy != $none) #createdBy: createdBy,
      if (updatedBy != $none) #updatedBy: updatedBy,
    }),
  );
  @override
  Store $make(CopyWithData data) => Store(
    id: data.get(#id, or: $value.id),
    name: data.get(#name, or: $value.name),
    address: data.get(#address, or: $value.address),
    tripCount: data.get(#tripCount, or: $value.tripCount),
    createdBy: data.get(#createdBy, or: $value.createdBy),
    updatedBy: data.get(#updatedBy, or: $value.updatedBy),
  );

  @override
  StoreCopyWith<$R2, Store, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _StoreCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

