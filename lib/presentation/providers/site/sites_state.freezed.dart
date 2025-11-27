// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sites_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SitesState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<SiteEntity> sites) loaded,
    required TResult Function(String message) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<SiteEntity> sites)? loaded,
    TResult? Function(String message)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<SiteEntity> sites)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SitesInitial value) initial,
    required TResult Function(SitesLoading value) loading,
    required TResult Function(SitesLoaded value) loaded,
    required TResult Function(SitesError value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SitesInitial value)? initial,
    TResult? Function(SitesLoading value)? loading,
    TResult? Function(SitesLoaded value)? loaded,
    TResult? Function(SitesError value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SitesInitial value)? initial,
    TResult Function(SitesLoading value)? loading,
    TResult Function(SitesLoaded value)? loaded,
    TResult Function(SitesError value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SitesStateCopyWith<$Res> {
  factory $SitesStateCopyWith(
          SitesState value, $Res Function(SitesState) then) =
      _$SitesStateCopyWithImpl<$Res, SitesState>;
}

/// @nodoc
class _$SitesStateCopyWithImpl<$Res, $Val extends SitesState>
    implements $SitesStateCopyWith<$Res> {
  _$SitesStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$SitesInitialImplCopyWith<$Res> {
  factory _$$SitesInitialImplCopyWith(
          _$SitesInitialImpl value, $Res Function(_$SitesInitialImpl) then) =
      __$$SitesInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SitesInitialImplCopyWithImpl<$Res>
    extends _$SitesStateCopyWithImpl<$Res, _$SitesInitialImpl>
    implements _$$SitesInitialImplCopyWith<$Res> {
  __$$SitesInitialImplCopyWithImpl(
      _$SitesInitialImpl _value, $Res Function(_$SitesInitialImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$SitesInitialImpl implements SitesInitial {
  const _$SitesInitialImpl();

  @override
  String toString() {
    return 'SitesState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$SitesInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<SiteEntity> sites) loaded,
    required TResult Function(String message) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<SiteEntity> sites)? loaded,
    TResult? Function(String message)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<SiteEntity> sites)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SitesInitial value) initial,
    required TResult Function(SitesLoading value) loading,
    required TResult Function(SitesLoaded value) loaded,
    required TResult Function(SitesError value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SitesInitial value)? initial,
    TResult? Function(SitesLoading value)? loading,
    TResult? Function(SitesLoaded value)? loaded,
    TResult? Function(SitesError value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SitesInitial value)? initial,
    TResult Function(SitesLoading value)? loading,
    TResult Function(SitesLoaded value)? loaded,
    TResult Function(SitesError value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class SitesInitial implements SitesState {
  const factory SitesInitial() = _$SitesInitialImpl;
}

/// @nodoc
abstract class _$$SitesLoadingImplCopyWith<$Res> {
  factory _$$SitesLoadingImplCopyWith(
          _$SitesLoadingImpl value, $Res Function(_$SitesLoadingImpl) then) =
      __$$SitesLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SitesLoadingImplCopyWithImpl<$Res>
    extends _$SitesStateCopyWithImpl<$Res, _$SitesLoadingImpl>
    implements _$$SitesLoadingImplCopyWith<$Res> {
  __$$SitesLoadingImplCopyWithImpl(
      _$SitesLoadingImpl _value, $Res Function(_$SitesLoadingImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$SitesLoadingImpl implements SitesLoading {
  const _$SitesLoadingImpl();

  @override
  String toString() {
    return 'SitesState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$SitesLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<SiteEntity> sites) loaded,
    required TResult Function(String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<SiteEntity> sites)? loaded,
    TResult? Function(String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<SiteEntity> sites)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SitesInitial value) initial,
    required TResult Function(SitesLoading value) loading,
    required TResult Function(SitesLoaded value) loaded,
    required TResult Function(SitesError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SitesInitial value)? initial,
    TResult? Function(SitesLoading value)? loading,
    TResult? Function(SitesLoaded value)? loaded,
    TResult? Function(SitesError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SitesInitial value)? initial,
    TResult Function(SitesLoading value)? loading,
    TResult Function(SitesLoaded value)? loaded,
    TResult Function(SitesError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class SitesLoading implements SitesState {
  const factory SitesLoading() = _$SitesLoadingImpl;
}

/// @nodoc
abstract class _$$SitesLoadedImplCopyWith<$Res> {
  factory _$$SitesLoadedImplCopyWith(
          _$SitesLoadedImpl value, $Res Function(_$SitesLoadedImpl) then) =
      __$$SitesLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<SiteEntity> sites});
}

/// @nodoc
class __$$SitesLoadedImplCopyWithImpl<$Res>
    extends _$SitesStateCopyWithImpl<$Res, _$SitesLoadedImpl>
    implements _$$SitesLoadedImplCopyWith<$Res> {
  __$$SitesLoadedImplCopyWithImpl(
      _$SitesLoadedImpl _value, $Res Function(_$SitesLoadedImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sites = null,
  }) {
    return _then(_$SitesLoadedImpl(
      sites: null == sites
          ? _value._sites
          : sites // ignore: cast_nullable_to_non_nullable
              as List<SiteEntity>,
    ));
  }
}

/// @nodoc

class _$SitesLoadedImpl implements SitesLoaded {
  const _$SitesLoadedImpl({required final List<SiteEntity> sites})
      : _sites = sites;

  final List<SiteEntity> _sites;
  @override
  List<SiteEntity> get sites {
    if (_sites is EqualUnmodifiableListView) return _sites;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sites);
  }

  @override
  String toString() {
    return 'SitesState.loaded(sites: $sites)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SitesLoadedImpl &&
            const DeepCollectionEquality().equals(other._sites, _sites));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_sites));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SitesLoadedImplCopyWith<_$SitesLoadedImpl> get copyWith =>
      __$$SitesLoadedImplCopyWithImpl<_$SitesLoadedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<SiteEntity> sites) loaded,
    required TResult Function(String message) error,
  }) {
    return loaded(sites);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<SiteEntity> sites)? loaded,
    TResult? Function(String message)? error,
  }) {
    return loaded?.call(sites);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<SiteEntity> sites)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(sites);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SitesInitial value) initial,
    required TResult Function(SitesLoading value) loading,
    required TResult Function(SitesLoaded value) loaded,
    required TResult Function(SitesError value) error,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SitesInitial value)? initial,
    TResult? Function(SitesLoading value)? loading,
    TResult? Function(SitesLoaded value)? loaded,
    TResult? Function(SitesError value)? error,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SitesInitial value)? initial,
    TResult Function(SitesLoading value)? loading,
    TResult Function(SitesLoaded value)? loaded,
    TResult Function(SitesError value)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class SitesLoaded implements SitesState {
  const factory SitesLoaded({required final List<SiteEntity> sites}) =
      _$SitesLoadedImpl;

  List<SiteEntity> get sites;
  @JsonKey(ignore: true)
  _$$SitesLoadedImplCopyWith<_$SitesLoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SitesErrorImplCopyWith<$Res> {
  factory _$$SitesErrorImplCopyWith(
          _$SitesErrorImpl value, $Res Function(_$SitesErrorImpl) then) =
      __$$SitesErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$SitesErrorImplCopyWithImpl<$Res>
    extends _$SitesStateCopyWithImpl<$Res, _$SitesErrorImpl>
    implements _$$SitesErrorImplCopyWith<$Res> {
  __$$SitesErrorImplCopyWithImpl(
      _$SitesErrorImpl _value, $Res Function(_$SitesErrorImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$SitesErrorImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$SitesErrorImpl implements SitesError {
  const _$SitesErrorImpl({required this.message});

  @override
  final String message;

  @override
  String toString() {
    return 'SitesState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SitesErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SitesErrorImplCopyWith<_$SitesErrorImpl> get copyWith =>
      __$$SitesErrorImplCopyWithImpl<_$SitesErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<SiteEntity> sites) loaded,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<SiteEntity> sites)? loaded,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<SiteEntity> sites)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SitesInitial value) initial,
    required TResult Function(SitesLoading value) loading,
    required TResult Function(SitesLoaded value) loaded,
    required TResult Function(SitesError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SitesInitial value)? initial,
    TResult? Function(SitesLoading value)? loading,
    TResult? Function(SitesLoaded value)? loaded,
    TResult? Function(SitesError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SitesInitial value)? initial,
    TResult Function(SitesLoading value)? loading,
    TResult Function(SitesLoaded value)? loaded,
    TResult Function(SitesError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class SitesError implements SitesState {
  const factory SitesError({required final String message}) = _$SitesErrorImpl;

  String get message;
  @JsonKey(ignore: true)
  _$$SitesErrorImplCopyWith<_$SitesErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
