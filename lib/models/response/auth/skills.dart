import 'dart:convert';

List<Skills> skillsFromJson(String str) {
    print("Raw skills JSON string: $str"); // Debug raw response
    try {
        final decoded = json.decode(str);
        print("Decoded skills JSON: $decoded"); // Debug decoded JSON

        // Check if the response is wrapped in a data property
        final List<dynamic> skillsList = decoded is Map ?
        (decoded['data'] ?? decoded['skills'] ?? decoded) : decoded;

        print("Skills list to process: $skillsList"); // Debug the list we're about to process

        if (skillsList is! List) {
            throw FormatException("Expected a List but got ${skillsList.runtimeType}");
        }

        return List<Skills>.from(
            skillsList.map((x) {
                print("Processing skill item: $x"); // Debug individual skill processing
                return Skills.fromJson(x);
            })
        );
    } catch (e, stackTrace) {
        print("Error parsing skills JSON: $e");
        print("Stack trace: $stackTrace");
        rethrow;
    }
}

class Skills {
    final String id;
    final String skill;

    Skills({
        required this.id,
        required this.skill,
    });

    factory Skills.fromJson(Map<String, dynamic> json) {
        try {
            return Skills(
                id: json["_id"] ?? json["id"] ?? '', // Handle both _id and id
                skill: json["skill"] ?? '',
            );
        } catch (e) {
            print("Error creating Skills object from JSON: $e");
            print("Problematic JSON: $json");
            rethrow;
        }
    }

    Map<String, dynamic> toJson() => {
        "_id": id,
        "skill": skill,
    };

    @override
    String toString() => 'Skills(id: $id, skill: $skill)'; // Helpful for debugging
}