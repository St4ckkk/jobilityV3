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
  String pwdIdImage; // New field for pwdIdImage
  List<Education> education; // New field for education
  List<Experience> experience; // New field for experience

  ProfileUpdate({
    required this.id,
    required this.username,
    required this.name,
    required this.email,
    required this.skills,
    required this.profile, // Change profileImage to profile
    required this.pwdIdImage, // New field for pwdIdImage
    required this.education, // New field for education
    required this.experience, // New field for experience
  });

  factory ProfileUpdate.fromJson(Map<String, dynamic> json) => ProfileUpdate(
    id: json["id"],
    username: json["username"],
    name: json["name"],
    email: json["email"],
    skills: List<String>.from(json["skills"].map((x) => x)),
    profile: json["profile"], // Change profileImage to profile
    pwdIdImage: json["pwdIdImage"], // New field for pwdIdImage
    education: List<Education>.from(json["education"].map((x) => Education.fromJson(x))), // New field for education
    experience: List<Experience>.from(json["experience"].map((x) => Experience.fromJson(x))), // New field for experience
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "name": name,
    "email": email,
    "skills": List<dynamic>.from(skills.map((x) => x)),
    "profile": profile, // Change profileImage to profile
    "pwdIdImage": pwdIdImage, // New field for pwdIdImage
    "education": List<dynamic>.from(education.map((x) => x.toJson())), // New field for education
    "experience": List<dynamic>.from(experience.map((x) => x.toJson())), // New field for experience
  };
}

class Education {
  String institution;
  String degree;
  String fieldOfStudy;
  String startDate;
  String endDate;

  Education({
    required this.institution,
    required this.degree,
    required this.fieldOfStudy,
    required this.startDate,
    required this.endDate,
  });

  factory Education.fromJson(Map<String, dynamic> json) => Education(
    institution: json["institution"],
    degree: json["degree"],
    fieldOfStudy: json["fieldOfStudy"],
    startDate: json["startDate"],
    endDate: json["endDate"],
  );

  Map<String, dynamic> toJson() => {
    "institution": institution,
    "degree": degree,
    "fieldOfStudy": fieldOfStudy,
    "startDate": startDate,
    "endDate": endDate,
  };
}

class Experience {
  String company;
  String position;
  String startDate;
  String endDate;
  String? description;

  Experience({
    required this.company,
    required this.position,
    required this.startDate,
    required this.endDate,
    this.description,
  });

  factory Experience.fromJson(Map<String, dynamic> json) => Experience(
    company: json["company"],
    position: json["position"],
    startDate: json["startDate"],
    endDate: json["endDate"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "company": company,
    "position": position,
    "startDate": startDate,
    "endDate": endDate,
    "description": description,
  };
}