import 'dart:convert';

CreateReview createReviewFromJson(String str) => CreateReview.fromJson(json.decode(str));

String createReviewToJson(CreateReview data) => json.encode(data.toJson());

class CreateReview {
  String reviewerId;
  String jobId;
  int rating;
  String comment;
  String id;
  DateTime createdAt;

  CreateReview({
    required this.reviewerId,
    required this.jobId,
    required this.rating,
    required this.comment,
    required this.id,
    required this.createdAt,
  });

  factory CreateReview.fromJson(Map<String, dynamic> json) => CreateReview(
    reviewerId: json["reviewerId"],
    jobId: json["jobId"],
    rating: json["rating"],
    comment: json["comment"],
    id: json["_id"],
    createdAt: DateTime.parse(json["createdAt"]),
  );

  Map<String, dynamic> toJson() => {
    "reviewerId": reviewerId,
    "jobId": jobId,
    "rating": rating,
    "comment": comment,
    "_id": id,
    "createdAt": createdAt.toIso8601String(),
  };
}