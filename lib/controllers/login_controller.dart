import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:konsul/models/pasien.dart';
import 'package:konsul/models/user.dart';
import 'package:konsul/services/network_handler.dart';
import 'package:konsul/views/doctor_page/profile_page/profile_page.dart'
    as doctor;
import 'package:konsul/views/patient_page/profile_page/profile_page.dart'
    as patient;
import 'package:konsul/views/login_page/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  // final Rx<TextEditingController> email =
  //     TextEditingController(text: 'ryuzhen@gmail.com').obs;
  // final Rx<TextEditingController> password =
  //     TextEditingController(text: 'password').obs;

  final Rx<TextEditingController> email = TextEditingController(text: '').obs;
  final Rx<TextEditingController> password =
      TextEditingController(text: '').obs;

  final RxBool rememberMe = false.obs;

  AuthState authState = UnAuthenticated();

  Rx<ValidationError>? validationError;

  Future<bool> attemptRememberLogin() async {
    final prefs = await SharedPreferences.getInstance();

    bool hasData = prefs.containsKey('login_data');

    if (hasData) {
      String? json = prefs.getString('login_data');

      if (json != null) {
        Map<String, dynamic> loginData = jsonDecode(json);
        email.value.text = loginData['email'];
        password.value.text = loginData['password'];

        debugPrint("Login-data yang tersimpan");
        debugPrint(json);

        await login();

        return true;
      }
    }

    return false;
  }

  Future<void> login() async {
    String _email = email.value.text;
    String _password = password.value.text;

    Map<String, dynamic> response = await NetworkHandler.authLogin(
      _email,
      _password,
    );

    if (response['success'] == false) {
      validationError = ValidationError(response['msg']).obs;
    } else {
      validationError = null;

      User user = User.fromJson(response['user']);

      // store fcm-device token
      String deviceToken =
          await FirebaseMessaging.instance.getToken() ?? 'none';

      NetworkHandler.storeFCMToken(user.id, response['token'], deviceToken);

      if (rememberMe.value == true) {
        final prefs = await SharedPreferences.getInstance();
        Map<String, dynamic> loginData = {
          'email': _email,
          'password': _password,
        };

        if (prefs.containsKey('login_data')) {
          prefs.remove('login_data');
        }

        prefs.setString('login_data', jsonEncode(loginData));
        debugPrint('login-tersimpan');
      }

      authState = Authenticated(
        user,
        response['token'],
      );

      if (user.role == UserRole.doctor) {
        Get.off(doctor.ProfilePage());
      } else if (user.role == UserRole.pasien) {
        Pasien pasien =
            await NetworkHandler.getPasienData(user.id, response['token']);

        Get.off(patient.ProfilePage(pasien: pasien));
      }
    }

    update();
  }

  Future<void> logout() async {
    authState = UnAuthenticated();

    final prefs = await SharedPreferences.getInstance();

    bool hasData = prefs.containsKey('login_data');

    if (hasData) {
      prefs.remove('login_data');
    }

    Get.off(LoginPage());
  }

  bool isLogin() {
    return authState is Authenticated ? false : true;
  }

  User authUser() {
    AuthState state = authState;
    User? authUser;

    if (state is Authenticated) {
      authUser = state.user;
    } else {
      Get.off(LoginPage());
    }

    return authUser!;
  }

  String getAuthToken() {
    AuthState state = authState;
    if (state is Authenticated) {
      return state.api_token;
    } else {
      Get.off(LoginPage());
      return "";
    }
  }
}

class ValidationError {
  final String message;

  ValidationError(this.message);
}

class AuthState {}

class UnAuthenticated extends AuthState {}

class Authenticated extends AuthState {
  final String api_token;
  final User user;

  Authenticated(this.user, this.api_token);
}
