import 'package:konsul/models/user.dart';

class Pasien {
  final String id,
      id_user,
      nama,
      tgl_lahir,
      kelamin,
      alamat,
      hp,
      pendidikan,
      pekerjaan,
      no_bpjs,
      alergi,
      created_at,
      updated_at;

  final User user;

  Pasien(
    this.id, {
    required this.id_user,
    required this.nama,
    required this.tgl_lahir,
    required this.kelamin,
    required this.alamat,
    required this.hp,
    required this.pendidikan,
    required this.pekerjaan,
    this.no_bpjs = "-",
    this.alergi = '-',
    required this.created_at,
    required this.updated_at,
    required this.user,
  });

  factory Pasien.fromJson(Map<String, dynamic> json) {
    return Pasien(
      json['id'].toString(),
      id_user: json['id_user'].toString(),
      nama: json['nama'],
      tgl_lahir: json['tgl_lhr'],
      kelamin: json['jk'] ?? '-',
      alamat: json['alamat'] ?? '-',
      hp: json['hp'] ?? '-',
      pendidikan: json['pendidikan'],
      pekerjaan: json['pekerjaan'],
      no_bpjs: json['no_bpjs']?.toString() ?? '-',
      alergi: json['alergi'] ?? '-',
      created_at: json['created_time'] ?? '-',
      updated_at: json['updated_time'] ?? '-',
      user: User.fromJson(json['user']),
    );
  }
}
