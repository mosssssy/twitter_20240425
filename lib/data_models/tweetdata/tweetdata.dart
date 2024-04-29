import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:twitter_20240425/data_models/components/timestamp_converter.dart';

part 'tweetdata.freezed.dart';
part 'tweetdata.g.dart';

@freezed
class TweetData with _$TweetData {
  factory TweetData({
    required String userId,
    required String tweetContent,
    required String addedImageUrl,
    required String tweetId,
    @TimestampConverter() required Timestamp createdAt,
    @TimestampConverter() required Timestamp updatedAt,
  }) = _TweetData;

  factory TweetData.fromJson(Map<String, dynamic> json) =>
      _$TweetDataFromJson(json);
}
