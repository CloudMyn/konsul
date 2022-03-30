// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:konsul/configs/colors.dart';
import 'package:konsul/controllers/login_controller.dart';
import 'package:konsul/models/pasien.dart';
import 'package:konsul/models/rekam_medis.dart';
import 'package:konsul/models/user.dart';
import 'package:konsul/services/network_handler.dart';

class ProfileSection extends StatelessWidget {
  final User user;

  const ProfileSection(this.user);

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: .71,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: defaultAvatar(user.getAvatarURL()),
          ),
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 15),
              child: Column(
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  Text(
                    (user.role == UserRole.doctor ? "Dr. " : "") +
                        user.capitalize(user.name),
                    style: TextStyle(
                      fontSize: 31,
                      fontWeight: FontWeight.w600,
                      color: main_font_color,
                    ),
                  ),
                  Text(
                    "@${user.username}",
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w500,
                      color: second_font_color,
                    ),
                  ),
                  user.role == UserRole.pasien ? _SchBox() : SizedBox(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  CircularProfileAvatar defaultAvatar(String image) {
    debugPrint(image);
    return CircularProfileAvatar(
      image,
      backgroundColor: red_color,
      radius: 100, // sets radius, default 50.0
      borderWidth: 8, // sets border, default 0.0
      initialsText: Text(
        user.getInitial(),
        style: TextStyle(
          fontSize: 60,
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
      borderColor: Color.fromARGB(255, 175, 228, 255),
      elevation: 5.0,
      foregroundColor: Colors.brown.withOpacity(0.5),
      cacheImage: true, // allow widget to cache image against provided url
      imageFit: BoxFit.cover,
      showInitialTextAbovePicture: true,
    );
  }
}

class _SchBox extends StatefulWidget {
  const _SchBox({
    Key? key,
  }) : super(key: key);

  @override
  State<_SchBox> createState() => _SchBoxState();
}

class _SchBoxState extends State<_SchBox> {
  String msg = "memuat!";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      init: LoginController(),
      builder: (controller) {
        if (controller.authUser().role == UserRole.doctor) {
          return SizedBox();
        }

        return Container(
          margin: EdgeInsets.only(top: 12),
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          child: FutureBuilder<String>(
            future: getLastSch(controller),
            builder: (context, snapshot) {
              String _msg = msg;

              if (snapshot.hasData) {
                _msg = snapshot.data ?? 'Ga ada data!';
              }

              if (snapshot.hasError) {
                _msg = "Terdapat kesalahan!";
              }

              return Text(
                _msg,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color.fromARGB(255, 114, 114, 114),
                ),
              );
            },
          ),
          decoration: BoxDecoration(
            color: green_color,
            borderRadius: BorderRadius.circular(8),
          ),
        );
      },
    );
  }

  Future<String> getLastSch(LoginController c) async {
    Pasien pasien =
        await NetworkHandler.getPasienData(c.authUser().id, c.getAuthToken());

    List<RekamMedis> rm =
        await NetworkHandler.getRmPasien(pasien.id, c.getAuthToken());

    if (rm.isEmpty) return "memuat!";

    return rm[0].jadwal + " | " + rm[0].status;
  }
}
