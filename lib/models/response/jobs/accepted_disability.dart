// accepted_disability.dart
import 'dart:convert';

// accepted_disability.dart
class AcceptedDisability {
  String type;
  List<String> specificNames;

  AcceptedDisability({
    required this.type,
    required this.specificNames,
  });

  factory AcceptedDisability.fromJson(Map<String, dynamic> json) => AcceptedDisability(
    type: json["type"],
    specificNames: List<String>.from(json["specificNames"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "specificNames": List<dynamic>.from(specificNames.map((x) => x)),
  };
}