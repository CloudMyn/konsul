// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:konsul/configs/colors.dart';
import 'package:konsul/controllers/login_controller.dart';
import 'package:konsul/views/components/main_button.dart';
import 'package:konsul/views/components/menu_box.dart';
import 'package:konsul/views/components/profile_section.dart';
import 'package:konsul/views/doctor_page/patients_list_page/patients_list_page.dart';
import 'package:konsul/views/doctor_page/schedule_page/schedule_page.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> menu = [
    {
      'name': 'Daftar Pemeriksaan Pasien',
      'page': PatientsListPage(
        pageTitle: "Daftar Pemeriksaan Pasien",
      ),
      'onTap': () {},
    },
    {
      'name': 'Riwayat Perawatan Pasien',
      'page': PatientsListPage(
        pageTitle: "Riwayat Perawatan Pasien",
        patienStatus: "x:proses",
      ),
      'onTap': () {},
    },
    {
      'name': 'jadwal Pasien',
      'page': SchedulePage(),
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
              MenuBox(menu: menu),
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
