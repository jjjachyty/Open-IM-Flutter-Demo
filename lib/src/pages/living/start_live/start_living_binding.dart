import 'package:get/get.dart';
import 'package:openim_demo/src/pages/living/start_live/start_living_logic.dart';

class StartLivingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => StartLivingLogic());
  }
}
