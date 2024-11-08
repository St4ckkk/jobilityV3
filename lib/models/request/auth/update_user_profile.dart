import 'dart:convert';

// To parse this JSON data, do
//
//     final profileUpdate = profileUpdateFromJson(jsonString);

ProfileUpdate profileUpdateFromJson(String str) => ProfileUpdate.fromJson(json.decode(str));

String profileUpdateToJson(ProfileUpdate data) => json.encode(data.toJson());

class ProfileUpdate {
  String id;
  String username;
  String name;
  String email;
  List<String> skills;
  String profile; // Change profileImage to profile

  ProfileUpdate({
    required this.id,
    required this.username,
    required this.name,
    required this.email,
    required this.skills,
    required this.profile, // Change profileImage to profile
  });

  factory ProfileUpdate.fromJson(Map<String, dynamic> json) => ProfileUpdate(
    id: json["id"],
    username: json["username"],
    name: json["name"],
    email: json["email"],
    skills: List<String>.from(json["skills"].map((x) => x)),
    profile: json["profile"], // Change profileImage to profile
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "name": name,
    "email": email,
    "skills": List<dynamic>.from(skills.map((x) => x)),
    "profile": profile, // Change profileImage to profile
  };
}