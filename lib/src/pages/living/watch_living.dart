import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/widgets/avatar_view.dart';

import 'living_logic.dart';

/// MultiChannel Example
class WatchLivingPage extends StatelessWidget {
  final logic = Get.find<LivingLogic>();
  final scaffoldkey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldkey,
        endDrawer: Drawer(
          width: 200,
          child: _userList(),
        ),
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
                        decoration: InputDecoration(hintText: "请使用文明用语"),
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
          Positioned(
              top: 40,
              left: 5,
              child: Container(
                height: 40,
                width: MediaQuery.of(context).size.width,
                color: Colors.transparent,
                child: Row(
                  children: [
                    Expanded(
                        flex: 7,
                        child: Container(
                          child: Row(
                            children: [
                              IconButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  icon: Icon(Icons.arrow_back)),
                              CircleAvatar(
                                  backgroundImage: Image.network(
                                logic.owner.faceURL ?? "",
                                height: 10.h,
                                width: 10.w,
                              ).image),
                              Text(logic.owner.nickname ?? "")
                            ],
                          ),
                        )),
                    Expanded(
                        flex: 2,
                        child: Text(
                          '${logic.currentView} 人',
                          style: TextStyle(),
                        )),
                    IconButton(
                        onPressed: () {
                          scaffoldkey.currentState?.openEndDrawer();
                        },
                        icon: Icon(Icons.more_horiz))
                  ],
                ),
              )),
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

  Widget _userList() {
    return ListView.builder(
        itemCount: logic.users?.length ?? 0,
        itemBuilder: (context, i) {
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(logic.users?[i].faceURL ?? ""),
            ),
          );
        });
  }
}
