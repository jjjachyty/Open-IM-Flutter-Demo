import 'dart:async';
import 'dart:developer';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agora_rtm/agora_rtm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/common/apis.dart';
import 'package:openim_demo/src/pages/chat/chat_logic.dart';
import 'package:openim_demo/src/pages/conversation/conversation_logic.dart';
import 'package:openim_demo/src/utils/data_persistence.dart';
import 'package:openim_demo/src/widgets/agora/components/log_sink.dart';
import 'package:openim_demo/src/widgets/agora/config/agora.config.dart'
    as config;
import 'package:permission_handler/permission_handler.dart';

class LivingLogic extends GetxController {
  String? uid;
  String? gid;
  AgoraRtmClient? _client;
  AgoraRtmChannel? _channel;

  late final RtcEngineEx engine;
  var isJoined = false.obs, switchCamera = true.obs, switchRender = true.obs;
  var remoteUid = 0.obs;
  late TextEditingController _controller;

  var massages = [].obs;
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
    gid = arguments['gid'];
    _controller = TextEditingController(text: gid);
    _initEngine();
    super.onInit();
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
    await engine.enableVideo();
    // await engine.startPreview();

    // 加入频道，设置用户角色为主播

    await joinChannel();
  }

  Future<void> joinChannel() async {
    //获取rtc token
    var rtcToken =
        await Apis.getRTCToken(channelName: gid!, uid: uid!, role: 2);
    await engine.joinChannel(
        token: rtcToken['token'],
        channelId: gid!,
        uid: int.parse(uid!),
        options: const ChannelMediaOptions(
          clientRoleType: ClientRoleType.clientRoleAudience,
        ));
  }

  Future<void> leaveChannel() async {
    await engine.leaveChannel();
  }

  void _createClient() async {
    _client = await AgoraRtmClient.createInstance(config.appId);
    _client?.onMessageReceived = (AgoraRtmMessage message, String peerId) {
      log("Peer msg: $peerId, msg: ${message.text}");
    };
    _client?.onConnectionStateChanged = (int state, int reason) {
      log('Connection state changed: $state, reason: $reason');
      if (state == 5) {
        _client?.logout();
        log('Logout.');
      }
    };
    _client?.onLocalInvitationReceivedByPeer =
        (AgoraRtmLocalInvitation invite) {
      log('Local invitation received by peer: ${invite.calleeId}, content: ${invite.content}');
    };
    _client?.onRemoteInvitationReceivedByPeer =
        (AgoraRtmRemoteInvitation invite) {
      log('Remote invitation received by peer: ${invite.callerId}, content: ${invite.content}');
    };
  }

  Future<AgoraRtmChannel?> _createChannel(String name) async {
    AgoraRtmChannel? channel = await _client?.createChannel(name);
    if (channel != null) {
      channel.onMemberJoined = (AgoraRtmMember member) {
        log('Member joined: ${member.userId}, channel: ${member.channelId}');
      };
      channel.onMemberLeft = (AgoraRtmMember member) {
        log('Member left: ${member.userId}, channel: ${member.channelId}');
      };
      channel.onMessageReceived =
          (AgoraRtmMessage message, AgoraRtmMember member) {
        log("Channel msg: ${member.userId}, msg: ${message.text}");
      };
    }
    return channel;
  }
}
