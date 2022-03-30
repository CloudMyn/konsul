import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:konsul/configs/colors.dart';
import 'package:konsul/controllers/login_controller.dart';
import 'package:konsul/views/components/alert_box.dart';
import 'package:konsul/views/components/main_button.dart';
import 'package:konsul/views/login_page/components/login_box.dart';

@immutable
class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  final loginC = Get.put(LoginController());

  final RxBool isButtonDisabled = false.obs;

  @override
  Widget build(BuildContext context) {
    attemptRememberLogin();

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GetBuilder<LoginController>(
              init: LoginController(),
              builder: (controller) {
                if (controller.validationError != null) {
                  isButtonDisabled.value = false;
                  return AlertBox(
                    message: controller.validationError!.value.message,
                  );
                }
                return Container();
              }),
          LoginBox(),
          loginButton(),
        ],
      ),
    );
  }

  Future<void> attemptRememberLogin() async {
    isButtonDisabled.value = true;
    bool res = await loginC.attemptRememberLogin();
    if (res == false) {
      isButtonDisabled.value = false;
    }
  }

  Widget loginButton() {
    return Obx(() {
      return Center(
        child: MainButton(
          title: isButtonDisabled.value ? "Loading..." : "Masuk",
          color: blue_color,
          fontColor: Colors.white,
          borderRadius: 10,
          mvertical: 20,
          width: 0.87,
          onPress: () async {
            isButtonDisabled.value = true;
            try {
              await loginC.login();
            } catch (e) {
              debugPrint("ERROR!!");
              debugPrint(e.toString());
            }
            isButtonDisabled.value = false;
          },
          disabled: isButtonDisabled.value,
        ),
      );
    });
  }
}
