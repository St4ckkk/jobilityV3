import 'dart:convert';

String createJobsRequestToJson(CreateJobsRequest data) => json.encode(data.toJson());

class CreateJobsRequest {
    CreateJobsRequest({
        required this.title,
        required this.location,
        required this.company,
        required this.hiring,
        required this.description,
        required this.salary,
        required this.period,
        required this.contract,
        required this.imageUrl,
        required this.agentId,
        required this.agentName,
        required this.requirements,
<<<<<<< HEAD
=======
        required this.acceptedDisabilities,
>>>>>>> 80bcbd8 (hehe)
    });

    final String title;
    final String location;
    final String company;
    final bool hiring;
    final String description;
    final String salary;
    final String period;
    final String contract;
    final String imageUrl;
    final String agentId;
    final String agentName;
    final List<String> requirements;
<<<<<<< HEAD
=======
    final List<AcceptedDisability> acceptedDisabilities;
>>>>>>> 80bcbd8 (hehe)

    Map<String, dynamic> toJson() => {
        "title": title,
        "location": location,
        "company": company,
        "hiring": hiring,
        "description": description,
        "salary": salary,
        "period": period,
        "contract": contract,
        "imageUrl": imageUrl,
        "agentId": agentId,
        "agentName": agentName,
        "requirements": List<dynamic>.from(requirements.map((x) => x)),
<<<<<<< HEAD
=======
        "acceptedDisabilities": List<dynamic>.from(acceptedDisabilities.map((x) => x.toJson())),
    };
}

class AcceptedDisability {
    AcceptedDisability({
        required this.type,
        required this.specificNames,
    });

    final String type;
    final List<String> specificNames;

    Map<String, dynamic> toJson() => {
        "type": type,
        "specificNames": List<dynamic>.from(specificNames.map((x) => x)),
>>>>>>> 80bcbd8 (hehe)
    };
}
