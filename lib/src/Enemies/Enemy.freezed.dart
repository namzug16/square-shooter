// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'Enemy.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$EnemyTearOff {
  const _$EnemyTearOff();

  _Enemy call(
      {Offset position = const Offset(100, 100),
      double velocity = 0,
      double rotation = 0,
      int health = 100,
      Color color = Colors.white,
      Color initialColor = Colors.white,
      Color attackColor = Colors.blueAccent}) {
    return _Enemy(
      position: position,
      velocity: velocity,
      rotation: rotation,
      health: health,
      color: color,
      initialColor: initialColor,
      attackColor: attackColor,
    );
  }
}

/// @nodoc
const $Enemy = _$EnemyTearOff();

/// @nodoc
mixin _$Enemy {
  Offset get position => throw _privateConstructorUsedError;
  double get velocity => throw _privateConstructorUsedError;
  double get rotation => throw _privateConstructorUsedError;
  int get health => throw _privateConstructorUsedError;
  Color get color => throw _privateConstructorUsedError;
  Color get initialColor => throw _privateConstructorUsedError;
  Color get attackColor => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $EnemyCopyWith<Enemy> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EnemyCopyWith<$Res> {
  factory $EnemyCopyWith(Enemy value, $Res Function(Enemy) then) =
      _$EnemyCopyWithImpl<$Res>;
  $Res call(
      {Offset position,
      double velocity,
      double rotation,
      int health,
      Color color,
      Color initialColor,
      Color attackColor});
}

/// @nodoc
class _$EnemyCopyWithImpl<$Res> implements $EnemyCopyWith<$Res> {
  _$EnemyCopyWithImpl(this._value, this._then);

  final Enemy _value;
  // ignore: unused_field
  final $Res Function(Enemy) _then;

  @override
  $Res call({
    Object? position = freezed,
    Object? velocity = freezed,
    Object? rotation = freezed,
    Object? health = freezed,
    Object? color = freezed,
    Object? initialColor = freezed,
    Object? attackColor = freezed,
  }) {
    return _then(_value.copyWith(
      position: position == freezed
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as Offset,
      velocity: velocity == freezed
          ? _value.velocity
          : velocity // ignore: cast_nullable_to_non_nullable
              as double,
      rotation: rotation == freezed
          ? _value.rotation
          : rotation // ignore: cast_nullable_to_non_nullable
              as double,
      health: health == freezed
          ? _value.health
          : health // ignore: cast_nullable_to_non_nullable
              as int,
      color: color == freezed
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as Color,
      initialColor: initialColor == freezed
          ? _value.initialColor
          : initialColor // ignore: cast_nullable_to_non_nullable
              as Color,
      attackColor: attackColor == freezed
          ? _value.attackColor
          : attackColor // ignore: cast_nullable_to_non_nullable
              as Color,
    ));
  }
}

/// @nodoc
abstract class _$EnemyCopyWith<$Res> implements $EnemyCopyWith<$Res> {
  factory _$EnemyCopyWith(_Enemy value, $Res Function(_Enemy) then) =
      __$EnemyCopyWithImpl<$Res>;
  @override
  $Res call(
      {Offset position,
      double velocity,
      double rotation,
      int health,
      Color color,
      Color initialColor,
      Color attackColor});
}

/// @nodoc
class __$EnemyCopyWithImpl<$Res> extends _$EnemyCopyWithImpl<$Res>
    implements _$EnemyCopyWith<$Res> {
  __$EnemyCopyWithImpl(_Enemy _value, $Res Function(_Enemy) _then)
      : super(_value, (v) => _then(v as _Enemy));

  @override
  _Enemy get _value => super._value as _Enemy;

  @override
  $Res call({
    Object? position = freezed,
    Object? velocity = freezed,
    Object? rotation = freezed,
    Object? health = freezed,
    Object? color = freezed,
    Object? initialColor = freezed,
    Object? attackColor = freezed,
  }) {
    return _then(_Enemy(
      position: position == freezed
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as Offset,
      velocity: velocity == freezed
          ? _value.velocity
          : velocity // ignore: cast_nullable_to_non_nullable
              as double,
      rotation: rotation == freezed
          ? _value.rotation
          : rotation // ignore: cast_nullable_to_non_nullable
              as double,
      health: health == freezed
          ? _value.health
          : health // ignore: cast_nullable_to_non_nullable
              as int,
      color: color == freezed
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as Color,
      initialColor: initialColor == freezed
          ? _value.initialColor
          : initialColor // ignore: cast_nullable_to_non_nullable
              as Color,
      attackColor: attackColor == freezed
          ? _value.attackColor
          : attackColor // ignore: cast_nullable_to_non_nullable
              as Color,
    ));
  }
}

/// @nodoc

class _$_Enemy with DiagnosticableTreeMixin implements _Enemy {
  _$_Enemy(
      {this.position = const Offset(100, 100),
      this.velocity = 0,
      this.rotation = 0,
      this.health = 100,
      this.color = Colors.white,
      this.initialColor = Colors.white,
      this.attackColor = Colors.blueAccent});

  @JsonKey(defaultValue: const Offset(100, 100))
  @override
  final Offset position;
  @JsonKey(defaultValue: 0)
  @override
  final double velocity;
  @JsonKey(defaultValue: 0)
  @override
  final double rotation;
  @JsonKey(defaultValue: 100)
  @override
  final int health;
  @JsonKey(defaultValue: Colors.white)
  @override
  final Color color;
  @JsonKey(defaultValue: Colors.white)
  @override
  final Color initialColor;
  @JsonKey(defaultValue: Colors.blueAccent)
  @override
  final Color attackColor;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Enemy(position: $position, velocity: $velocity, rotation: $rotation, health: $health, color: $color, initialColor: $initialColor, attackColor: $attackColor)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Enemy'))
      ..add(DiagnosticsProperty('position', position))
      ..add(DiagnosticsProperty('velocity', velocity))
      ..add(DiagnosticsProperty('rotation', rotation))
      ..add(DiagnosticsProperty('health', health))
      ..add(DiagnosticsProperty('color', color))
      ..add(DiagnosticsProperty('initialColor', initialColor))
      ..add(DiagnosticsProperty('attackColor', attackColor));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _Enemy &&
            (identical(other.position, position) ||
                const DeepCollectionEquality()
                    .equals(other.position, position)) &&
            (identical(other.velocity, velocity) ||
                const DeepCollectionEquality()
                    .equals(other.velocity, velocity)) &&
            (identical(other.rotation, rotation) ||
                const DeepCollectionEquality()
                    .equals(other.rotation, rotation)) &&
            (identical(other.health, health) ||
                const DeepCollectionEquality().equals(other.health, health)) &&
            (identical(other.color, color) ||
                const DeepCollectionEquality().equals(other.color, color)) &&
            (identical(other.initialColor, initialColor) ||
                const DeepCollectionEquality()
                    .equals(other.initialColor, initialColor)) &&
            (identical(other.attackColor, attackColor) ||
                const DeepCollectionEquality()
                    .equals(other.attackColor, attackColor)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(position) ^
      const DeepCollectionEquality().hash(velocity) ^
      const DeepCollectionEquality().hash(rotation) ^
      const DeepCollectionEquality().hash(health) ^
      const DeepCollectionEquality().hash(color) ^
      const DeepCollectionEquality().hash(initialColor) ^
      const DeepCollectionEquality().hash(attackColor);

  @JsonKey(ignore: true)
  @override
  _$EnemyCopyWith<_Enemy> get copyWith =>
      __$EnemyCopyWithImpl<_Enemy>(this, _$identity);
}

abstract class _Enemy implements Enemy {
  factory _Enemy(
      {Offset position,
      double velocity,
      double rotation,
      int health,
      Color color,
      Color initialColor,
      Color attackColor}) = _$_Enemy;

  @override
  Offset get position => throw _privateConstructorUsedError;
  @override
  double get velocity => throw _privateConstructorUsedError;
  @override
  double get rotation => throw _privateConstructorUsedError;
  @override
  int get health => throw _privateConstructorUsedError;
  @override
  Color get color => throw _privateConstructorUsedError;
  @override
  Color get initialColor => throw _privateConstructorUsedError;
  @override
  Color get attackColor => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$EnemyCopyWith<_Enemy> get copyWith => throw _privateConstructorUsedError;
}
