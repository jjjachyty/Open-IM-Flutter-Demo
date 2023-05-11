import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agora_rtm/agora_rtm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class StartLivingLogic extends GetxController {
  String? uid;
  String? gid;
  late final RtcEngineEx engine;
  bool isReadyPreview = false;
  dynamic rtcToken = "";
  var isJoined = false.obs;
  var leftDuration = 0.obs;

  var isScreenShared = false.obs;
  // var sourceType = VideoSourceType.videoSourceCamera.obs;
  final MethodChannel _iosScreenShareChannel =
      const MethodChannel('example_screensharing_ios');
  @override
  void onReady() {
    super.onReady();
  }

  @override
  Future<void> onInit() async {
    var arguments = Get.arguments;
    uid = DataPersistence.getLoginCertificate()!.userID;
    gid = arguments['gid'];

    _initEngine();
    getUserLive();
    super.onInit();
  }

  @override
  Future<void> onClose() async {
    await engine.leaveChannel();
    await engine.release();
    super.onClose();
  }

  Future<void> getUserLive() async {
    var userInfo = await Apis.getUserSelfInfo(uid!);
    if (userInfo != null && userInfo["leftDuration"] != "") {
      leftDuration.value = int.parse(userInfo["leftDuration"]);
    }
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

      isJoined.value = true;
    }, onLeaveChannel: (RtcConnection connection, RtcStats stats) {
      logSink.log(
          '[onLeaveChannel] connection: ${connection.toJson()} stats: ${stats.toJson()}');

      isJoined.value = false;
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
          isScreenShared.value = true;

          break;
        case LocalVideoStreamState.localVideoStreamStateStopped:
        case LocalVideoStreamState.localVideoStreamStateFailed:
          isScreenShared.value = false;

          break;
        default:
          break;
      }
    }));

    // await engine.enableVideo();
    await engine.enableAudio();
    await engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await engine.setAudioProfile(
      profile: AudioProfileType.audioProfileDefault,
      scenario: AudioScenarioType.audioScenarioMeeting,
    );

    // await engine.setVideoEncoderConfiguration(
    //   const VideoEncoderConfiguration(
    //     dimensions: VideoDimensions(width: 1920, height: 1080),
    //     frameRate: 15,
    //     bitrate: 0,
    //   ),
    // );
    // await engine.startPreview(sourceType: VideoSourceType.videoSourceScreen);
    // await engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    isReadyPreview = true;
  }

  Future<void> leaveChannel() async {
    await engine.stopScreenCapture();
    await engine.leaveChannel();
  }

  Future<void> updateScreenShareChannelMediaOptions() async {
    final shareShareUid = int.tryParse(uid!);
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
      connection: RtcConnection(channelId: gid, localUid: shareShareUid),
    );
  }

  Future<void> joinChannel() async {
    //获取rtc token
    if (rtcToken == "") {
      rtcToken = await Apis.getRTCToken(channelName: gid!, uid: uid!, role: 1);
    }
    await engine.joinChannelEx(
        token: rtcToken["token"],
        connection: RtcConnection(channelId: gid, localUid: int.tryParse(uid!)),
        options: const ChannelMediaOptions(
          publishCameraTrack: true,
          publishMicrophoneTrack: true,
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
        ));
    // final shareShareUid = int.tryParse(screenShareUidController.text);
    // if (shareShareUid != null) {
    //   await engine.joinChannelEx(
    //       token: rtcToken['token'],
    //       connection: RtcConnection(
    //           channelId: controller.text, localUid: shareShareUid),
    //       options: const ChannelMediaOptions(
    //         autoSubscribeVideo: true,
    //         autoSubscribeAudio: true,
    //         publishScreenTrack: true,
    //         publishSecondaryScreenTrack: true,
    //         publishCameraTrack: false,
    //         publishMicrophoneTrack: false,
    //         publishScreenCaptureAudio: true,
    //         publishScreenCaptureVideo: true,
    //         clientRoleType: ClientRoleType.clientRoleBroadcaster,
    //       ));
    // }
  }

  void startScreenShare() async {
    if (isScreenShared.value) return;
    //关闭摄像头 改成屏幕共享
    // await engine.leaveChannelEx(
    //     connection:
    //         RtcConnection(channelId: gid, localUid: int.tryParse(uid!)));
    // if (Platform.isAndroid) {
    //   await Permission.microphone.request();
    // }
    // var rtcToken =
    //     await Apis.getRTCToken(channelName: gid!, uid: uid!, role: 1);
    var rtcToken = await Apis.startLive(int.parse(uid!), int.parse(gid!));

    // await engine.joinChannelEx(
    //     token: rtcToken['token'],
    //     // channelId: gid!,
    //     // uid: int.parse(uid! + "1"),
    //     connection:
    //         RtcConnection(channelId: gid, localUid: int.parse(uid! + "1")),
    //     options: ChannelMediaOptions(
    //       channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    //       clientRoleType: ClientRoleType.clientRoleBroadcaster,
    //     ));

    // sourceType.value = VideoSourceType.videoSourceScreen;
    await engine.joinChannelEx(
        token: rtcToken[0]['RtcToken'],
        connection: RtcConnection(channelId: gid, localUid: int.parse(uid!)),
        options: const ChannelMediaOptions(
          autoSubscribeVideo: true,
          autoSubscribeAudio: true,
          publishScreenTrack: true,
          publishSecondaryScreenTrack: true,
          publishCameraTrack: false,
          publishMicrophoneTrack: true,
          publishScreenCaptureAudio: true,
          publishScreenCaptureVideo: true,
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
        ));
    await engine.startScreenCapture(
        const ScreenCaptureParameters2(captureAudio: true, captureVideo: true));
    _showRPSystemBroadcastPickerViewIfNeed();
  }

  void stopScreenShare() async {
    if (!isScreenShared.value) return;
    await engine.leaveChannelEx(
        connection:
            RtcConnection(channelId: gid, localUid: int.tryParse(uid!)));
    await engine.stopScreenCapture();
    await joinChannel();
  }

  Future<void> _showRPSystemBroadcastPickerViewIfNeed() async {
    if (!Platform.isIOS) {
      return;
    }

    await _iosScreenShareChannel
        .invokeMethod('showRPSystemBroadcastPickerView');
  }
}
