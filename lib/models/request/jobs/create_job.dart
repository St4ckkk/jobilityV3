// create_job.dart
import 'dart:convert';

import '../../response/jobs/accepted_disability.dart';


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
        required this.acceptedDisabilities,
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
    final List<AcceptedDisability> acceptedDisabilities;

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
        "acceptedDisabilities": List<dynamic>.from(acceptedDisabilities.map((x) => x.toJson())),
    };
}