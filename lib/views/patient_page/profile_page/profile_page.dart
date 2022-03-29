// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:konsul/configs/colors.dart';
import 'package:konsul/controllers/login_controller.dart';
import 'package:konsul/models/pasien.dart';
import 'package:konsul/views/components/main_button.dart';
import 'package:konsul/views/components/menu_box.dart';
import 'package:konsul/views/components/profile_section.dart';
import 'package:konsul/views/patient_page/consults_page/consults_page.dart';
import 'package:konsul/views/patient_page/notification_page/notification_page.dart';
import 'package:konsul/views/patient_page/patient_data_page/patient_data_page.dart';

class ProfilePage extends StatelessWidget {
  final Pasien pasien;

  const ProfilePage({Key? key, required this.pasien}) : super(key: key);

  List<Map<String, dynamic>> getMenu() => [
        {
          'name': 'Riwayat Konsultasi',
          'page': ConsultsPage(),
          'onTap': () {},
        },
        {
          'name': 'Data Pasien',
          'page': PatientDataPage(
            pasien: pasien,
          ),
          'onTap': () {},
        },
        {
          'name': 'Pemberitahuan',
          'page': NotificationPage(),
          'onTap': () {},
        },
      ];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      init: LoginController(),
      builder: (controller) {
        return Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ProfileSection(controller.authUser()),
              MenuBox(menu: getMenu()),
              MainButton(
                title: 'Keluar',
                color: red_color,
                fontColor: Colors.white,
                onPress: () {
                  Get.find<LoginController>().logout();
                },
                width: 0.9,
              ),
            ],
          ),
        );
      },
    );
  }
}
