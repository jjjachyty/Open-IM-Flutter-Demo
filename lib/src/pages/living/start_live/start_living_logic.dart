import 'dart:async';
import 'dart:developer';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agora_rtm/agora_rtm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/pages/chat/chat_logic.dart';
import 'package:openim_demo/src/pages/conversation/conversation_logic.dart';
import 'package:openim_demo/src/utils/data_persistence.dart';
import 'package:openim_demo/src/widgets/agora/components/log_sink.dart';
import 'package:openim_demo/src/widgets/agora/config/agora.config.dart'
    as config;
import 'package:permission_handler/permission_handler.dart';

class StartLivingLogic extends GetxController {
  String? uid;
  String? gid;
  late final RtcEngineEx engine;
  bool isReadyPreview = false;
  bool isJoined = false;
  late TextEditingController controller;
  late final TextEditingController localUidController;
  late final TextEditingController screenShareUidController;

  bool isScreenShared = false;

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onInit() {
    controller = TextEditingController(text: uid);
    localUidController = TextEditingController(text: uid);
    screenShareUidController = TextEditingController(text: uid);
    _initEngine();
    super.onInit();
  }

  @override
  Future<void> onClose() async {
    await engine.leaveChannel();
    await engine.release();
    super.onClose();
  }

  _initEngine() async {
    engine = createAgoraRtcEngineEx();
    await engine.initialize(RtcEngineContext(
      appId: config.appId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));
    await engine.setLogLevel(LogLevel.logLevelError);

    engine.registerEventHandler(RtcEngineEventHandler(
        onError: (ErrorCodeType err, String msg) {
      logSink.log('[onError] err: $err, msg: $msg');
    }, onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
      logSink.log(
          '[onJoinChannelSuccess] connection: ${connection.toJson()} elapsed: $elapsed');

      isJoined = true;
    }, onLeaveChannel: (RtcConnection connection, RtcStats stats) {
      logSink.log(
          '[onLeaveChannel] connection: ${connection.toJson()} stats: ${stats.toJson()}');

      isJoined = false;
    }, onLocalVideoStateChanged: (VideoSourceType source,
            LocalVideoStreamState state, LocalVideoStreamError error) {
      logSink.log(
          '[onLocalVideoStateChanged] source: $source, state: $state, error: $error');
      if (!(source == VideoSourceType.videoSourceScreen ||
          source == VideoSourceType.videoSourceScreenPrimary)) {
        return;
      }

      switch (state) {
        case LocalVideoStreamState.localVideoStreamStateCapturing:
        case LocalVideoStreamState.localVideoStreamStateEncoding:
          isScreenShared = true;

          break;
        case LocalVideoStreamState.localVideoStreamStateStopped:
        case LocalVideoStreamState.localVideoStreamStateFailed:
          isScreenShared = false;

          break;
        default:
          break;
      }
    }));

    await engine.enableVideo();
    await engine.setVideoEncoderConfiguration(
      const VideoEncoderConfiguration(
        dimensions: VideoDimensions(width: 1920, height: 1080),
        frameRate: 15,
        bitrate: 0,
      ),
    );
    await engine.startPreview();
    await engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    isReadyPreview = true;
  }

  Future<void> leaveChannel() async {
    await engine.stopScreenCapture();
    await engine.leaveChannel();
  }

  Future<void> updateScreenShareChannelMediaOptions() async {
    final shareShareUid = int.tryParse(screenShareUidController.text);
    if (shareShareUid == null) return;
    await engine.updateChannelMediaOptionsEx(
      options: const ChannelMediaOptions(
        publishScreenTrack: true,
        publishSecondaryScreenTrack: true,
        publishCameraTrack: false,
        publishMicrophoneTrack: false,
        publishScreenCaptureAudio: true,
        publishScreenCaptureVideo: true,
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
      ),
      connection:
          RtcConnection(channelId: controller.text, localUid: shareShareUid),
    );
  }

  void joinChannel() async {
    final localUid = int.tryParse(localUidController.text);
    if (localUid != null) {
      await engine.joinChannelEx(
          token:
              '007eJxTYIgW/jg1nF30AM+ZJ+nXVj/4VmBjmVXow/udP6Su/YbgOyEFhiRTg7Rks5Qki0RzM5Pk1DQLQ8PUVAMTg+RkM/MkI0NzSU7TlIZARgZTH01mRgYIBPHZGXJTU0sy89IZGABW1h5e',
          connection:
              RtcConnection(channelId: controller.text, localUid: localUid),
          options: const ChannelMediaOptions(
            publishCameraTrack: true,
            publishMicrophoneTrack: true,
            clientRoleType: ClientRoleType.clientRoleBroadcaster,
          ));
    }

    final shareShareUid = int.tryParse(screenShareUidController.text);
    if (shareShareUid != null) {
      await engine.joinChannelEx(
          token:
              '007eJxTYIgW/jg1nF30AM+ZJ+nXVj/4VmBjmVXow/udP6Su/YbgOyEFhiRTg7Rks5Qki0RzM5Pk1DQLQ8PUVAMTg+RkM/MkI0NzSU7TlIZARgZTH01mRgYIBPHZGXJTU0sy89IZGABW1h5e',
          connection: RtcConnection(
              channelId: controller.text, localUid: shareShareUid),
          options: const ChannelMediaOptions(
            autoSubscribeVideo: true,
            autoSubscribeAudio: true,
            publishScreenTrack: true,
            publishSecondaryScreenTrack: true,
            publishCameraTrack: false,
            publishMicrophoneTrack: false,
            publishScreenCaptureAudio: true,
            publishScreenCaptureVideo: true,
            clientRoleType: ClientRoleType.clientRoleBroadcaster,
          ));
    }
  }
}
