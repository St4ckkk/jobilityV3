import 'package:http/http.dart' as https;
import 'package:jobility/models/request/agents/agents.dart';
import 'package:jobility/models/response/agent/getAgent.dart';
import 'package:jobility/models/response/bookmarks/bookmark.dart';
import 'package:jobility/models/response/jobs/jobs_response.dart';
import 'package:jobility/services/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AgencyHelper {
  static var client = https.Client();


  static Future<List<Agents>> getAgents() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        throw Exception('Failed to get token');
      }

      Map<String, String> requestHeaders = {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token'
      };

      var url = Uri.https(Config.apiUrl, Config.getAgentsUrl);
      var response = await client.get(url, headers: requestHeaders);

      // Add this debug print
      // print('API Response: ${response.body}');

      if (response.statusCode == 200) {
        try {
          return agentsFromJson(response.body);
        } catch (e) {
          print('Error parsing agents: $e');
          print('Response body: ${response.body}');
          throw Exception('Failed to parse agents response');
        }
      } else {
        throw Exception('Failed to get agents: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getAgents: $e');
      throw Exception('Failed to get agents');
    }
  }

  static Future<GetAgent> getAgentInfo(String uid) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('Failed to get  token');
    }

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'authorization': 'Bearer $token'
    };

    var url = Uri.https(Config.apiUrl, '${Config.getAgentsUrl}/$uid');
    var response = await client.get(url, headers: requestHeaders);
<<<<<<< HEAD
    print('API Response: ${response.body}');
=======
    // print('API Response: ${response.body}');
>>>>>>> 80bcbd8 (hehe)
    if (response.statusCode == 200) {
      var agent = getAgentFromJson(response.body);
      return agent;
    } else {
      throw Exception('Failed to get agent info');
    }
  }

  static Future<List<JobsResponse>> getAgentJobs(String uid) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.https(Config.apiUrl, "${Config.jobs}/agent/$uid");
    var response = await client.get(url, headers: requestHeaders);
<<<<<<< HEAD

=======
    print('API Response: ${response.body}');
>>>>>>> 80bcbd8 (hehe)
    if (response.statusCode == 200) {
      var agents = jobsResponseFromJson(response.body);
      return agents;
    } else {
      throw Exception('Failed to get jobs');
    }
  }

  static Future<BookMark?> getBookMark(String jobId) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        return null;
      }

      Map<String, String> requestHeaders = {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token'
      };

      var url = Uri.https(Config.apiUrl, "${Config.singleBookmarkUrl}$jobId");

      var response = await client.get(url, headers: requestHeaders);

      if (response.statusCode == 200) {
        var bookmark = bookMarkFromJson(response.body);
        return bookmark;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
