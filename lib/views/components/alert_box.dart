// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:konsul/configs/colors.dart';

class AlertBox extends StatelessWidget {
  final Color? color, text_color;
  final String message;
  final double width;
  final EdgeInsetsGeometry margin;

  const AlertBox({
    this.color = red_color,
    this.text_color = Colors.white,
    required this.message,
    this.margin = const EdgeInsets.symmetric(vertical: 10),
    this.width = .87,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: FractionallySizedBox(
        widthFactor: width,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: color,
          ),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: text_color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
