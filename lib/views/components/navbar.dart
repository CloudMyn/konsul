import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:konsul/configs/_configs.dart';

class Navbar extends StatelessWidget {
  final String title;
  final double paddingV;
  final double paddingH;

  final double marginV;
  final double marginH;

  const Navbar({
    Key? key,
    required this.title,
    this.paddingH = 5,
    this.paddingV = 5,
    this.marginH = 5,
    this.marginV = 5,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: paddingV,
        horizontal: paddingH,
      ),
      margin: EdgeInsets.symmetric(
        vertical: marginV,
        horizontal: marginH,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          Material(
            borderRadius: BorderRadius.circular(50),
            color: blue_color,
            child: InkWell(
              onTap: () {
                Get.back();
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                child: Text(
                  "Kembali",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          Text(
            title.capitalize.toString(),
            style: TextStyle(
              color: main_font_color,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      ),
    );
  }

}
