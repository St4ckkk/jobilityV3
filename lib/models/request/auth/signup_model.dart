import 'dart:convert';

SignupModel signupModelFromJson(String str) => SignupModel.fromJson(json.decode(str));

String signupModelToJson(SignupModel data) => json.encode(data.toJson());

class SignupModel {
    SignupModel({
        required this.name,
        required this.username,
        required this.email,
        required this.password,
    });
    final String name;
    final String username;
    final String email;
    final String password;

    factory SignupModel.fromJson(Map<String, dynamic> json) => SignupModel(
        name: json["name"],
        username: json["username"],
        email: json["email"],
        password: json["password"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "username": username,
        "email": email,
        "password": password,
    };
}
