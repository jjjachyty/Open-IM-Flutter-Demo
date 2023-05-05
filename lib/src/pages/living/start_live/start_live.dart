import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/widgets/agora/components/example_actions_widget.dart';
import 'package:openim_demo/src/widgets/agora/components/log_sink.dart';
import 'package:openim_demo/src/widgets/agora/components/remote_video_views_widget.dart';
import 'package:openim_demo/src/widgets/agora/components/rgba_image.dart';
import 'package:openim_demo/src/widgets/agora/config/agora.config.dart'
    as config;

import 'start_living_logic.dart';

/// ScreenSharing Example
class StartLiving extends StatelessWidget {
  final logic = Get.find<StartLivingLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Expanded(
          flex: 1,
          child: AspectRatio(
            aspectRatio: 1,
            child: AgoraVideoView(
                controller: VideoViewController(
              rtcEngine: logic.engine,
              canvas: const VideoCanvas(
                uid: 0,
              ),
            )),
          ),
        ),
        AppBar(
          backgroundColor: Colors.transparent,
        ),
      ],
    )
        // ExampleActionsWidget(
        //   displayContentBuilder: (context, isLayoutHorizontal) {
        //     if (logic.isReadyPreview) return Container();
        //     final children = <Widget>[
        //       Expanded(
        //         flex: 1,
        //         child: AspectRatio(
        //           aspectRatio: 1,
        //           child: AgoraVideoView(
        //               controller: VideoViewController(
        //             rtcEngine: logic.engine,
        //             canvas: const VideoCanvas(
        //               uid: 0,
        //             ),
        //           )),
        //         ),
        //       ),
        //       Expanded(
        //         flex: 1,
        //         child: AspectRatio(
        //           aspectRatio: 1,
        //           child: logic.isScreenShared
        //               ? AgoraVideoView(
        //                   controller: VideoViewController(
        //                   rtcEngine: logic.engine,
        //                   canvas: const VideoCanvas(
        //                     uid: 0,
        //                     sourceType: VideoSourceType.videoSourceScreen,
        //                   ),
        //                 ))
        //               : Container(
        //                   color: Colors.grey[200],
        //                   child: const Center(
        //                     child: Text('共享的屏幕'),
        //                   ),
        //                 ),
        //         ),
        //       ),
        //     ];
        //     Widget localVideoView;
        //     if (isLayoutHorizontal) {
        //       localVideoView = Row(
        //         crossAxisAlignment: CrossAxisAlignment.start,
        //         mainAxisAlignment: MainAxisAlignment.start,
        //         children: children,
        //       );
        //     } else {
        //       localVideoView = Column(
        //         crossAxisAlignment: CrossAxisAlignment.start,
        //         mainAxisAlignment: MainAxisAlignment.start,
        //         children: children,
        //       );
        //     }
        //     return Stack(
        //       children: [
        //         localVideoView,
        //         Align(
        //           alignment: Alignment.topLeft,
        //           child: RemoteVideoViewsWidget(
        //             // key: logic.keepRemoteVideoViewsKey,
        //             rtcEngine: logic.engine,
        //             channelId: logic.controller.text,
        //             connectionUid: int.tryParse(logic.localUidController.text),
        //           ),
        //         )
        //       ],
        //     );
        //   },
        //   actionsBuilder: (context, isLayoutHorizontal) {
        //     if (logic.isReadyPreview) return Container();
        //     return Column(
        //       mainAxisAlignment: MainAxisAlignment.start,
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       mainAxisSize: MainAxisSize.min,
        //       children: [
        //         TextField(
        //           controller: logic.controller,
        //           decoration: const InputDecoration(hintText: '会议号'),
        //         ),
        //         TextField(
        //           controller: logic.localUidController,
        //           decoration: const InputDecoration(hintText: '用户ID'),
        //         ),
        //         TextField(
        //           controller: logic.screenShareUidController,
        //           decoration: const InputDecoration(hintText: '屏幕共享ID'),
        //         ),
        //         Row(
        //           children: [
        //             Expanded(
        //               flex: 1,
        //               child: ElevatedButton(
        //                 onPressed: logic.isJoined
        //                     ? logic.leaveChannel
        //                     : logic.joinChannel,
        //                 child: Text('${logic.isJoined ? '离开' : '进入'} 会议'),
        //               ),
        //             )
        //           ],
        //         ),
        //         if (defaultTargetPlatform == TargetPlatform.android ||
        //             defaultTargetPlatform == TargetPlatform.iOS)
        //           ScreenShareMobile(
        //               rtcEngine: logic.engine,
        //               isScreenShared: logic.isScreenShared,
        //               onStartScreenShared: () {
        //                 if (logic.isJoined) {
        //                   logic.updateScreenShareChannelMediaOptions();
        //                 }
        //               },
        //               onStopScreenShare: () {}),
        //         if (defaultTargetPlatform == TargetPlatform.windows ||
        //             defaultTargetPlatform == TargetPlatform.macOS)
        //           ScreenShareDesktop(
        //               rtcEngine: logic.engine,
        //               isScreenShared: logic.isScreenShared,
        //               onStartScreenShared: () {
        //                 if (logic.isJoined) {
        //                   logic.updateScreenShareChannelMediaOptions();
        //                 }
        //               },
        //               onStopScreenShare: () {}),
        //       ],
        //     );
        //   },
        // ),
        );
  }
}

class ScreenShareMobile extends StatefulWidget {
  const ScreenShareMobile(
      {Key? key,
      required this.rtcEngine,
      required this.isScreenShared,
      required this.onStartScreenShared,
      required this.onStopScreenShare})
      : super(key: key);

  final RtcEngine rtcEngine;
  final bool isScreenShared;
  final VoidCallback onStartScreenShared;
  final VoidCallback onStopScreenShare;

  @override
  State<ScreenShareMobile> createState() => _ScreenShareMobileState();
}

class _ScreenShareMobileState extends State<ScreenShareMobile>
    implements ScreenShareInterface {
  final MethodChannel _iosScreenShareChannel =
      const MethodChannel('example_screensharing_ios');

  @override
  bool get isScreenShared => widget.isScreenShared;

  @override
  void onStartScreenShared() {
    widget.onStartScreenShared();
  }

  @override
  void onStopScreenShare() {
    widget.onStopScreenShare();
  }

  @override
  RtcEngine get rtcEngine => widget.rtcEngine;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: ElevatedButton(
            onPressed: !isScreenShared ? startScreenShare : stopScreenShare,
            child: Text('${isScreenShared ? '结束' : '开启'} 屏幕共享'),
          ),
        )
      ],
    );
  }

  @override
  void startScreenShare() async {
    if (isScreenShared) return;

    await rtcEngine.startScreenCapture(
        const ScreenCaptureParameters2(captureAudio: true, captureVideo: true));
    await rtcEngine.startPreview(sourceType: VideoSourceType.videoSourceScreen);
    _showRPSystemBroadcastPickerViewIfNeed();
    onStartScreenShared();
  }

  @override
  void stopScreenShare() async {
    if (!isScreenShared) return;

    await rtcEngine.stopScreenCapture();
    onStopScreenShare();
  }

  Future<void> _showRPSystemBroadcastPickerViewIfNeed() async {
    if (defaultTargetPlatform != TargetPlatform.iOS) {
      return;
    }

    await _iosScreenShareChannel
        .invokeMethod('showRPSystemBroadcastPickerView');
  }
}

class ScreenShareDesktop extends StatefulWidget {
  const ScreenShareDesktop(
      {Key? key,
      required this.rtcEngine,
      required this.isScreenShared,
      required this.onStartScreenShared,
      required this.onStopScreenShare})
      : super(key: key);

  final RtcEngine rtcEngine;
  final bool isScreenShared;
  final VoidCallback onStartScreenShared;
  final VoidCallback onStopScreenShare;

  @override
  State<ScreenShareDesktop> createState() => _ScreenShareDesktopState();
}

class _ScreenShareDesktopState extends State<ScreenShareDesktop>
    implements ScreenShareInterface {
  List<ScreenCaptureSourceInfo> _screenCaptureSourceInfos = [];
  late ScreenCaptureSourceInfo _selectedScreenCaptureSourceInfo;

  @override
  bool get isScreenShared => widget.isScreenShared;

  @override
  void onStartScreenShared() {
    widget.onStartScreenShared();
  }

  @override
  void onStopScreenShare() {
    widget.onStopScreenShare();
  }

  @override
  RtcEngine get rtcEngine => widget.rtcEngine;

  Future<void> _initScreenCaptureSourceInfos() async {
    SIZE thumbSize = const SIZE(width: 50, height: 50);
    SIZE iconSize = const SIZE(width: 50, height: 50);
    _screenCaptureSourceInfos = await rtcEngine.getScreenCaptureSources(
        thumbSize: thumbSize, iconSize: iconSize, includeScreen: true);
    _selectedScreenCaptureSourceInfo = _screenCaptureSourceInfos[0];
    setState(() {});
  }

  Widget _createDropdownButton() {
    if (_screenCaptureSourceInfos.isEmpty) return Container();
    return DropdownButton<ScreenCaptureSourceInfo>(
        items: _screenCaptureSourceInfos.map((info) {
          Widget image;
          if (info.iconImage!.width! != 0 && info.iconImage!.height! != 0) {
            image = Image(
              image: RgbaImage(
                info.iconImage!.buffer!,
                width: info.iconImage!.width!,
                height: info.iconImage!.height!,
              ),
            );
          } else if (info.thumbImage!.width! != 0 &&
              info.thumbImage!.height! != 0) {
            image = Image(
              image: RgbaImage(
                info.thumbImage!.buffer!,
                width: info.thumbImage!.width!,
                height: info.thumbImage!.height!,
              ),
            );
          } else {
            image = const SizedBox(
              width: 50,
              height: 50,
            );
          }

          return DropdownMenuItem(
            value: info,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                image,
                Text('${info.sourceName}', style: const TextStyle(fontSize: 10))
              ],
            ),
          );
        }).toList(),
        value: _selectedScreenCaptureSourceInfo,
        onChanged: isScreenShared
            ? null
            : (v) {
                setState(() {
                  _selectedScreenCaptureSourceInfo = v!;
                });
              });
  }

  @override
  void initState() {
    super.initState();

    _initScreenCaptureSourceInfos();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _createDropdownButton(),
        if (_screenCaptureSourceInfos.isNotEmpty)
          Row(
            children: [
              Expanded(
                flex: 1,
                child: ElevatedButton(
                  onPressed:
                      !isScreenShared ? startScreenShare : stopScreenShare,
                  child:
                      Text('${isScreenShared ? 'Stop' : 'Start'} screen share'),
                ),
              )
            ],
          ),
      ],
    );
  }

  @override
  void startScreenShare() async {
    if (isScreenShared) return;

    final sourceId = _selectedScreenCaptureSourceInfo.sourceId;

    if (_selectedScreenCaptureSourceInfo.type ==
        ScreenCaptureSourceType.screencapturesourcetypeScreen) {
      await rtcEngine.startScreenCaptureByDisplayId(
          displayId: sourceId!,
          regionRect: const Rectangle(x: 0, y: 0, width: 0, height: 0),
          captureParams: const ScreenCaptureParameters(
            captureMouseCursor: true,
            frameRate: 30,
          ));
    } else if (_selectedScreenCaptureSourceInfo.type ==
        ScreenCaptureSourceType.screencapturesourcetypeWindow) {
      await rtcEngine.startScreenCaptureByWindowId(
        windowId: sourceId!,
        regionRect: const Rectangle(x: 0, y: 0, width: 0, height: 0),
        captureParams: const ScreenCaptureParameters(
          captureMouseCursor: true,
          frameRate: 30,
        ),
      );
    }

    onStartScreenShared();
  }

  @override
  void stopScreenShare() async {
    if (!isScreenShared) return;

    await rtcEngine.stopScreenCapture();
    onStopScreenShare();
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
