import 'dart:convert';

List<JobAlert> jobAlertFromJson(String str) => List<JobAlert>.from(json.decode(str).map((x) => JobAlert.fromJson(x)));

String jobAlertToJson(List<JobAlert> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class JobAlert {
  String id;
  String userId;
  JobId jobId;
  bool notified;
  int v;
  DateTime createdAt;
  DateTime updatedAt;

  JobAlert({
    required this.id,
    required this.userId,
    required this.jobId,
    required this.notified,
    required this.v,
    required this.createdAt,
    required this.updatedAt,
  });

  factory JobAlert.fromJson(Map<String, dynamic> json) => JobAlert(
    id: json["_id"],
    userId: json["userId"],
    jobId: JobId.fromJson(json["jobId"]),
    notified: json["notified"],
    v: json["__v"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "userId": userId,
    "jobId": jobId.toJson(),
    "notified": notified,
    "__v": v,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
  };
}

class JobId {
  String id;
  String title;
  String location;
  String company;
  String salary;
  String description;
  String agentName;
  String period;
  String contract;
  bool hiring;
  List<String> requirements;
  String imageUrl;
  String agentId;
  List<AcceptedDisability> acceptedDisabilities;

  JobId({
    required this.id,
    required this.title,
    required this.location,
    required this.company,
    required this.salary,
    required this.description,
    required this.agentName,
    required this.period,
    required this.contract,
    required this.hiring,
    required this.requirements,
    required this.imageUrl,
    required this.agentId,
    required this.acceptedDisabilities,
  });

  factory JobId.fromJson(Map<String, dynamic> json) => JobId(
    id: json["_id"],
    title: json["title"],
    location: json["location"],
    company: json["company"],
    salary: json["salary"],
    description: json["description"],
    agentName: json["agentName"],
    period: json["period"],
    contract: json["contract"],
    hiring: json["hiring"],
    requirements: List<String>.from(json["requirements"].map((x) => x)),
    imageUrl: json["imageUrl"],
    agentId: json["agentId"],
    acceptedDisabilities: List<AcceptedDisability>.from(json["acceptedDisabilities"].map((x) => AcceptedDisability.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "title": title,
    "location": location,
    "company": company,
    "salary": salary,
    "description": description,
    "agentName": agentName,
    "period": period,
    "contract": contract,
    "hiring": hiring,
    "requirements": List<dynamic>.from(requirements.map((x) => x)),
    "imageUrl": imageUrl,
    "agentId": agentId,
    "acceptedDisabilities": List<dynamic>.from(acceptedDisabilities.map((x) => x.toJson())),
  };
}

class AcceptedDisability {
  String type;
  List<String> specificNames;
  String id;

  AcceptedDisability({
    required this.type,
    required this.specificNames,
    required this.id,
  });

  factory AcceptedDisability.fromJson(Map<String, dynamic> json) => AcceptedDisability(
    type: json["type"],
    specificNames: List<String>.from(json["specificNames"].map((x) => x)),
    id: json["_id"],
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "specificNames": List<dynamic>.from(specificNames.map((x) => x)),
    "_id": id,
  };
}