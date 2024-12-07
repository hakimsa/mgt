// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

//User userFromJson(String str) => User.fromJson(json.decode(str));

//String userToJson(User data) => json.encode(data.toJson());
List<User> usersModelFromJson(String str) =>
    List<User>.from(json.decode(str).map((x) => User.fromJson(x)));

String usersModelToJson(List<User> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class User {
  int id;
  String email;
  String firstname;
  String lastname;
  String avatar;
  String addess;
  int age;
  String description;
  String nacion;
  String role;
  String telefon;
  String token;
  String password;
  String formacion;
  String lenguage;
  String redes;

  User({
    required this.id,
    required this.email,
    required this.firstname,
    required this.lastname,
    required this.avatar,
    required this.addess,
    required this.age,
    required this.description,
    required this.nacion,
    required this.role,
    required this.telefon,
    required this.token,
    required this.password,
    required this.formacion,
    required this.lenguage,
    required this.redes,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        email: json["email"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        avatar: json["avatar"],
        addess: json["addess"],
        age: json["age"],
        description: json["description"],
        nacion: json["nacion"],
        role: json["role"],
        telefon: json["telefon"],
        token: json["token"],
        password: json["password"],
        formacion: json["formacion"],
        lenguage: json["lenguage"],
        redes: json["redes"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "firstname": firstname,
        "lastname": lastname,
        "avatar": avatar,
        "addess": addess,
        "age": age,
        "description": description,
        "nacion": nacion,
        "role": role,
        "telefon": telefon,
        "token": token,
        "password": password,
        "formacion": formacion,
        "lenguage": lenguage,
        "redes": redes,
      };
}
