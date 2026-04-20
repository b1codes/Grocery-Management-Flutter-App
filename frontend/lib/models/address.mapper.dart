// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'address.dart';

class AddressMapper extends ClassMapperBase<Address> {
  AddressMapper._();

  static AddressMapper? _instance;
  static AddressMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AddressMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'Address';

  static int _$id(Address v) => v.id;
  static const Field<Address, int> _f$id = Field('id', _$id);
  static String _$addressLine(Address v) => v.addressLine;
  static const Field<Address, String> _f$addressLine = Field(
    'addressLine',
    _$addressLine,
    key: r'address_line',
  );
  static String _$city(Address v) => v.city;
  static const Field<Address, String> _f$city = Field('city', _$city);
  static String _$state(Address v) => v.state;
  static const Field<Address, String> _f$state = Field('state', _$state);
  static String _$zipCode(Address v) => v.zipCode;
  static const Field<Address, String> _f$zipCode = Field(
    'zipCode',
    _$zipCode,
    key: r'zip_code',
  );
  static String _$country(Address v) => v.country;
  static const Field<Address, String> _f$country = Field('country', _$country);
  static int? _$createdBy(Address v) => v.createdBy;
  static const Field<Address, int> _f$createdBy = Field(
    'createdBy',
    _$createdBy,
    key: r'created_by',
    opt: true,
  );
  static int? _$updatedBy(Address v) => v.updatedBy;
  static const Field<Address, int> _f$updatedBy = Field(
    'updatedBy',
    _$updatedBy,
    key: r'updated_by',
    opt: true,
  );

  @override
  final MappableFields<Address> fields = const {
    #id: _f$id,
    #addressLine: _f$addressLine,
    #city: _f$city,
    #state: _f$state,
    #zipCode: _f$zipCode,
    #country: _f$country,
    #createdBy: _f$createdBy,
    #updatedBy: _f$updatedBy,
  };

  static Address _instantiate(DecodingData data) {
    return Address(
      id: data.dec(_f$id),
      addressLine: data.dec(_f$addressLine),
      city: data.dec(_f$city),
      state: data.dec(_f$state),
      zipCode: data.dec(_f$zipCode),
      country: data.dec(_f$country),
      createdBy: data.dec(_f$createdBy),
      updatedBy: data.dec(_f$updatedBy),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static Address fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Address>(map);
  }

  static Address fromJson(String json) {
    return ensureInitialized().decodeJson<Address>(json);
  }
}

mixin AddressMappable {
  String toJson() {
    return AddressMapper.ensureInitialized().encodeJson<Address>(
      this as Address,
    );
  }

  Map<String, dynamic> toMap() {
    return AddressMapper.ensureInitialized().encodeMap<Address>(
      this as Address,
    );
  }

  AddressCopyWith<Address, Address, Address> get copyWith =>
      _AddressCopyWithImpl<Address, Address>(
        this as Address,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return AddressMapper.ensureInitialized().stringifyValue(this as Address);
  }

  @override
  bool operator ==(Object other) {
    return AddressMapper.ensureInitialized().equalsValue(
      this as Address,
      other,
    );
  }

  @override
  int get hashCode {
    return AddressMapper.ensureInitialized().hashValue(this as Address);
  }
}

extension AddressValueCopy<$R, $Out> on ObjectCopyWith<$R, Address, $Out> {
  AddressCopyWith<$R, Address, $Out> get $asAddress =>
      $base.as((v, t, t2) => _AddressCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class AddressCopyWith<$R, $In extends Address, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    int? id,
    String? addressLine,
    String? city,
    String? state,
    String? zipCode,
    String? country,
    int? createdBy,
    int? updatedBy,
  });
  AddressCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _AddressCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, Address, $Out>
    implements AddressCopyWith<$R, Address, $Out> {
  _AddressCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Address> $mapper =
      AddressMapper.ensureInitialized();
  @override
  $R call({
    int? id,
    String? addressLine,
    String? city,
    String? state,
    String? zipCode,
    String? country,
    Object? createdBy = $none,
    Object? updatedBy = $none,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (addressLine != null) #addressLine: addressLine,
      if (city != null) #city: city,
      if (state != null) #state: state,
      if (zipCode != null) #zipCode: zipCode,
      if (country != null) #country: country,
      if (createdBy != $none) #createdBy: createdBy,
      if (updatedBy != $none) #updatedBy: updatedBy,
    }),
  );
  @override
  Address $make(CopyWithData data) => Address(
    id: data.get(#id, or: $value.id),
    addressLine: data.get(#addressLine, or: $value.addressLine),
    city: data.get(#city, or: $value.city),
    state: data.get(#state, or: $value.state),
    zipCode: data.get(#zipCode, or: $value.zipCode),
    country: data.get(#country, or: $value.country),
    createdBy: data.get(#createdBy, or: $value.createdBy),
    updatedBy: data.get(#updatedBy, or: $value.updatedBy),
  );

  @override
  AddressCopyWith<$R2, Address, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _AddressCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

