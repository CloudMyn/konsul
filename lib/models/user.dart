import 'package:flutter/cupertino.dart';
import 'package:konsul/services/network_handler.dart';

enum UserRole { doctor, pasien }

class User {
  final String id, name, username, email, avatar;
  final UserRole role;

  User({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.avatar,
    required this.role,
  });

  String getInitial() {
    String initial = "";
    for (String word in name.split(" ")) {
      initial += word[0];
    }

    return initial.toUpperCase();
  }

  factory User.fromJson(Map<String, dynamic> user) {
    UserRole role = user['profesi'].toString().toLowerCase() == "dokter"
        ? UserRole.doctor
        : UserRole.pasien;

    return User(
      id: user['id'].toString(),
      name: user['name'],
      username: user['username'],
      email: user['email'],
      avatar: user['avatar'],
      role: role,
    );
  }

  String capitalize(String str) {
    return str[0].toUpperCase() + str.substring(1).toLowerCase();
  }

  String getAvatarURL() {
    return NetworkHandler.url + "storage/app/public/avatars/" + avatar;
  }
}
