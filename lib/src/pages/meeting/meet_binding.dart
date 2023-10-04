import 'package:get/get.dart';

import 'meet_logic.dart';

class MeetingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MeetingLogic());
  }
}
