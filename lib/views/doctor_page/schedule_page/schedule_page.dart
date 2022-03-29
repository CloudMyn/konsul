// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:konsul/controllers/login_controller.dart';
import 'package:konsul/models/rekam_medis.dart';
import 'package:konsul/models/user.dart';
import 'package:konsul/services/network_handler.dart';
import 'package:konsul/views/components/cardx.dart';
import 'package:konsul/views/components/navbar.dart';
import 'package:konsul/views/patient_page/patient_data_page/patient_data_page.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({Key? key}) : super(key: key);

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      init: LoginController(),
      builder: (LoginController loginController) {
        return Scaffold(
          body: SafeArea(
            child: Flex(
              direction: Axis.vertical,
              children: [
                const Navbar(title: "Jadwal Pasien", marginV: 10),
                Flexible(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 13,
                      vertical: 5,
                    ),
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
    return FutureBuilder<List<dynamic>>(
      future: getSchedule(userLogin.id, apiToken),
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

        if (snapshot.hasError &&
            snapshot.connectionState == ConnectionState.done) {
          return Center(
            child: Text("Terdapat kesalahan dalam pengambilan data!"),
          );
        } else if (snapshot.hasData) {
          List<dynamic> rms = snapshot.data ?? [];

          if (rms.isEmpty) {
            return Center(
              child: Text("Tidak ada data yang bisa ditampilkan!"),
            );
          }

          return listBuilder(rms);
        }

        return Center(
          child: Text("Tidak ada data yang bisa ditampilkan!"),
        );
      },
    );
  }

  ListView listBuilder(List<dynamic> data) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        if (data[index] is RekamMedis) {
          RekamMedis rekamMedis = data[index];
          String tgl = rekamMedis.jadwal;
          String nama = rekamMedis.getPasien.nama;
          String permasalahan = rekamMedis.keluhan_utama;

          return CardX(
            title: "$tgl - $nama",
            status: rekamMedis.status,
            subtitle: "keluhan : $permasalahan}",
            showImage: false,
            onTap: () {
              Get.to(PatientDataPage(pasien: rekamMedis.getPasien));
            },
          );
        }
        return FractionallySizedBox(
          widthFactor: 1,
          child: Padding(
            padding: const EdgeInsets.only(
              bottom: 5,
              top: 5,
              left: 5,
            ),
            child: Text(
              data[index],
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w600,
                color: Color.fromARGB(255, 155, 155, 155),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<List<dynamic>> getSchedule(String doctorId, String apiToken) async {
    List<RekamMedis> patients = await NetworkHandler.getDoctorPatients(
        doctorId, apiToken,
        status: "proses");
    List<dynamic> res = [];

    String prevTgl = "";
    for (RekamMedis p in patients) {
      if (prevTgl != p.jadwal) {
        res.add(p.jadwal);
      }

      res.add(p);
      prevTgl = p.jadwal;
    }
    return res;
  }
}
