import 'package:http/http.dart' as http;
import 'package:jobility/models/request/jobs/create_review.dart';
import 'dart:convert';
import 'package:jobility/services/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/response/jobs/get_review.dart';

class ReviewsHelper {
  static var client = http.Client();

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

  // Create a new review
  static Future<bool> createReview(CreateReview review) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    var body = jsonEncode(review.toJson());

    var response = await client.post(
      Uri.parse('${Config.baseUrl}${Config.createReviewUrl}'),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      // Handle error
      print('Failed to create review');
      return false;
    }
  }
}