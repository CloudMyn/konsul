import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:konsul/controllers/login_controller.dart';
import 'package:konsul/models/pasien.dart';
import 'package:konsul/models/rekam_medis.dart';
import 'package:konsul/models/user.dart';
import 'package:konsul/services/network_handler.dart';
import 'package:konsul/views/components/cardx.dart';
import 'package:konsul/views/components/navbar.dart';

class ConsultsPage extends StatefulWidget {
  const ConsultsPage({Key? key}) : super(key: key);

  @override
  State<ConsultsPage> createState() => _ConsultsPageState();
}

class _ConsultsPageState extends State<ConsultsPage> {
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
                const Navbar(title: "Riwayat Konsultasi", marginV: 10),
                Flexible(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 13,
                      vertical: 5,
                    ),
                    child: cardsBuilder(
                        loginController.authUser(), loginController),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget cardsBuilder(User userLogin, LoginController controller) {
    return FutureBuilder<List<dynamic>>(
      future: getRiwayatKonsultasi(userLogin.id, controller.getAuthToken()),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.connectionState == ConnectionState.none) {
          return const Center(
            child: Text("Tidak ada koneksi ke server!"),
          );
        }

        if (snapshot.hasError &&
            snapshot.connectionState == ConnectionState.done) {
          return const Center(
            child: Text("Terdapat kesalahan dalam pengambilan data!"),
          );
        } else if (snapshot.hasData) {
          List<dynamic> rms = snapshot.data ?? [];

          if (rms.isEmpty) {
            return const Center(
              child: Text("Tidak ada data yang bisa ditampilkan!"),
            );
          }

          return listBuilder(rms);
        }

        return const Center(
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
          String nama = rekamMedis.getDokter.name;
          String permasalahan = rekamMedis.keluhan_utama;

          return CardX(
            image: rekamMedis.getDokter.getAvatarURL(),
            title: "Keluhan $permasalahan",
            status: rekamMedis.status,
            subtitle: "Oleh Dr. ${nama.capitalize} - $tgl",
            onTap: () {},
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
              style: const TextStyle(
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

  Future<List<RekamMedis>> getRiwayatKonsultasi(
      String userId, String token) async {
    Pasien pasien = await NetworkHandler.getPasienData(userId, token);
    return await NetworkHandler.getRmPasien(pasien.id, token);
  }
}
