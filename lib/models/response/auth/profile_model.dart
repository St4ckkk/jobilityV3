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
        this.resume,
        this.education,  // New field for education
        this.experience, // New field for experience
        this.certifications, // New field for certifications
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
    final String? resume;
    final List<Education>? education; // Nullable list of education
    final List<Experience>? experience; // Nullable list of experience
    final List<Certification>? certifications; // Nullable list of certifications

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
                resume: json["resume"],
                education: json["education"] != null
                    ? List<Education>.from(json["education"].map((x) => Education.fromJson(x)))
                    : null,
                experience: json["experience"] != null
                    ? List<Experience>.from(json["experience"].map((x) => Experience.fromJson(x)))
                    : null,
                certifications: json["certifications"] != null
                    ? List<Certification>.from(json["certifications"].map((x) => Certification.fromJson(x)))
                    : null,
            );
        } catch (e) {
            print("Error in ProfileRes.fromJson: $e"); // Debug print
            rethrow;
        }
    }
}

class Education {
    Education({
        required this.institution,
        required this.degree,
        required this.fieldOfStudy,
        required this.startDate,
        required this.endDate,
    });

    final String institution;
    final String degree;
    final String fieldOfStudy;
    final DateTime startDate;
    final DateTime endDate;

    factory Education.fromJson(Map<String, dynamic> json) => Education(
        institution: json["institution"] ?? '',
        degree: json["degree"] ?? '',
        fieldOfStudy: json["fieldOfStudy"] ?? '',
        startDate: DateTime.parse(json["startDate"]),
        endDate: DateTime.parse(json["endDate"]),
    );
}

class Experience {
    Experience({
        required this.company,
        required this.position,
        required this.startDate,
        required this.endDate,
        this.description,
    });

    final String company;
    final String position;
    final DateTime startDate;
    final DateTime endDate;
    final String? description;

    factory Experience.fromJson(Map<String, dynamic> json) => Experience(
        company: json["company"] ?? '',
        position: json["position"] ?? '',
        startDate: DateTime.parse(json["startDate"]),
        endDate: DateTime.parse(json["endDate"]),
        description: json["description"],
    );
}

class Certification {
    Certification({
        required this.name,
        required this.issuingOrganization,
        required this.issueDate,
        this.expirationDate,
    });

    final String name;
    final String issuingOrganization;
    final DateTime issueDate;
    final DateTime? expirationDate;

    factory Certification.fromJson(Map<String, dynamic> json) => Certification(
        name: json["name"] ?? '',
        issuingOrganization: json["issuingOrganization"] ?? '',
        issueDate: DateTime.parse(json["issueDate"]),
        expirationDate: json["expirationDate"] != null ? DateTime.parse(json["expirationDate"]) : null,
    );
}