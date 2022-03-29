import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:konsul/configs/colors.dart';
import 'package:konsul/controllers/login_controller.dart';

class LoginBox extends StatelessWidget {
  final RxBool isVisible = false.obs;

  LoginBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return GetBuilder<LoginController>(
      init: LoginController(),
      builder: (controller) {
        return Center(
          child: Container(
            width: size.width * 0.87,
            padding: const EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 15,
            ),
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
            child: Column(
              children: [
                textField(
                  controller.email.value,
                  label: "Email/Username",
                  hint: "Masukan Username",
                ),
                passwordField(controller),
                checkRemember(controller),
              ],
            ),
          ),
        );
      },
    );
  }

  Obx passwordField(LoginController controller) {
    return Obx(() {
      Widget icon = Icon(
        isVisible.value ? Icons.visibility_off : Icons.visibility,
      );
      return Container(
        margin: const EdgeInsets.only(top: 10),
        child: textField(
          controller.password.value,
          label: "Password",
          hint: "Masukkan Password!",
          visibility: !isVisible.value,
          iconData: IconButton(
            onPressed: () {
              isVisible.value = !isVisible.value;
            },
            icon: icon,
          ),
        ),
      );
    });
  }

  Widget textField(
    TextEditingController controller, {
    required String label,
    required String hint,
    Widget? iconData,
    bool? visibility,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: visibility ?? false,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
        border: const OutlineInputBorder(),
        labelText: label,
        hintText: hint,
        suffixIcon: iconData,
      ),
    );
  }

  Widget checkRemember(LoginController controller) {
    return Flex(
      direction: Axis.horizontal,
      children: [
        Obx(() {
          return Flexible(
            flex: 1,
            child: Transform.scale(
              scale: .8,
              child: Checkbox(
                value: controller.rememberMe.value,
                onChanged: (_) {
                  controller.rememberMe.value = !controller.rememberMe.value;
                },
              ),
            ),
          );
        }),
        Flexible(
          flex: 10,
          child: GestureDetector(
            onTap: () {
              controller.rememberMe.value = !controller.rememberMe.value;
            },
            child: const Text(
              "Remember Me!",
              style: TextStyle(color: second_font_color, fontSize: 13),
            ),
          ),
        )
      ],
    );
  }
}
