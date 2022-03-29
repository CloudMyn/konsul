import 'package:flutter/cupertino.dart';
import 'package:konsul/models/pasien.dart';
import 'package:konsul/models/user.dart';

class RekamMedis {
  final String id,
      idpasien,
      keluhan_utama,
      gigi,
      diagnosis,
      jadwal,
      status,
      created_at,
      updated_at;

  final Pasien? pasien;
  final User? dokter;

  RekamMedis({
    required this.id,
    required this.idpasien,
    required this.keluhan_utama,
    required this.gigi,
    required this.diagnosis,
    required this.jadwal,
    required this.status,
    required this.created_at,
    required this.updated_at,
    required this.pasien,
    required this.dokter,
  });

  factory RekamMedis.fromJSON(Map<String, dynamic> data) {
    User? dokter;
    Pasien? pasien;

    debugPrint("Rm.fromJson");

    if (data.containsKey('dokter')) {
      if (data['dokter'] is Map) dokter = User.fromJson(data['dokter']);
      debugPrint("User.fromJson");
    }

    if (data.containsKey('pasien')) {
      pasien = Pasien.fromJson(data['pasien']);
      debugPrint("Pasien.fromJson");
    }

    return RekamMedis(
      id: data['id'].toString(),
      idpasien: data['idpasien'].toString(),
      keluhan_utama: data['ku'] ?? '-',
      gigi: data['gigi'] ?? '-',
      diagnosis: data['diagnosis'] ?? '-',
      dokter: dokter,
      pasien: pasien,
      jadwal: data['konsul'],
      status: data['status'],
      created_at: data['created_time'],
      updated_at: data['updated_time'],
    );
  }

  Pasien get getPasien {
    if (pasien == null) {
      throw Exception("Data model pasien tidak tersedia!");
    }

    return pasien!;
  }

  User get getDokter {
    if (dokter == null) {
      throw Exception("Data model dokter tidak tersedia!");
    }

    return dokter!;
  }
}
