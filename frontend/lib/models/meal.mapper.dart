// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'meal.dart';

class MealMapper extends ClassMapperBase<Meal> {
  MealMapper._();

  static MealMapper? _instance;
  static MealMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MealMapper._());
      MealIngredientMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'Meal';

  static int? _$id(Meal v) => v.id;
  static const Field<Meal, int> _f$id = Field('id', _$id, opt: true);
  static String _$name(Meal v) => v.name;
  static const Field<Meal, String> _f$name = Field('name', _$name);
  static String? _$description(Meal v) => v.description;
  static const Field<Meal, String> _f$description = Field(
    'description',
    _$description,
    opt: true,
  );
  static int? _$user(Meal v) => v.user;
  static const Field<Meal, int> _f$user = Field('user', _$user, opt: true);
  static bool _$isFavorite(Meal v) => v.isFavorite;
  static const Field<Meal, bool> _f$isFavorite = Field(
    'isFavorite',
    _$isFavorite,
    key: r'is_favorite',
    opt: true,
    def: false,
  );
  static List<MealIngredient> _$ingredients(Meal v) => v.ingredients;
  static const Field<Meal, List<MealIngredient>> _f$ingredients = Field(
    'ingredients',
    _$ingredients,
    opt: true,
    def: const [],
  );

  @override
  final MappableFields<Meal> fields = const {
    #id: _f$id,
    #name: _f$name,
    #description: _f$description,
    #user: _f$user,
    #isFavorite: _f$isFavorite,
    #ingredients: _f$ingredients,
  };

  static Meal _instantiate(DecodingData data) {
    return Meal(
      id: data.dec(_f$id),
      name: data.dec(_f$name),
      description: data.dec(_f$description),
      user: data.dec(_f$user),
      isFavorite: data.dec(_f$isFavorite),
      ingredients: data.dec(_f$ingredients),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static Meal fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Meal>(map);
  }

  static Meal fromJson(String json) {
    return ensureInitialized().decodeJson<Meal>(json);
  }
}

mixin MealMappable {
  String toJson() {
    return MealMapper.ensureInitialized().encodeJson<Meal>(this as Meal);
  }

  Map<String, dynamic> toMap() {
    return MealMapper.ensureInitialized().encodeMap<Meal>(this as Meal);
  }

  MealCopyWith<Meal, Meal, Meal> get copyWith =>
      _MealCopyWithImpl<Meal, Meal>(this as Meal, $identity, $identity);
  @override
  String toString() {
    return MealMapper.ensureInitialized().stringifyValue(this as Meal);
  }

  @override
  bool operator ==(Object other) {
    return MealMapper.ensureInitialized().equalsValue(this as Meal, other);
  }

  @override
  int get hashCode {
    return MealMapper.ensureInitialized().hashValue(this as Meal);
  }
}

extension MealValueCopy<$R, $Out> on ObjectCopyWith<$R, Meal, $Out> {
  MealCopyWith<$R, Meal, $Out> get $asMeal =>
      $base.as((v, t, t2) => _MealCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class MealCopyWith<$R, $In extends Meal, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    MealIngredient,
    MealIngredientCopyWith<$R, MealIngredient, MealIngredient>
  >
  get ingredients;
  $R call({
    int? id,
    String? name,
    String? description,
    int? user,
    bool? isFavorite,
    List<MealIngredient>? ingredients,
  });
  MealCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _MealCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, Meal, $Out>
    implements MealCopyWith<$R, Meal, $Out> {
  _MealCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Meal> $mapper = MealMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    MealIngredient,
    MealIngredientCopyWith<$R, MealIngredient, MealIngredient>
  >
  get ingredients => ListCopyWith(
    $value.ingredients,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(ingredients: v),
  );
  @override
  $R call({
    Object? id = $none,
    String? name,
    Object? description = $none,
    Object? user = $none,
    bool? isFavorite,
    List<MealIngredient>? ingredients,
  }) => $apply(
    FieldCopyWithData({
      if (id != $none) #id: id,
      if (name != null) #name: name,
      if (description != $none) #description: description,
      if (user != $none) #user: user,
      if (isFavorite != null) #isFavorite: isFavorite,
      if (ingredients != null) #ingredients: ingredients,
    }),
  );
  @override
  Meal $make(CopyWithData data) => Meal(
    id: data.get(#id, or: $value.id),
    name: data.get(#name, or: $value.name),
    description: data.get(#description, or: $value.description),
    user: data.get(#user, or: $value.user),
    isFavorite: data.get(#isFavorite, or: $value.isFavorite),
    ingredients: data.get(#ingredients, or: $value.ingredients),
  );

  @override
  MealCopyWith<$R2, Meal, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _MealCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class MealIngredientMapper extends ClassMapperBase<MealIngredient> {
  MealIngredientMapper._();

  static MealIngredientMapper? _instance;
  static MealIngredientMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MealIngredientMapper._());
      PantryItemMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'MealIngredient';

  static int? _$id(MealIngredient v) => v.id;
  static const Field<MealIngredient, int> _f$id = Field('id', _$id, opt: true);
  static PantryItem _$pantryItemTemplate(MealIngredient v) =>
      v.pantryItemTemplate;
  static const Field<MealIngredient, PantryItem> _f$pantryItemTemplate = Field(
    'pantryItemTemplate',
    _$pantryItemTemplate,
    key: r'pantry_item_template',
  );
  static double _$quantity(MealIngredient v) => v.quantity;
  static const Field<MealIngredient, double> _f$quantity = Field(
    'quantity',
    _$quantity,
  );
  static String? _$unit(MealIngredient v) => v.unit;
  static const Field<MealIngredient, String> _f$unit = Field(
    'unit',
    _$unit,
    opt: true,
  );

  @override
  final MappableFields<MealIngredient> fields = const {
    #id: _f$id,
    #pantryItemTemplate: _f$pantryItemTemplate,
    #quantity: _f$quantity,
    #unit: _f$unit,
  };

  static MealIngredient _instantiate(DecodingData data) {
    return MealIngredient(
      id: data.dec(_f$id),
      pantryItemTemplate: data.dec(_f$pantryItemTemplate),
      quantity: data.dec(_f$quantity),
      unit: data.dec(_f$unit),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static MealIngredient fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MealIngredient>(map);
  }

  static MealIngredient fromJson(String json) {
    return ensureInitialized().decodeJson<MealIngredient>(json);
  }
}

mixin MealIngredientMappable {
  String toJson() {
    return MealIngredientMapper.ensureInitialized().encodeJson<MealIngredient>(
      this as MealIngredient,
    );
  }

  Map<String, dynamic> toMap() {
    return MealIngredientMapper.ensureInitialized().encodeMap<MealIngredient>(
      this as MealIngredient,
    );
  }

  MealIngredientCopyWith<MealIngredient, MealIngredient, MealIngredient>
  get copyWith => _MealIngredientCopyWithImpl<MealIngredient, MealIngredient>(
    this as MealIngredient,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return MealIngredientMapper.ensureInitialized().stringifyValue(
      this as MealIngredient,
    );
  }

  @override
  bool operator ==(Object other) {
    return MealIngredientMapper.ensureInitialized().equalsValue(
      this as MealIngredient,
      other,
    );
  }

  @override
  int get hashCode {
    return MealIngredientMapper.ensureInitialized().hashValue(
      this as MealIngredient,
    );
  }
}

extension MealIngredientValueCopy<$R, $Out>
    on ObjectCopyWith<$R, MealIngredient, $Out> {
  MealIngredientCopyWith<$R, MealIngredient, $Out> get $asMealIngredient =>
      $base.as((v, t, t2) => _MealIngredientCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class MealIngredientCopyWith<$R, $In extends MealIngredient, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  PantryItemCopyWith<$R, PantryItem, PantryItem> get pantryItemTemplate;
  $R call({
    int? id,
    PantryItem? pantryItemTemplate,
    double? quantity,
    String? unit,
  });
  MealIngredientCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _MealIngredientCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MealIngredient, $Out>
    implements MealIngredientCopyWith<$R, MealIngredient, $Out> {
  _MealIngredientCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MealIngredient> $mapper =
      MealIngredientMapper.ensureInitialized();
  @override
  PantryItemCopyWith<$R, PantryItem, PantryItem> get pantryItemTemplate =>
      $value.pantryItemTemplate.copyWith.$chain(
        (v) => call(pantryItemTemplate: v),
      );
  @override
  $R call({
    Object? id = $none,
    PantryItem? pantryItemTemplate,
    double? quantity,
    Object? unit = $none,
  }) => $apply(
    FieldCopyWithData({
      if (id != $none) #id: id,
      if (pantryItemTemplate != null) #pantryItemTemplate: pantryItemTemplate,
      if (quantity != null) #quantity: quantity,
      if (unit != $none) #unit: unit,
    }),
  );
  @override
  MealIngredient $make(CopyWithData data) => MealIngredient(
    id: data.get(#id, or: $value.id),
    pantryItemTemplate: data.get(
      #pantryItemTemplate,
      or: $value.pantryItemTemplate,
    ),
    quantity: data.get(#quantity, or: $value.quantity),
    unit: data.get(#unit, or: $value.unit),
  );

  @override
  MealIngredientCopyWith<$R2, MealIngredient, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _MealIngredientCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

