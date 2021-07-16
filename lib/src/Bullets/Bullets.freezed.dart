// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'Bullets.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$BulletsTearOff {
  const _$BulletsTearOff();

  _Bullets call(
      {int damage = 5, required double direction, Color color = Colors.white}) {
    return _Bullets(
      damage: damage,
      direction: direction,
      color: color,
    );
  }
}

/// @nodoc
const $Bullets = _$BulletsTearOff();

/// @nodoc
mixin _$Bullets {
  int get damage => throw _privateConstructorUsedError;
  double get direction => throw _privateConstructorUsedError;
  Color get color => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $BulletsCopyWith<Bullets> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BulletsCopyWith<$Res> {
  factory $BulletsCopyWith(Bullets value, $Res Function(Bullets) then) =
      _$BulletsCopyWithImpl<$Res>;
  $Res call({int damage, double direction, Color color});
}

/// @nodoc
class _$BulletsCopyWithImpl<$Res> implements $BulletsCopyWith<$Res> {
  _$BulletsCopyWithImpl(this._value, this._then);

  final Bullets _value;
  // ignore: unused_field
  final $Res Function(Bullets) _then;

  @override
  $Res call({
    Object? damage = freezed,
    Object? direction = freezed,
    Object? color = freezed,
  }) {
    return _then(_value.copyWith(
      damage: damage == freezed
          ? _value.damage
          : damage // ignore: cast_nullable_to_non_nullable
              as int,
      direction: direction == freezed
          ? _value.direction
          : direction // ignore: cast_nullable_to_non_nullable
              as double,
      color: color == freezed
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as Color,
    ));
  }
}

/// @nodoc
abstract class _$BulletsCopyWith<$Res> implements $BulletsCopyWith<$Res> {
  factory _$BulletsCopyWith(_Bullets value, $Res Function(_Bullets) then) =
      __$BulletsCopyWithImpl<$Res>;
  @override
  $Res call({int damage, double direction, Color color});
}

/// @nodoc
class __$BulletsCopyWithImpl<$Res> extends _$BulletsCopyWithImpl<$Res>
    implements _$BulletsCopyWith<$Res> {
  __$BulletsCopyWithImpl(_Bullets _value, $Res Function(_Bullets) _then)
      : super(_value, (v) => _then(v as _Bullets));

  @override
  _Bullets get _value => super._value as _Bullets;

  @override
  $Res call({
    Object? damage = freezed,
    Object? direction = freezed,
    Object? color = freezed,
  }) {
    return _then(_Bullets(
      damage: damage == freezed
          ? _value.damage
          : damage // ignore: cast_nullable_to_non_nullable
              as int,
      direction: direction == freezed
          ? _value.direction
          : direction // ignore: cast_nullable_to_non_nullable
              as double,
      color: color == freezed
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as Color,
    ));
  }
}

/// @nodoc

class _$_Bullets with DiagnosticableTreeMixin implements _Bullets {
  _$_Bullets(
      {this.damage = 5, required this.direction, this.color = Colors.white});

  @JsonKey(defaultValue: 5)
  @override
  final int damage;
  @override
  final double direction;
  @JsonKey(defaultValue: Colors.white)
  @override
  final Color color;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Bullets(damage: $damage, direction: $direction, color: $color)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Bullets'))
      ..add(DiagnosticsProperty('damage', damage))
      ..add(DiagnosticsProperty('direction', direction))
      ..add(DiagnosticsProperty('color', color));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _Bullets &&
            (identical(other.damage, damage) ||
                const DeepCollectionEquality().equals(other.damage, damage)) &&
            (identical(other.direction, direction) ||
                const DeepCollectionEquality()
                    .equals(other.direction, direction)) &&
            (identical(other.color, color) ||
                const DeepCollectionEquality().equals(other.color, color)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(damage) ^
      const DeepCollectionEquality().hash(direction) ^
      const DeepCollectionEquality().hash(color);

  @JsonKey(ignore: true)
  @override
  _$BulletsCopyWith<_Bullets> get copyWith =>
      __$BulletsCopyWithImpl<_Bullets>(this, _$identity);
}

abstract class _Bullets implements Bullets {
  factory _Bullets({int damage, required double direction, Color color}) =
      _$_Bullets;

  @override
  int get damage => throw _privateConstructorUsedError;
  @override
  double get direction => throw _privateConstructorUsedError;
  @override
  Color get color => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$BulletsCopyWith<_Bullets> get copyWith =>
      throw _privateConstructorUsedError;
}
