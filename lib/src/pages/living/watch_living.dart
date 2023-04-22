import 'dart:ffi';
import 'dart:math';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'living_logic.dart';

// class WatchLivingPage extends StatefulWidget {
//   const WatchLivingPage({Key? key}) : super(key: key);

//   @override
//   State<WatchLivingPage> createState() => _WatchLivingPageState();
// }

// class _WatchLivingPageState extends State<WatchLivingPage> {
//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }

/// MultiChannel Example
class WatchLivingPage extends StatelessWidget {
  final logic = Get.find<LivingLogic>();
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Obx(() => logic.remoteUid.value > 0
          ? _remoteVideo()
          : Center(
              child: Container(
                width: double.infinity,
                color: Colors.black,
                child: Center(
                  child: Text(
                    "等待讲师上线...",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            )),
      AppBar(
        backgroundColor: Colors.transparent,
      ),
      Align(
          alignment: Alignment.bottomLeft,
          child: Container(
            height: 200,
            child: ListView.builder(
              itemBuilder: (context, index) {
                return Text(logic.massages[index]);
              },
              itemCount: logic.massages.length,
            ),
          ))
    ]);
  }

  // Display remote user's video
  Widget _remoteVideo() {
    return AgoraVideoView(
      controller: VideoViewController.remote(
        rtcEngine: logic.engine,
        canvas: VideoCanvas(uid: logic.remoteUid.value),
        connection: const RtcConnection(channelId: "1763879570"),
      ),
    );
  }
}
