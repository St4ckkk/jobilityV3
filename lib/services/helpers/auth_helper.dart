import 'package:http/http.dart' as https;
import 'package:jobility/models/response/auth/login_res_model.dart';
import 'package:jobility/models/response/auth/profile_model.dart';
import 'package:jobility/models/response/auth/skills.dart';
import 'package:jobility/services/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthHelper {
  static var client = https.Client();

  // Method to sign up a user
  static Future<bool> signup(String model) async {
    try {
      Map<String, String> requestHeaders = {
        'Content-Type': 'application/json',
      };

      var url = Uri.https(Config.apiUrl, Config.signupUrl);
<<<<<<< HEAD
      print('Signup URL: $url');
      print('Signup request body: $model');

      var response = await client.post(url, headers: requestHeaders, body: model);

      print('Signup response status code: ${response.statusCode}');
      print('Signup response body: ${response.body}');
=======
      // print('Signup URL: $url');
      // print('Signup request body: $model');

      var response = await client.post(url, headers: requestHeaders, body: model);

      // print('Signup response status code: ${response.statusCode}');
      // print('Signup response body: ${response.body}');
>>>>>>> 80bcbd8 (hehe)

      if (response.statusCode == 201) {
        print('Signup successful');
        return true;
      } else {
        print('Signup failed with status code: ${response.statusCode}');
        print('Error response: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Signup exception occurred: $e');
      return false;
    }
  }

  // Method to log in a user
  static Future<bool> login(String model) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.https(Config.apiUrl, Config.loginUrl);

    var response = await client.post(url, headers: requestHeaders, body: model);

<<<<<<< HEAD
    print('Login response status code: ${response.statusCode}');
    print('Login response body: ${response.body}');
=======
    // print('Login response status code: ${response.statusCode}');
    // print('Login response body: ${response.body}');
>>>>>>> 80bcbd8 (hehe)

    if (response.statusCode == 200) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      var user = loginResponseModelFromJson(response.body);
      print('Parsed user: $user');

      await prefs.setString('token', user.userToken);
      await prefs.setString('userId', user.id);
      await prefs.setString('uid', user.id); // Storing user UID
      await prefs.setString('profile', user.profile);
      await prefs.setBool('isAgent', user.isAgent);
      await prefs.setString('username', user.username);
      await prefs.setString('name', user.name);
      await prefs.setBool('loggedIn', true);
<<<<<<< HEAD

      print('User UID after login: ${prefs.getString('uid')}'); // Debugging line
=======
      //
      // print('User UID after login: ${prefs.getString('uid')}'); // Debugging line
>>>>>>> 80bcbd8 (hehe)
      return true;
    } else {
      return false;
    }
  }

  // Method to retrieve the user's UID
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
    print("Request URL: $url"); // Debugging line
    try {
      var response = await client.get(url, headers: requestHeaders);
      print("Status code: ${response.statusCode}"); // Debugging line
      print("Response body: ${response.body}"); // Debugging line

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
}
