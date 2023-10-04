import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/pages/meeting/meet_logic.dart';
import 'package:webview_flutter/webview_flutter.dart';


/// MultiChannel Example
class StartMeetingPage extends StatelessWidget {
  final logic = Get.find<MeetingLogic>();
  final scaffoldkey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('开始会议')),
      body: WebViewWidget(controller: logic.controller),
    );
  }
}
