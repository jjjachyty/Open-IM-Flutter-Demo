import 'dart:convert';

import 'package:get/get.dart';
import 'package:openim_demo/src/core/controller/im_controller.dart';
import 'package:openim_demo/src/widgets/qr_view.dart';
import 'package:sprintf/sprintf.dart';

class ShareAppLogic extends GetxController {
  // late Rx<UserInfo> userInfo;
  final imLogic = Get.find<IMController>();

  @override
  void onInit() async {
    // userInfo = Get.arguments;
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  String buildQRContent() {
    return 'https://www.push131.com';
  }

  String getInvitationCode() {
    var val = int.parse(imLogic.userInfo.value.userID!).toRadixString(16);
    return val;
  }
}
