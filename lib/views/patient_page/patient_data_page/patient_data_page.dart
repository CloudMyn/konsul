// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:konsul/models/pasien.dart';
import 'package:konsul/views/components/navbar.dart';
import 'package:konsul/views/components/profile_section.dart';

class PatientDataPage extends StatelessWidget {
  final Pasien pasien;
  final String? jadwal;

  const PatientDataPage({
    Key? key,
    required this.pasien,
    this.jadwal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Flex(
          direction: Axis.vertical,
          children: [
            Navbar(title: "Data Pasien", marginV: 5),
            Flexible(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 5,
                  vertical: 5,
                ),
                child: ListView(
                  children: [
                    ProfileSection(pasien.user),
                    Center(
                      child: Container(
                        width: size.width * 0.87,
                        margin: EdgeInsetsDirectional.only(bottom: 20),
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 15,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(7),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 0,
                              blurRadius: 10,
                              offset: const Offset(
                                  0, 2), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            textField(
                              label: "Nama",
                              value: pasien.nama,
                            ),
                            textField(
                              label: "Alamat",
                              value: pasien.alamat,
                            ),
                            textField(
                              label: "Tanggal Lahir",
                              value: pasien.tgl_lahir,
                            ),
                            textField(
                              label: "Nomor HP",
                              value: pasien.hp,
                            ),
                            textField(
                              label: "Jenis Kelamin",
                              value: pasien.kelamin,
                            ),
                            textField(
                              label: "No. BPJS",
                              value: pasien.no_bpjs,
                            ),
                            textField(
                              label: "Pend. Terahkir",
                              value: pasien.pendidikan,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget textField({
    required String label,
    String? hint,
    required String value,
    Widget? iconData,
    bool? visibility,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: TextEditingController(text: value),
        readOnly: true,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          border: const OutlineInputBorder(),
          labelText: label,
          hintText: hint,
          suffixIcon: iconData,
        ),
      ),
    );
  }
}
