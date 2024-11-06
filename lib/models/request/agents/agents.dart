import 'dart:convert';

class AgentsResponse {
    final List<Agents> agents;

    AgentsResponse({required this.agents});

    factory AgentsResponse.fromJson(Map<String, dynamic> json) {
        return AgentsResponse(
            agents: (json['agents'] as List<dynamic>)
                .map((x) => Agents.fromJson(x as Map<String, dynamic>))
                .toList(),
        );
    }
}

List<Agents> agentsFromJson(String str) {
    final Map<String, dynamic> parsed = json.decode(str);
    if (parsed['agents'] is List) {
        return (parsed['agents'] as List)
            .map((x) => Agents.fromJson(x as Map<String, dynamic>))
            .toList();
    }
    throw FormatException('Invalid JSON format for agents');
}

class Agents {
    final String name;
    final String uid;
    final String profile;

    Agents({
        required this.name,
        required this.uid,
        required this.profile,
    });

    factory Agents.fromJson(Map<String, dynamic> json) => Agents(
        name: json["name"] ?? '',  // Changed "name" to "username" to match JSON key
        uid: json["uid"] ?? '',
        profile: json["profile"] ?? '',
    );
}
