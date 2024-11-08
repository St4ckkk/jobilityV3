import 'dart:convert';

ProfileRes profileResFromJson(String str) {
    final decoded = json.decode(str);
    return ProfileRes.fromJson(decoded);
}

class ProfileRes {
    ProfileRes({
        required this.id,
        required this.username,
        required this.name,
        required this.email,
        required this.isAdmin,
        required this.isAgent,
        required this.skills,
        required this.profile,
        this.disability,  // Made optional since it's not required in MongoDB
        this.pwdIdImage,  // Made optional since it's not required in MongoDB
    });

    final String id;
    final String username;
    final String name;
    final String email;
    final bool isAdmin;
    final bool isAgent;
    final List<dynamic> skills;
    final String profile;
    final String? disability;  // Nullable String since it's optional
    final String? pwdIdImage;  // Nullable String since it's optional

    factory ProfileRes.fromJson(Map<String, dynamic> json) {
        try {
            return ProfileRes(
                id: json["_id"] ?? '',
                username: json["username"] ?? '',
                name: json["name"] ?? '',
                email: json["email"] ?? '',
                isAdmin: json["isAdmin"] ?? false,
                isAgent: json["isAgent"] ?? false,
                skills: json['skills'] is List ? json['skills'] : [],
                profile: json["profile"] ?? '',
                disability: json["disability"],  // No default value needed since it's nullable
                pwdIdImage: json["pwdIdImage"],  // No default value needed since it's nullable
            );
        } catch (e) {
            print("Error in ProfileRes.fromJson: $e"); // Debug print
            rethrow;
        }
    }
}