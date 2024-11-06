import 'dart:convert';

LoginResponseModel loginResponseModelFromJson(String str) => LoginResponseModel.fromJson(json.decode(str));

class LoginResponseModel {
    final String id;
    final String username;
    final String name;
    final String uid;
    final bool updated;
    final bool isAgent;
    final List<dynamic> skills;  // Changed to List<dynamic> to handle both String and bool
    final String profile;
    final String userToken;

    LoginResponseModel({
        required this.id,
        required this.username,
        required this.name,
        required this.uid,
        required this.updated,
        required this.isAgent,
        required this.skills,
        required this.profile,
        required this.userToken,
    });

    factory LoginResponseModel.fromJson(Map<String, dynamic> json) => LoginResponseModel(
        id: json["_id"],
        username: json["username"],
        name: json["name"],
        uid: json["uid"],
        updated: json["updated"],
        isAgent: json["isAgent"],
        skills: List<dynamic>.from(json["skills"]),  // Changed to handle both types
        profile: json["profile"],
        userToken: json["userToken"],
    );
}