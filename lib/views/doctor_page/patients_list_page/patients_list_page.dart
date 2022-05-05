// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:konsul/controllers/login_controller.dart';
import 'package:konsul/models/pasien.dart';
import 'package:konsul/models/rekam_medis.dart';
import 'package:konsul/models/user.dart';
import 'package:konsul/views/components/cardx.dart';
import 'package:konsul/views/components/navbar.dart';
import 'package:konsul/views/doctor_page/patients_list_page/controller/patients_list_controller.dart';
import 'package:konsul/views/patient_page/patient_data_page/patient_data_page.dart';

class PatientsListPage extends StatelessWidget {
  final String patienStatus;
  final String pageTitle;

  const PatientsListPage(
      {Key? key, this.patienStatus = "", required this.pageTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      init: LoginController(),
      builder: (loginController) {
        return Scaffold(
          body: SafeArea(
            child: Flex(
              direction: Axis.vertical,
              children: [
                Navbar(title: pageTitle, marginV: 10),
                Flexible(
                  flex: 1,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 13, vertical: 5),
                    child: cardsBuilder(
                      loginController.authUser(),
                      loginController.getAuthToken(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget cardsBuilder(User userLogin, String apiToken) {
    return GetBuilder<PatientsListController>(
      init: PatientsListController(),
      builder: (pcontroller) {
        return FutureBuilder<List<RekamMedis>>(
          future:
              pcontroller.getDoctorPatients(userLogin, patienStatus, apiToken),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.connectionState == ConnectionState.none) {
              return Center(
                child: Text("Tidak ada koneksi ke server!"),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text("Terdapat kesalahan dalam pengambilan data!"),
              );
            } else if (snapshot.hasData) {
              List<RekamMedis> rms = snapshot.data ?? [];

              if (rms.isEmpty) {
                return Center(
                  child: Text("Tidak ada data yang bisa ditampilkan!"),
                );
              }

              return ListView.builder(
                itemCount: rms.length,
                itemBuilder: (context, index) {
                  RekamMedis rekamMedis = rms[index];
                  Pasien pasien = rekamMedis.getPasien;
                  return CardX(
                    title: pasien.nama,
                    status: rekamMedis.status,
                    subtitle: "keluhan: ${rekamMedis.keluhan_utama}",
                    image: pasien.user.getAvatarURL(),
                    onTap: () {
                      Get.to(PatientDataPage(pasien: rekamMedis.getPasien));
                    },
                  );
                },
              );
            }

            return Center(
              child: Text("Tidak ada data yang bisa ditampilkan!"),
            );
          },
        );
      },
    );
  }
}
