// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'Player.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$PlayerTearOff {
  const _$PlayerTearOff();

  _Player call(
      {Offset? position = const Offset(300, 300),
      Offset? direction = Offset.zero,
      double? velocity = 0,
      double? rotation = 0,
      int? health = 100,
      Color? color = Colors.white}) {
    return _Player(
      position: position,
      direction: direction,
      velocity: velocity,
      rotation: rotation,
      health: health,
      color: color,
    );
  }
}

/// @nodoc
const $Player = _$PlayerTearOff();

/// @nodoc
mixin _$Player {
  Offset? get position => throw _privateConstructorUsedError;
  Offset? get direction => throw _privateConstructorUsedError;
  double? get velocity => throw _privateConstructorUsedError;
  double? get rotation => throw _privateConstructorUsedError;
  int? get health => throw _privateConstructorUsedError;
  Color? get color => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PlayerCopyWith<Player> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlayerCopyWith<$Res> {
  factory $PlayerCopyWith(Player value, $Res Function(Player) then) =
      _$PlayerCopyWithImpl<$Res>;
  $Res call(
      {Offset? position,
      Offset? direction,
      double? velocity,
      double? rotation,
      int? health,
      Color? color});
}

/// @nodoc
class _$PlayerCopyWithImpl<$Res> implements $PlayerCopyWith<$Res> {
  _$PlayerCopyWithImpl(this._value, this._then);

  final Player _value;
  // ignore: unused_field
  final $Res Function(Player) _then;

  @override
  $Res call({
    Object? position = freezed,
    Object? direction = freezed,
    Object? velocity = freezed,
    Object? rotation = freezed,
    Object? health = freezed,
    Object? color = freezed,
  }) {
    return _then(_value.copyWith(
      position: position == freezed
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as Offset?,
      direction: direction == freezed
          ? _value.direction
          : direction // ignore: cast_nullable_to_non_nullable
              as Offset?,
      velocity: velocity == freezed
          ? _value.velocity
          : velocity // ignore: cast_nullable_to_non_nullable
              as double?,
      rotation: rotation == freezed
          ? _value.rotation
          : rotation // ignore: cast_nullable_to_non_nullable
              as double?,
      health: health == freezed
          ? _value.health
          : health // ignore: cast_nullable_to_non_nullable
              as int?,
      color: color == freezed
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as Color?,
    ));
  }
}

/// @nodoc
abstract class _$PlayerCopyWith<$Res> implements $PlayerCopyWith<$Res> {
  factory _$PlayerCopyWith(_Player value, $Res Function(_Player) then) =
      __$PlayerCopyWithImpl<$Res>;
  @override
  $Res call(
      {Offset? position,
      Offset? direction,
      double? velocity,
      double? rotation,
      int? health,
      Color? color});
}

/// @nodoc
class __$PlayerCopyWithImpl<$Res> extends _$PlayerCopyWithImpl<$Res>
    implements _$PlayerCopyWith<$Res> {
  __$PlayerCopyWithImpl(_Player _value, $Res Function(_Player) _then)
      : super(_value, (v) => _then(v as _Player));

  @override
  _Player get _value => super._value as _Player;

  @override
  $Res call({
    Object? position = freezed,
    Object? direction = freezed,
    Object? velocity = freezed,
    Object? rotation = freezed,
    Object? health = freezed,
    Object? color = freezed,
  }) {
    return _then(_Player(
      position: position == freezed
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as Offset?,
      direction: direction == freezed
          ? _value.direction
          : direction // ignore: cast_nullable_to_non_nullable
              as Offset?,
      velocity: velocity == freezed
          ? _value.velocity
          : velocity // ignore: cast_nullable_to_non_nullable
              as double?,
      rotation: rotation == freezed
          ? _value.rotation
          : rotation // ignore: cast_nullable_to_non_nullable
              as double?,
      health: health == freezed
          ? _value.health
          : health // ignore: cast_nullable_to_non_nullable
              as int?,
      color: color == freezed
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as Color?,
    ));
  }
}

/// @nodoc

class _$_Player with DiagnosticableTreeMixin implements _Player {
  _$_Player(
      {this.position = const Offset(300, 300),
      this.direction = Offset.zero,
      this.velocity = 0,
      this.rotation = 0,
      this.health = 100,
      this.color = Colors.white});

  @JsonKey(defaultValue: const Offset(300, 300))
  @override
  final Offset? position;
  @JsonKey(defaultValue: Offset.zero)
  @override
  final Offset? direction;
  @JsonKey(defaultValue: 0)
  @override
  final double? velocity;
  @JsonKey(defaultValue: 0)
  @override
  final double? rotation;
  @JsonKey(defaultValue: 100)
  @override
  final int? health;
  @JsonKey(defaultValue: Colors.white)
  @override
  final Color? color;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Player(position: $position, direction: $direction, velocity: $velocity, rotation: $rotation, health: $health, color: $color)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Player'))
      ..add(DiagnosticsProperty('position', position))
      ..add(DiagnosticsProperty('direction', direction))
      ..add(DiagnosticsProperty('velocity', velocity))
      ..add(DiagnosticsProperty('rotation', rotation))
      ..add(DiagnosticsProperty('health', health))
      ..add(DiagnosticsProperty('color', color));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _Player &&
            (identical(other.position, position) ||
                const DeepCollectionEquality()
                    .equals(other.position, position)) &&
            (identical(other.direction, direction) ||
                const DeepCollectionEquality()
                    .equals(other.direction, direction)) &&
            (identical(other.velocity, velocity) ||
                const DeepCollectionEquality()
                    .equals(other.velocity, velocity)) &&
            (identical(other.rotation, rotation) ||
                const DeepCollectionEquality()
                    .equals(other.rotation, rotation)) &&
            (identical(other.health, health) ||
                const DeepCollectionEquality().equals(other.health, health)) &&
            (identical(other.color, color) ||
                const DeepCollectionEquality().equals(other.color, color)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(position) ^
      const DeepCollectionEquality().hash(direction) ^
      const DeepCollectionEquality().hash(velocity) ^
      const DeepCollectionEquality().hash(rotation) ^
      const DeepCollectionEquality().hash(health) ^
      const DeepCollectionEquality().hash(color);

  @JsonKey(ignore: true)
  @override
  _$PlayerCopyWith<_Player> get copyWith =>
      __$PlayerCopyWithImpl<_Player>(this, _$identity);
}

abstract class _Player implements Player {
  factory _Player(
      {Offset? position,
      Offset? direction,
      double? velocity,
      double? rotation,
      int? health,
      Color? color}) = _$_Player;

  @override
  Offset? get position => throw _privateConstructorUsedError;
  @override
  Offset? get direction => throw _privateConstructorUsedError;
  @override
  double? get velocity => throw _privateConstructorUsedError;
  @override
  double? get rotation => throw _privateConstructorUsedError;
  @override
  int? get health => throw _privateConstructorUsedError;
  @override
  Color? get color => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$PlayerCopyWith<_Player> get copyWith => throw _privateConstructorUsedError;
}
