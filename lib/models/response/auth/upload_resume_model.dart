import 'dart:convert';

UploadResumeRes uploadResumeResFromJson(String str) => UploadResumeRes.fromJson(json.decode(str));

String uploadResumeResToJson(UploadResumeRes data) => json.encode(data.toJson());

class UploadResumeRes {
  String id;
  String resume;

  UploadResumeRes({
    required this.id,
    required this.resume,
  });

  factory UploadResumeRes.fromJson(Map<String, dynamic> json) => UploadResumeRes(
    id: json["_id"],
    resume: json["resume"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "resume": resume,
  };
}