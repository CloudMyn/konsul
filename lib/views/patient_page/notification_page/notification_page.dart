// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:konsul/configs/colors.dart';
import 'package:konsul/controllers/login_controller.dart';
import 'package:konsul/controllers/notification_controller.dart';
import 'package:konsul/views/components/cardx.dart';
import 'package:konsul/views/components/main_button.dart';
import 'package:konsul/views/components/navbar.dart';
import 'package:konsul/models/notification.dart' as k;

class NotificationPage extends StatelessWidget {
  NotificationPage({Key? key}) : super(key: key);

  final cNotif = Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    cNotif.countUnreadNoitf();
    
    return GetBuilder<LoginController>(
      init: LoginController(),
      builder: (LoginController loginController) {
        return Scaffold(
          body: SafeArea(
            child: Flex(
              direction: Axis.vertical,
              children: [
                const Navbar(title: "Pemberitahuan", marginV: 10),
                Flexible(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 13,
                      vertical: 5,
                    ),
                    child: cardsBuilder(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget cardsBuilder() {
    return GetBuilder<NotificationController>(
      init: NotificationController(),
      builder: (context) {
        return FutureBuilder<List<k.Notification>>(
          future: cNotif.getNotifications(),
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
              List<k.Notification> rms = snapshot.data ?? [];

              if (rms.isEmpty) {
                return Center(
                  child: Text("Tidak ada data yang bisa ditampilkan!"),
                );
              }

              return listBuilder(rms);
            }

            return Center(
              child: Text("Terjadi Kesalahan!, data tdk bisa di tampilkan!"),
            );
          },
        );
      },
    );
  }

  ListView listBuilder(List<k.Notification> data) {
    cNotif.markAdRead();

    return ListView.builder(
      itemCount: data.length + 1,
      itemBuilder: (context, index) {
        if (index == data.length) {
          return MainButton(
            title: 'Hapus Notifikasi',
            color: red_color,
            mvertical: 10,
            fontColor: Colors.white,
            onPress: () {
              cNotif.flushNotifications();
            },
            width: 1,
          );
        }

        k.Notification notification = data[index];

        return CardX(
          title: notification.title,
          subtitle: notification.subtitle,
          status: notification.isnew ? "New" : "Readed",
          showImage: false,
          onTap: () {},
        );
      },
    );
  }
}
