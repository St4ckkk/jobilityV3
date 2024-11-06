import 'package:flutter/material.dart';
import 'package:jobility/models/response/jobs/get_job.dart';
import 'package:jobility/models/response/jobs/jobs_response.dart';
import 'package:jobility/services/helpers/jobs_helper.dart';

<<<<<<< HEAD
=======
import '../models/response/jobs/get_review.dart';
import '../services/helpers/review_helper.dart';

>>>>>>> 80bcbd8 (hehe)
class JobsNotifier extends ChangeNotifier {
  late Future<List<JobsResponse>> jobList;
  late Future<List<JobsResponse>> recentJob;
  late Future<GetJobRes> job;
<<<<<<< HEAD

=======
  late Future<List<Review>> reviewList; // Future for reviews

  // Fetch all jobs
>>>>>>> 80bcbd8 (hehe)
  Future<List<JobsResponse>> getJobs() {
    jobList = JobsHelper.getJobs();
    return jobList;
  }

<<<<<<< HEAD
=======
  // Fetch recent jobs
>>>>>>> 80bcbd8 (hehe)
  Future<List<JobsResponse>> getRecent() {
    recentJob = JobsHelper.getRecent();
    return recentJob;
  }

<<<<<<< HEAD
=======
  // Fetch a specific job by ID
>>>>>>> 80bcbd8 (hehe)
  Future<GetJobRes> getJob(String jobId) {
    job = JobsHelper.getJob(jobId);
    return job;
  }
<<<<<<< HEAD
}
=======

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
}
>>>>>>> 80bcbd8 (hehe)
