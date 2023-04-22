import 'package:get/get.dart';

import 'living_logic.dart';

class LivingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LivingLogic());
  }
}
