import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agora_rtm/agora_rtm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/common/apis.dart';
import 'package:openim_demo/src/core/controller/im_controller.dart';
import 'package:openim_demo/src/pages/chat/chat_logic.dart';
import 'package:openim_demo/src/utils/data_persistence.dart';
import 'package:openim_demo/src/widgets/agora/components/log_sink.dart';
import 'package:openim_demo/src/widgets/agora/config/agora.config.dart'
    as config;
import 'package:permission_handler/permission_handler.dart';

class LivingLogic extends GetxController {
  final imLogic = Get.find<IMController>();

  String? uid;
  String? channelID;
  String? rtcToken;
  AgoraRtmClient? _client;
  AgoraRtmChannel? _channel;

  late final RtcEngineEx engine;
  var isJoined = false.obs, switchCamera = true.obs, switchRender = true.obs;
  var remoteUid = 0.obs;
  final ScrollController scrollController = ScrollController();

  RxList<Message> massages = <Message>[].obs;
  ChannelProfileType _channelProfileType =
      ChannelProfileType.channelProfileLiveBroadcasting;
  final chatLogic = Get.find<ChatLogic>();

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onInit() {
    [Permission.microphone, Permission.camera].request();

    var arguments = Get.arguments;
    uid = DataPersistence.getLoginCertificate()!.userID;
    channelID = arguments['channelID'];
    rtcToken = arguments['rtcToken'];
    _initEngine();

    imLogic.onRecvNewMessage = (Message message) {
      if (message.contentType == MessageType.LivingMsg &&
          message.groupID == channelID) {
        log("收到直播消息>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
        massages.add(message);
      }
    };
    super.onInit();
  }

  Future<void> sendLiveMessage(content) async {
    var message = await OpenIM.iMManager.messageManager.createTextMessage(
      text: content,
    );
    message.liveID = channelID!;
    message.contentType = MessageType.LivingMsg;
    message.sessionType = ConversationType.live;
    scrollController.jumpTo(scrollController.position.maxScrollExtent);
    _sendMessage(message);
  }

  void _sendMessage(Message message, {String? userId, String? groupId}) {
    log('send : ${json.encode(message)}');
    if (null == userId && null == groupId) {
      massages.add(message);
      // scrollBottom();
    }
    print('uid:$uid  userId:$userId  channelID:$channelID    groupId:$groupId');
    // _reset();
    OpenIM.iMManager.messageManager
        .sendMessage(
          message: message,
          userID: userId ?? uid,
          groupID: "",
          offlinePushInfo: OfflinePushInfo(
            title: '你收到了一条新消息',
            desc: '',
            iOSBadgeCount: true,
            iOSPushSound: '+1',
          ),
        )
        .then((value) => log("成功${value.toJson()}"))
        .catchError((e) => log("失败${e}"))
        .whenComplete(() => log("完成"));
  }

  @override
  Future<void> onClose() async {
    await engine.leaveChannel();
    await engine.release();
  }

  Future<void> _initEngine() async {
    engine = createAgoraRtcEngineEx();
    await engine.initialize(RtcEngineContext(
      appId: config.appId,
      channelProfile: _channelProfileType,
    ));

    engine.registerEventHandler(RtcEngineEventHandler(
      onError: (ErrorCodeType err, String msg) {
        logSink.log('[onError] err: $err, msg: $msg');
      },
      onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
        logSink.log(
            '[onJoinChannelSuccess] connection: ${connection.toJson()} elapsed: $elapsed');
        isJoined.value = true;
      },
      onUserJoined: (RtcConnection connection, int rUid, int elapsed) {
        logSink.log(
            '[onUserJoined] connection: ${connection.toJson()} remoteUid: $rUid elapsed: $elapsed');
        remoteUid.value = rUid;
      },
      onUserOffline:
          (RtcConnection connection, int rUid, UserOfflineReasonType reason) {
        logSink.log(
            '[onUserOffline] connection: ${connection.toJson()}  rUid: $rUid reason: $reason');

        remoteUid.value = 0;
      },
      onLeaveChannel: (RtcConnection connection, RtcStats stats) {
        logSink.log(
            '[onLeaveChannel] connection: ${connection.toJson()} stats: ${stats.toJson()}');

        isJoined.value = false;
        remoteUid.close();
      },
    ));

    // 开启视频
    // await engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    // await engine.enableVideo();
    // await engine.startPreview();

    // 加入频道，设置用户角色为主播

    await joinChannel();
  }

  Future<void> joinChannel() async {
    //获取rtc token
    // var rtcToken =
    //     await Apis.getRTCToken(channelName: channelID!, uid: uid!, role: 2);
    await engine.joinChannel(
        token: rtcToken!,
        channelId: channelID!,
        uid: int.parse(uid!),
        options: const ChannelMediaOptions(
          clientRoleType: ClientRoleType.clientRoleAudience,
        ));
  }

  Future<void> leaveChannel() async {
    await engine.leaveChannel();
  }
}
