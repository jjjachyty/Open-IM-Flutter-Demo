
import 'package:get/get.dart';
import 'package:openim_demo/src/core/controller/im_controller.dart';

class MyQrcodeLogic extends GetxController {
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
    return "https://www.push131.com"; //'${IMQrcodeUrl.addFriend}${imLogic.userInfo.value.userID}';
  }

  String getInvitationCode() {
    var val = int.parse(imLogic.userInfo.value.userID!).toRadixString(16);
    return val;
  }
}
