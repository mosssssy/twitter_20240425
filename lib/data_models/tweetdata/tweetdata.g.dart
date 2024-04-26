// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tweetdata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TweetDataImpl _$$TweetDataImplFromJson(Map<String, dynamic> json) =>
    _$TweetDataImpl(
      userId: json['userId'] as String,
      tweetContent: json['tweetContent'] as String,
      addedImageUrl: json['addedImageUrl'] as String,
      tweetId: json['tweetId'] as String,
      createdAt:
          const TimestampConverter().fromJson(json['createdAt'] as Timestamp),
      updatedAt:
          const TimestampConverter().fromJson(json['updatedAt'] as Timestamp),
    );

Map<String, dynamic> _$$TweetDataImplToJson(_$TweetDataImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'tweetContent': instance.tweetContent,
      'addedImageUrl': instance.addedImageUrl,
      'tweetId': instance.tweetId,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
    };
