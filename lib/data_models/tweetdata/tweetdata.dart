import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'tweetdata.freezed.dart';
part 'tweetdata.g.dart';

@freezed
class TweetData with _$TweetData {
  factory TweetData({
    required String userId,
    required String tweetContent,
    required String addedImageUrl,
    @TimestampConverter() required Timestamp createdAt,
    @TimestampConverter() required Timestamp updatedAt,
  }) = _TweetData;

  factory TweetData.fromJson(Map<String, dynamic> json) =>
      _$TweetDataFromJson(json);
}

class TimestampConverter implements JsonConverter<Timestamp, Timestamp> {
  const TimestampConverter();

  @override
  Timestamp fromJson(Timestamp timestamp) {
    return timestamp;
  }

  @override
  Timestamp toJson(Timestamp date) => date;
}
