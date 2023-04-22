import 'package:flutter/cupertino.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/core/controller/im_controller.dart';

class MyGroupNicknameLogic extends GetxController {
  late Rx<GroupInfo> info;
  var imLogic = Get.find<IMController>();

  var nicknameCtrl = TextEditingController();
  var enabled = false.obs;

  @override
  void onInit() {
    info = Rx(Get.arguments);
    nicknameCtrl.addListener(() {
      enabled.value = nicknameCtrl.text.trim().isNotEmpty;
    });
    super.onInit();
  }

  void clear() {
    nicknameCtrl.clear();
  }

  void modifyMyNickname() async {
    await OpenIM.iMManager.groupManager.setGroupMemberNickname(
        groupID: info.value.groupID,
        userID: OpenIM.iMManager.uid,
        groupNickname: nicknameCtrl.text);
    Get.back();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  @override
  void onClose() {
    nicknameCtrl.dispose();
    super.onClose();
  }
}
