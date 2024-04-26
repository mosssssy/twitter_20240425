// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tweetdata.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TweetData _$TweetDataFromJson(Map<String, dynamic> json) {
  return _TweetData.fromJson(json);
}

/// @nodoc
mixin _$TweetData {
  String get userId => throw _privateConstructorUsedError;
  String get tweetContent => throw _privateConstructorUsedError;
  String get addedImageUrl => throw _privateConstructorUsedError;
  @TimestampConverter()
  Timestamp get createdAt => throw _privateConstructorUsedError;
  @TimestampConverter()
  Timestamp get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TweetDataCopyWith<TweetData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TweetDataCopyWith<$Res> {
  factory $TweetDataCopyWith(TweetData value, $Res Function(TweetData) then) =
      _$TweetDataCopyWithImpl<$Res, TweetData>;
  @useResult
  $Res call(
      {String userId,
      String tweetContent,
      String addedImageUrl,
      @TimestampConverter() Timestamp createdAt,
      @TimestampConverter() Timestamp updatedAt});
}

/// @nodoc
class _$TweetDataCopyWithImpl<$Res, $Val extends TweetData>
    implements $TweetDataCopyWith<$Res> {
  _$TweetDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? tweetContent = null,
    Object? addedImageUrl = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      tweetContent: null == tweetContent
          ? _value.tweetContent
          : tweetContent // ignore: cast_nullable_to_non_nullable
              as String,
      addedImageUrl: null == addedImageUrl
          ? _value.addedImageUrl
          : addedImageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as Timestamp,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as Timestamp,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TweetDataImplCopyWith<$Res>
    implements $TweetDataCopyWith<$Res> {
  factory _$$TweetDataImplCopyWith(
          _$TweetDataImpl value, $Res Function(_$TweetDataImpl) then) =
      __$$TweetDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId,
      String tweetContent,
      String addedImageUrl,
      @TimestampConverter() Timestamp createdAt,
      @TimestampConverter() Timestamp updatedAt});
}

/// @nodoc
class __$$TweetDataImplCopyWithImpl<$Res>
    extends _$TweetDataCopyWithImpl<$Res, _$TweetDataImpl>
    implements _$$TweetDataImplCopyWith<$Res> {
  __$$TweetDataImplCopyWithImpl(
      _$TweetDataImpl _value, $Res Function(_$TweetDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? tweetContent = null,
    Object? addedImageUrl = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$TweetDataImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      tweetContent: null == tweetContent
          ? _value.tweetContent
          : tweetContent // ignore: cast_nullable_to_non_nullable
              as String,
      addedImageUrl: null == addedImageUrl
          ? _value.addedImageUrl
          : addedImageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as Timestamp,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as Timestamp,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TweetDataImpl implements _TweetData {
  _$TweetDataImpl(
      {required this.userId,
      required this.tweetContent,
      required this.addedImageUrl,
      @TimestampConverter() required this.createdAt,
      @TimestampConverter() required this.updatedAt});

  factory _$TweetDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$TweetDataImplFromJson(json);

  @override
  final String userId;
  @override
  final String tweetContent;
  @override
  final String addedImageUrl;
  @override
  @TimestampConverter()
  final Timestamp createdAt;
  @override
  @TimestampConverter()
  final Timestamp updatedAt;

  @override
  String toString() {
    return 'TweetData(userId: $userId, tweetContent: $tweetContent, addedImageUrl: $addedImageUrl, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TweetDataImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.tweetContent, tweetContent) ||
                other.tweetContent == tweetContent) &&
            (identical(other.addedImageUrl, addedImageUrl) ||
                other.addedImageUrl == addedImageUrl) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, userId, tweetContent, addedImageUrl, createdAt, updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TweetDataImplCopyWith<_$TweetDataImpl> get copyWith =>
      __$$TweetDataImplCopyWithImpl<_$TweetDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TweetDataImplToJson(
      this,
    );
  }
}

abstract class _TweetData implements TweetData {
  factory _TweetData(
          {required final String userId,
          required final String tweetContent,
          required final String addedImageUrl,
          @TimestampConverter() required final Timestamp createdAt,
          @TimestampConverter() required final Timestamp updatedAt}) =
      _$TweetDataImpl;

  factory _TweetData.fromJson(Map<String, dynamic> json) =
      _$TweetDataImpl.fromJson;

  @override
  String get userId;
  @override
  String get tweetContent;
  @override
  String get addedImageUrl;
  @override
  @TimestampConverter()
  Timestamp get createdAt;
  @override
  @TimestampConverter()
  Timestamp get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$TweetDataImplCopyWith<_$TweetDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
