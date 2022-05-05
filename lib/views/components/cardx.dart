// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors

import 'dart:math';

import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:konsul/configs/colors.dart';

class CardX extends StatelessWidget {
  final bool showImage;
  final String title, subtitle;
  final String status;

  final String image;

  final void Function() onTap;

  CardX({
    Key? key,
    required this.title,
    this.status = "",
    required this.subtitle,
    required this.onTap,
    this.showImage = true,
    this.image = "",
  }) : super(key: key);

  Color randomColor() {
    List<Color> colors = [blue_color, red_color, green_color, yellow_color];

    return colors[Random.secure().nextInt(colors.length)];
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        // ignore: prefer_const_literals_to_create_immutables
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Color.fromARGB(255, 168, 168, 168).withOpacity(0.3),
            spreadRadius: 0,
            blurRadius: 6,
            offset: Offset.zero, // changes position of shadow
          ),
        ]),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Material(
            // color: Colors.grey.shade300,
            child: InkWell(
              splashColor: Colors.blueGrey.shade200,
              highlightColor: Colors.blueGrey.shade100,
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Flex(
                  direction: Axis.horizontal,
                  children: [
                    !showImage ? SizedBox() : buildImage(image),
                    Flexible(
                      flex: 8,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: Color.fromARGB(255, 107, 107, 107),
                              ),
                            ),
                            Text(
                              subtitle,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color.fromARGB(255, 107, 107, 107),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 12),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 1, horizontal: 10),
                              decoration: BoxDecoration(
                                color: getStatusColor(),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                status.toLowerCase(),
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: Color.fromARGB(255, 248, 248, 248),
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
            ),
          ),
        ),
      ),
    );
  }

  Flexible buildImage(String image) {
    return Flexible(
      flex: 2,
      child: Container(
        width: 75,
        height: 75,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: randomColor(),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Image.network(
            image,
            fit: BoxFit.cover,
            errorBuilder: (ctx, error, s) {
              return Center(
                child: Text(
                  title[0].toUpperCase(),
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    shadows: const [
                      Shadow(
                        color: Color.fromARGB(117, 65, 65, 65),
                        blurRadius: 5,
                      ),
                      Shadow(
                        color: Color.fromARGB(117, 136, 136, 136),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Color getStatusColor() {
    String s = status.toLowerCase();
    if (s == 'selesai' || s == "readed") {
      return Color.fromARGB(255, 123, 255, 71);
    } else if (s == 'proses') {
      return Colors.yellow.shade700;
    } else {
      return red_color;
    }
  }
}
