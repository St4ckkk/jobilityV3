import 'dart:convert';

GetResume getResumeFromJson(String str) => GetResume.fromJson(json.decode(str));

String getResumeToJson(GetResume data) => json.encode(data.toJson());

class GetResume {
  bool status;
  String resume;

  GetResume({
    required this.status,
    required this.resume,
  });

  factory GetResume.fromJson(Map<String, dynamic> json) {
    return GetResume(
      status: json["status"] ?? false,
      resume: json["resume"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "status": status,
    "resume": resume,
  };
}
