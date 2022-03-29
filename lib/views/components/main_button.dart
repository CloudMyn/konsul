// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';

import '../../configs/colors.dart';

class MainButton extends StatelessWidget {
  final String title;
  final void Function()? onPress;
  final bool disabled;
  final Color? color;
  final Color? fontColor;
  final double? width, mvertical, mhorizontal, borderRadius;

  MainButton({
    Key? key,
    required this.title,
    this.onPress,
    this.color,
    this.fontColor,
    this.width,
    this.mhorizontal,
    this.mvertical,
    this.borderRadius,
    this.disabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: width ?? 1,
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: mvertical ?? 0,
          horizontal: mhorizontal ?? 0,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius ?? 5),
          child: Material(
            color: disabled ? Colors.grey.shade300 : color,
            child: InkWell(
              onTap: disabled ? null : onPress ?? () {},
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                child: Center(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: fontColor ?? main_font_color,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
