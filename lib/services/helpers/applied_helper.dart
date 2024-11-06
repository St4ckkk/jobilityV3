import 'package:http/http.dart' as https;
import 'package:jobility/models/response/applied/applied.dart';
import 'package:jobility/services/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppliedHelper {
  static var client = https.Client();

  static Future<bool> applyJob(String model) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      return false;
    }

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'authorization': 'Bearer $token'
    };
    var url = Uri.https(Config.apiUrl, Config.appliedUrl);
    var response = await client.post(url, headers: requestHeaders, body: model);

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<List<Applied>> getApplied() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      print('Failed to get token from SharedPreferences.');
      throw Exception('Failed to get token');
    }

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'authorization': 'Bearer $token'
    };
    var url = Uri.https(Config.apiUrl, Config.appliedUrl);

    print('Making GET request to: $url with headers: $requestHeaders');

    var response = await client.get(url, headers: requestHeaders);

    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      var applied = appliedFromJson(response.body);
      return applied;
    } else {
      print('Error: Failed to get applied jobs. Status code: ${response.statusCode}');
      throw Exception('Failed to get applied jobs');
    }
  }

}
