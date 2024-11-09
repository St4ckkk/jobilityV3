import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http_parser/http_parser.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as https;
import 'package:jobility/models/response/auth/login_res_model.dart';
import 'package:jobility/models/response/auth/profile_model.dart';
import 'package:jobility/models/response/auth/skills.dart';
import 'package:jobility/services/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import '../../models/request/auth/update_user_profile.dart';
import '../../models/response/auth/upload_resume_model.dart';

class AuthHelper {
  static var client = https.Client();

  // Method to sign up a user
  static Future<bool> signup(String model) async {
    try {
      Map<String, String> requestHeaders = {
        'Content-Type': 'application/json',
      };

      var url = Uri.https(Config.apiUrl, Config.signupUrl);

      var response = await client.post(url, headers: requestHeaders, body: model);

      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<bool> login(String model) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.https(Config.apiUrl, Config.loginUrl);

    var response = await client.post(url, headers: requestHeaders, body: model);

    if (response.statusCode == 200) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      var user = loginResponseModelFromJson(response.body);

      await prefs.setString('token', user.userToken);
      await prefs.setString('userId', user.id); // Ensure this is the correct key
      await prefs.setString('uid', user.uid); // Storing user UID
      await prefs.setString('profile', user.profile);
      await prefs.setBool('isAgent', user.isAgent);
      await prefs.setString('username', user.username);
      await prefs.setString('name', user.name);
      await prefs.setBool('loggedIn', true);

      // Debugging statements
      debugPrint('AuthHelper: Stored user UID: ${user.uid}');

      return true;
    } else {
      return false;
    }
  }

  static Future<String?> getUserUid() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('uid'); // Make sure you use the correct key here
  }

  // Method to get the user profile
  static Future<ProfileRes> getProfile() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('No authentication token provided');
    }

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'authorization': 'Bearer $token'
    };

    var url = Uri.https(Config.apiUrl, Config.profileUrl);

    try {
      var response = await client.get(url, headers: requestHeaders);

      if (response.statusCode == 200) {
        var profile = profileResFromJson(response.body);
        return profile;
      } else {
        throw Exception('Failed to get profile');
      }
    } catch (e) {
      throw Exception('Failed to get profile: $e');
    }
  }

  // Method to get skills
  static Future<List<Skills>> getSkills() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('No authentication token provided');
    }

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'authorization': 'Bearer $token'
    };

    var url = Uri.https(Config.apiUrl, Config.skillsUrl);

    try {
      var response = await client.get(url, headers: requestHeaders);

      if (response.statusCode == 200) {
        var skills = skillsFromJson(response.body);
        return skills;
      } else {
        throw Exception('Failed to get skills');
      }
    } catch (e) {
      throw Exception('Failed to get skills: $e');
    }
  }

  // Method to delete a skill
  static Future<bool> deleteSkill(String id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('No authentication token provided');
    }

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'authorization': 'Bearer $token'
    };

    var url = Uri.https(Config.apiUrl, "${Config.skillsUrl}/$id");

    try {
      var response = await client.delete(url, headers: requestHeaders);

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  // Method to add skills
  static Future<bool> addSkills(String model) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('No authentication token provided');
    }

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'authorization': 'Bearer $token'
    };

    var url = Uri.https(Config.apiUrl, Config.skillsUrl);

    try {
      var response = await client.post(url, headers: requestHeaders, body: model);

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  // Method to update profile
  static Future<bool> updateProfile(ProfileUpdate profileUpdate) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? id = prefs.getString('id');

    if (token == null || id == null) {
      throw Exception('No authentication token or id provided');
    }

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'authorization': 'Bearer $token'
    };

    var url = Uri.https(Config.apiUrl, "${Config.profileUpdateUrl}/$id");

    print('Token: $token');
    print('ID: $id');
    print('URL: $url');
    print('Request Headers: $requestHeaders');
    print('Request Body: ${profileUpdateToJson(profileUpdate)}');

    try {
      var response = await client.put(url, headers: requestHeaders, body: profileUpdateToJson(profileUpdate));

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  static Future<bool> uploadResume() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('No authentication token provided');
    }

    try {
      // Pick the file
      FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
      if (result == null) return false; // No file selected

      var filePath = result.files.single.path;

      if (filePath == null) return false;

      // Preparing FormData with the file
      var formData = FormData.fromMap({
        'resume': await MultipartFile.fromFile(filePath, filename: 'resume.pdf', contentType: MediaType('application', 'pdf')),
      });

      // Setting up Dio with headers
      Dio dio = Dio();
      dio.options.headers['authorization'] = 'Bearer $token';

      // Uploading the file
      Response response = await dio.post(
        "${Config.baseUrl}${Config.uploadResumeUrl}",
        data: formData,
      );

      print('Request URL: ${Config.baseUrl}${Config.uploadResumeUrl}');
      print('Request Headers: ${dio.options.headers}');
      print('Request FormData: ${formData.fields}');
      print('Request FormData Files: ${formData.files}');
      print('Response Status Code: ${response.statusCode}');
      print('Response Data: ${response.data}');

      if (response.statusCode == 200 && response.data['status'] == true) {
        return true;
      } else {
        print('Failed to upload resume: ${response.data}');
        return false;
      }
    } catch (e) {
      if (e is DioError) {
        print('DioError: ${e.response?.data}');
        print('DioError: ${e.response?.statusCode}');
        print('DioError: ${e.response?.headers}');
        print('DioError: ${e.requestOptions}');
      } else {
        print('Error in uploadResume: $e');
      }
      return false;
    }
  }
}