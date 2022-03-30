import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:konsul/models/pasien.dart';
import 'package:konsul/models/rekam_medis.dart';

class NetworkHandler {
  static String url = "http://klinik.choicestd.com/";

  // static String url = "http://localhost:8000/api/";

  static Future<Map<String, dynamic>> authLogin(
      String email, String password) async {
    try {
      var uri = Uri.parse(NetworkHandler.url + "api/login");

      var response =
          await http.post(uri, body: {'email': email, 'password': password});

      Map<String, dynamic> body = jsonDecode(response.body);

      if (body['success'] == true) {
        return {
          'success': true,
          'msg': body['message'],
          'user': body['data'],
          'token': body['token'],
        };
      }

      return {
        'success': false,
        'msg': body['message'],
      };
    } catch (e) {
      return {
        'success': false,
        'msg': e.toString(),
      };
    }
  }

  static Future<List<RekamMedis>> getDoctorPatients(
      String doctorId, String token,
      {String status = ""}) async {
    Uri url = Uri.parse(
        NetworkHandler.url + "api/dokter/$doctorId/pasiens?status=proses");

    String except = status.contains(":") ? status.split(":").last : "";

    Map<String, String> headers = {
      'Authorization': "Bearer $token",
    };

    List<RekamMedis> rms = [];

    try {
      var response = await http.get(url, headers: headers);

      Map<String, dynamic> data = jsonDecode(response.body);

      if (data['success'] == true) {
        for (var dataRM in data['data']) {
          debugPrint("start-loop");

          RekamMedis rm = RekamMedis.fromJSON(dataRM);

          if (status == "" || rm.status.toLowerCase() == status.toLowerCase()) {
            // debugPrint('asasas');
            rms.add(rm);
          } else if (rm.status.toLowerCase() != except.toLowerCase() &&
              except != "") {
            // debugPrint('bsssss');
            rms.add(rm);
          }
          // debugPrint('test11');
        }
      }

      return rms;
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
      return rms;
    }
  }

  static Future<Pasien> getPasienData(String userId, String token) async {
    try {
      var uri = Uri.parse(NetworkHandler.url + "api/user/$userId/pasien");

      Map<String, String> headers = {
        'Authorization': "Bearer $token",
      };

      var response = await http.get(uri, headers: headers);

      debugPrint(response.statusCode.toString());

      Map<String, dynamic> body = jsonDecode(response.body);

      if (body['success'] == true) {
        return Pasien.fromJson(body['data']);
      }

      throw Exception(
          body['message'] ?? "Terjadi kesalahan di api getPasienData");
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  static Future<void> storeFCMToken(
      String userId, String token, String deviceToken) async {
    try {
      var uri = Uri.parse(NetworkHandler.url + "api/user/$userId/save-token");

      Map<String, String> headers = {
        'Authorization': "Bearer $token",
      };

      var response = await http.post(uri, headers: headers, body: {
        'fcm_token': deviceToken,
      });

      debugPrint(response.statusCode.toString());

      Map<String, dynamic> body = jsonDecode(response.body);

      if (body['success'] == false) {
        throw Exception(
            body['error'] ?? "Terjadi kesalahan di api storeFCMToken");
      }
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  static Future<List<RekamMedis>> getRmPasien(
      String pasienId, String token) async {
    try {
      Map<String, String> headers = {
        'Authorization': "Bearer $token",
      };

      var uri = Uri.parse(NetworkHandler.url + "api/rm/list_pasien/$pasienId");

      List<RekamMedis> rms = [];

      var response = await http.get(uri, headers: headers);

      Map<String, dynamic> body = jsonDecode(response.body);

      if (body['success'] == true) {
        for (var data in body['data']) {
          RekamMedis rm = RekamMedis.fromJSON(data);
          rms.add(rm);
        }

        return rms;
      }

      throw Exception(
          body['message'] ?? "Terjadi kesalahan di api getRmPasien");
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}

// API

// GET: /dokter/{id}/rm-pasiens -> untuk mendapatkan daftar rekam medis pasien berdasarkan id dokter
// GET: /rm/{id}/pasien -> untuk mendapatkan data pasien berdasarkan id rekam medis
// GET: /rm/{id}/dokter -> untuk mendapatkan data dokter berdasarkan id rekam medis
