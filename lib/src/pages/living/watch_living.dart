import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'living_logic.dart';

/// MultiChannel Example
class WatchLivingPage extends StatelessWidget {
  final logic = Get.find<LivingLogic>();
  final scaffoldkey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldkey,
        floatingActionButton: IconButton(
          icon: Icon(
            Icons.message,
            color: Colors.white,
          ),
          onPressed: () {
            showModalBottomSheet(
                context: context,
                builder: (builder) {
                  return AnimatedPadding(
                      padding: MediaQuery.of(context)
                          .viewInsets, // 我们可以根据这个获取需要的padding
                      duration: const Duration(milliseconds: 100),
                      child: Container(
                          child: TextField(
                        autofocus: true,
                        textInputAction: TextInputAction.send,
                        keyboardType: TextInputType.text,
                        onSubmitted: (value) {
                          logic.sendLiveMessage(value);
                          Navigator.pop(context);
                        },
                      )));
                });
          },
        ),
        body: Stack(children: [
          Obx(() => logic.remoteUid.value > 0
              ? _remoteVideo()
              : Center(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/images/live_bg.png"))),
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
        ]));
  }

  // Display remote user's video
  Widget _remoteVideo() {
    return AgoraVideoView(
      controller: VideoViewController(
        rtcEngine: logic.engine,
        canvas: VideoCanvas(
          uid: logic.remoteUid.value,
        ),
      ),
    );
  }
}
