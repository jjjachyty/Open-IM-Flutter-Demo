import 'package:get/get.dart';

import 'share_logic.dart';

class ShareAppBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ShareAppLogic());
  }
}
