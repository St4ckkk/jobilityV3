<<<<<<< HEAD
# jobility - Capstone Project 
# job finder app for differently-abled person

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
=======
import 'package:http/http.dart' as https;
import 'dart:convert';
import 'package:jobility/services/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/response/jobs/get_review.dart';

class ReviewsHelper {
static var client = https.Client();

// Get all reviews for a specific job
static Future<GetReview?> getReviewsForJob(String jobId) async {
SharedPreferences prefs = await SharedPreferences.getInstance();
String? token = prefs.getString('token');

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    var response = await client.get(
      Uri.parse('${Config.apiUrl}/reviews/$jobId'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      var jsonString = response.body;
      return getReviewFromJson(jsonString);
    } else {
      // Handle error
      print('Failed to load reviews');
      return null;
    }
}
}


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

Future<List<Review>> getReviewsForJob(String jobId) async {
GetReview? getReview = await ReviewsHelper.getReviewsForJob(jobId);
if (getReview != null) {
reviewList = Future.value(getReview.data.reviews);
} else {
reviewList = Future.value([]);
}
return reviewList;
}
>>>>>>> 80bcbd8 (hehe)
