import 'package:http/http.dart' as https;
import 'dart:convert';
import 'package:jobility/services/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/response/jobs/get_review.dart';

class ReviewsHelper {
  static var client = https.Client();

  // Get all reviews for a specific job
  static Future<List<Review>?> getReviewsForJob(String jobId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    var response = await client.get(
      Uri.parse('${Config.baseUrl}${Config.reviewUrl}$jobId'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      var jsonString = response.body;
      GetReview getReview = getReviewFromJson(jsonString);
      return getReview.data.reviews;
    } else {
      // Handle error
      print('Failed to load reviews');
      return null;
    }
  }
}