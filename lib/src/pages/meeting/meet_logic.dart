import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter_openim_sdk/src/models/user_info.dart' as model;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MeetingLogic extends GetxController {
  late String meetingID;
  late WebViewController controller;
 
  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onInit() {
    [Permission.microphone, Permission.camera].request();
    meetingID = DataSp.getLoginCertificate()!.userID;
    // var arguments = Get.arguments;

late final PlatformWebViewControllerCreationParams params;
params = const PlatformWebViewControllerCreationParams();

    controller = WebViewController.fromPlatformCreationParams(params,onPermissionRequest:(request) => request.grant(),)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://meet.jit.si/' + meetingID)) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://meet.jit.si/' + meetingID));
      controller.platform.setOnPlatformPermissionRequest((request) { 
        request.grant();
      });
    super.onInit();
  }
}
