import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'start_living_logic.dart';

/// ScreenSharing Example
class StartLiving extends StatelessWidget {
  final logic = Get.find<StartLivingLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        logic.isJoined.value
            ? AgoraVideoView(
                controller: VideoViewController(
                rtcEngine: logic.engine,
                canvas: VideoCanvas(uid: 0),
              ))
            : Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/live_bg.png"))),
              ),
        AppBar(
          backgroundColor: Colors.transparent,
        ),
        Positioned(
            bottom: 10,
            left: 5,
            child: Container(
              height: 250,
              decoration: BoxDecoration(),
              width: MediaQuery.of(context).size.width * 0.7,
              child: Obx(() => ListView.builder(
                    reverse: true,
                    controller: logic.scrollController,
                    itemBuilder: (context, index) {
                      var item = logic.massages[index];
                      return Text(
                        (item.senderNickname! + ":" + item.content!),
                        style: TextStyle(color: Colors.white),
                      );
                    },
                    itemCount: logic.massages.length,
                  )),
            )),
        Positioned(
          bottom: 100.h,
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: Obx(() => getToolBar()),
          ),
        )
      ],
    ));
  }

  Widget getToolBar() {
    if (logic.isJoined.value) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // if (!logic.isScreenShared.value)
          //   MaterialButton(
          //     onPressed: () async {
          //       await logic.engine.switchCamera();
          //     },
          //     textColor: Colors.white,
          //     child: Text("旋转屏幕"),
          //   ),
          MaterialButton(
            onPressed: () {
              logic.leaveChannel();
            },
            color: Colors.red,
            textColor: Colors.white,
            child: Text("结束讲课"),
          ),
          // logic.isScreenShared.value
          //     ? MaterialButton(
          //         onPressed: () async {
          //           logic.stopScreenShare();
          //         },
          //         textColor: Colors.white,
          //         child: Text("关闭屏幕共享"),
          //       )
          //     : MaterialButton(
          //         onPressed: () async {
          //           logic.startScreenShare();
          //         },
          //         textColor: Colors.white,
          //         child: Text("分享屏幕"),
          //       ),
        ],
      );
    }

    if (logic.leftDuration.value > 0) {
      return Column(
        children: [
          MaterialButton(
            onPressed: () {
              // logic.joinChannel();
              logic.startScreenShare();
            },
            textColor: Colors.white,
            child: Text("开始讲课"),
          ),
          Text(
            "当前剩余分钟数${logic.leftDuration}",
            style: TextStyle(fontSize: 10, color: Colors.red),
          )
        ],
      );
    }
    return Text(
      "当前无直播时间,请联系购买",
      style: TextStyle(color: Colors.white),
    );
  }
}

abstract class ScreenShareInterface {
  void onStartScreenShared();

  void onStopScreenShare();

  bool get isScreenShared;

  RtcEngine get rtcEngine;

  void startScreenShare();

  void stopScreenShare();
}
