// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:konsul/controllers/notification_controller.dart';

import '../../configs/colors.dart';

class MenuBox extends StatelessWidget {
  final List<Map<String, dynamic>> menu;

  const MenuBox({Key? key, required this.menu}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(7),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      width: size.width * 0.9,
      // height: MediaQuery.of(context).size.height * 0.4,
      margin: EdgeInsets.only(bottom: size.height * 0.15),
      padding: const EdgeInsets.only(
        top: 15,
        bottom: 5,
        left: 8,
        right: 8,
      ),
      child: Column(
        children: buildMenu(),
      ),
    );
  }

  List<Widget> buildMenu() {
    List<Widget> item = [];

    for (Map<String, dynamic> data in menu) {
      item.add(Container(
        margin: const EdgeInsetsDirectional.only(bottom: 10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Material(
            child: InkWell(
              onTap: () {
                Get.to(data['page']);
                data['onTap']();
              },
              child: FractionallySizedBox(
                widthFactor: 1,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        data['name'],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: second_font_color,
                          fontSize: 16,
                        ),
                      ),
                      data['name'] == "Pemberitahuan"
                          ? buildNotificationBadge()
                          : SizedBox(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ));
    }
    return item;
  }

  Widget buildNotificationBadge() {
    return GetBuilder<NotificationController>(
      init: NotificationController(),
      builder: (controller) {
        return Container(
          margin: EdgeInsets.only(left: 5),
          padding: EdgeInsets.symmetric(horizontal: 3.5, vertical: 1),
          child: Text(
            controller.unReadNotification.value.toString(),
            style: TextStyle(color: Colors.white),
          ),
          decoration: BoxDecoration(
            color: Colors.blue.shade400,
            borderRadius: BorderRadius.circular(5),
          ),
        );
      },
    );
  }
}
