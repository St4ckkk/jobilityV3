import 'dart:convert';

GetAgent getAgentFromJson(String str) => GetAgent.fromJson(json.decode(str));

class GetAgent {
    final String id;
    final String userId;
    final String uid;
    final String company;
    final String hqAddress;
    final String workingHrs;
    final DateTime createdAt;

    GetAgent({
        required this.id,
        required this.userId,
        required this.uid,
        required this.company,
        required this.hqAddress,
        required this.workingHrs,
        required this.createdAt,
    });

    factory GetAgent.fromJson(Map<String, dynamic> json) {
        return GetAgent(
            id: json["_id"] ?? 'unknown_id',
            userId: json["userId"] ?? 'unknown_user',
            uid: json["uid"] ?? 'unknown_uid',
            company: json["company"] ?? 'unknown_company',
            hqAddress: json["hq_address"] ?? 'unknown_address',
            workingHrs: json["working_hrs"] ?? 'unknown_hours',
            createdAt: json["createdAt"] != null
                ? DateTime.parse(json["createdAt"])
                : DateTime.now(),
        );
    }
}
