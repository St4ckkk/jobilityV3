import 'package:flutter/cupertino.dart';
import 'package:jobility/models/response/jobs/get_job.dart';
import 'package:jobility/models/response/jobs/jobs_response.dart';
import 'package:jobility/services/helpers/jobs_helper.dart';
import '../models/response/jobs/get_jobAlerts.dart';
import '../models/response/jobs/get_review.dart';
import '../services/helpers/review_helper.dart';

class JobsNotifier extends ChangeNotifier {
  late Future<List<JobsResponse>> jobList;
  late Future<List<JobsResponse>> recentJob;
  late Future<GetJobRes> job;
  late Future<List<Review>> reviewList; // Future for reviews
  late Future<List<JobAlert>> jobAlerts; // Future for job alerts

  // Fetch all jobs
  Future<List<JobsResponse>> getJobs() {
    jobList = JobsHelper.getJobs();
    return jobList;
  }

  // Fetch recent jobs
  Future<List<JobsResponse>> getRecent() {
    recentJob = JobsHelper.getRecent();
    return recentJob;
  }

  // Fetch a specific job by ID
  Future<GetJobRes> getJob(String jobId) {
    job = JobsHelper.getJob(jobId);
    return job;
  }

  // Fetch all reviews for a specific job
  Future<List<Review>> getReviewsForJob(String jobId) async {
    List<Review>? reviews = await ReviewsHelper.getReviewsForJob(jobId);
    if (reviews != null) {
      reviewList = Future.value(reviews);
    } else {
      reviewList = Future.value([]);
    }
    notifyListeners();
    return reviewList;
  }

  // Fetch job alerts for a specific user
  Future<List<JobAlert>> getJobAlerts(String userId) async {
    try {
      print('Fetching job alerts for user ID: $userId');
      var alerts = await JobsHelper.getJobAlerts(userId);
      jobAlerts = Future.value(alerts);
      notifyListeners();
      return jobAlerts;
    } catch (e) {
      print('Error fetching job alerts: $e');
      return Future.error('Failed to load job alerts');
    }
  }
}