import 'dart:convert';

GetReview getReviewFromJson(String str) => GetReview.fromJson(json.decode(str));

String getReviewToJson(GetReview data) => json.encode(data.toJson());

class GetReview {
  bool status;
  Data data;

  GetReview({
    required this.status,
    required this.data,
  });

  factory GetReview.fromJson(Map<String, dynamic> json) => GetReview(
    status: json["status"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data.toJson(),
  };
}

class Data {
  List<Review> reviews;
  int total;
  double averageRating;

  Data({
    required this.reviews,
    required this.total,
    required this.averageRating,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    reviews: List<Review>.from(json["reviews"].map((x) => Review.fromJson(x))),
    total: json["total"],
    averageRating: json["averageRating"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "reviews": List<dynamic>.from(reviews.map((x) => x.toJson())),
    "total": total,
    "averageRating": averageRating,
  };
}

class Review {
  String id;
  ReviewerId reviewerId;
  String jobId;
  int rating;
  String comment;
  DateTime createdAt;

  Review({
    required this.id,
    required this.reviewerId,
    required this.jobId,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
    id: json["_id"],
    reviewerId: ReviewerId.fromJson(json["reviewerId"]),
    jobId: json["jobId"],
    rating: json["rating"],
    comment: json["comment"],
    createdAt: DateTime.parse(json["createdAt"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "reviewerId": reviewerId.toJson(),
    "jobId": jobId,
    "rating": rating,
    "comment": comment,
    "createdAt": createdAt.toIso8601String(),
  };
}

class ReviewerId {
  String id;
  String name;
  String uid;
  String profile;

  ReviewerId({
    required this.id,
    required this.name,
    required this.uid,
    required this.profile,
  });

  factory ReviewerId.fromJson(Map<String, dynamic> json) => ReviewerId(
    id: json["_id"],
    name: json["name"],
    uid: json["uid"],
    profile: json["profile"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "uid": uid,
    "profile": profile,
  };
}