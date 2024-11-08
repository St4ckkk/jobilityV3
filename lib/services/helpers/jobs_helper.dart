import 'package:http/http.dart' as https;
import 'package:jobility/models/response/jobs/get_job.dart';
import 'package:jobility/models/response/jobs/jobs_response.dart';
import 'package:jobility/services/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../models/response/jobs/get_jobAlerts.dart';

class JobsHelper {
  static var client = https.Client();

  static Future<List<JobsResponse>> getJobs() async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.https(Config.apiUrl, Config.jobs);

    var response = await client.get(url, headers: requestHeaders);

    if (response.statusCode == 200) {
      var jobList = jobsResponseFromJson(response.body);
      return jobList;
    } else {
      throw Exception('Failed to load jobs');
    }
  }

  static Future<GetJobRes> getJob(String jobId) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.https(Config.apiUrl, "${Config.jobs}/$jobId");
    var response = await client.get(url, headers: requestHeaders);

    if (response.statusCode == 200) {
      var job = getJobResFromJson(response.body);
      return job;
    } else {
      throw Exception('Failed to load jobs');
    }
  }

  static Future<List<JobsResponse>> getRecent() async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.https(Config.apiUrl, Config.jobs, {"new": "true"});
    var response = await client.get(url, headers: requestHeaders);

    if (response.statusCode == 200) {
      var jobList = jobsResponseFromJson(response.body);
      return jobList;
    } else {
      throw Exception('Failed to load jobs');
    }
  }

  static Future<bool> createJob(String model) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        print('Token is null');
        return false;
      }

      Map<String, String> requestHeaders = {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token'
      };

      var url = Uri.https(Config.apiUrl, Config.jobs);

      var response = await client.post(url, headers: requestHeaders, body: model);

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Job created successfully');
        return true;
      } else {
        print('Failed to create job: ${response.statusCode} ${response.body}');
        return false;
      }
    } catch (e) {
      print('Exception occurred while creating job: $e');
      return false;
    }
  }

  static Future<bool> updateJob(String model, String jobId) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        return false;
      }

      Map<String, String> requestHeaders = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      };

      var url = Uri.https(Config.apiUrl, "${Config.jobs}/$jobId");

      var response = await client.put(url, headers: requestHeaders, body: model);

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<List<JobsResponse>> searchJobs(String query) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.https(Config.apiUrl, "${Config.search}/$query");
    print(url);
    var response = await client.get(url, headers: requestHeaders);

    if (response.statusCode == 200) {
      var jobList = jobsResponseFromJson(response.body);
      return jobList;
    } else {
      throw Exception('Failed to load jobs');
    }
  }

  // Add method to fetch job alerts
  static Future<List<JobAlert>> getJobAlerts(String userId) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.https(Config.apiUrl, "${Config.jobAlertsUrl}$userId");

    print('Fetching job alerts from URL: $url');

    var response = await client.get(url, headers: requestHeaders);

    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      var jobAlertList = jobAlertFromJson(response.body);
      return jobAlertList;
    } else {
      print('Failed to load job alerts: ${response.statusCode} ${response.body}');
      throw Exception('Failed to load job alerts');
    }
  }
}