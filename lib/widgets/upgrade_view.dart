import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
<<<<<<< HEAD:lib/src/widgets/upgrade_view.dart
import 'package:openim_demo/src/models/upgrade_info.dart';
=======
<<<<<<< HEAD:lib/src/widgets/upgrade_view.dart
>>>>>>> ed9233a1b555021c01446d5b388e0dd3d71a600d:lib/widgets/upgrade_view.dart
import 'package:openim_demo/src/res/strings.dart';
import 'package:openim_demo/src/res/styles.dart';
=======
import 'package:openim_common/openim_common.dart';
>>>>>>> 20248c558d5e13fd7fc35a425db26ae62f1cc068:lib/widgets/upgrade_view.dart
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sprintf/sprintf.dart';

class UpgradeViewV2 extends StatefulWidget {
  final Function()? onLater;
  final Function()? onIgnore;
  final Function() onNow;
  final String updateVersion;
  final bool needForceUpdate;
  final String? buildUpdateDescription;
  final PackageInfo packageInfo;
  final PublishSubject? subject;

  const UpgradeViewV2({
    Key? key,
    this.onLater,
    this.onIgnore,
    required this.onNow,
    required this.updateVersion,
    required this.needForceUpdate,
    this.buildUpdateDescription,
    required this.packageInfo,
    this.subject,
  }) : super(key: key);

  @override
  State<UpgradeViewV2> createState() => _UpgradeViewV2State();
}

class _UpgradeViewV2State extends State<UpgradeViewV2> {
  double _progress = 0.0;
  bool _showProgress = false;

  @override
  void initState() {
    widget.subject?.stream.listen((progress) {
      if (!mounted) return;
      setState(() {
        _progress = progress;
      });
    });
    super.initState();
  }

  void _startDownload() {
    if (Platform.isAndroid) {
      Get.back();
      // setState(() {
      //   _showProgress = true;
      // });
    } else {
      // if (!widget.upgradeInfo.needForceUpdate!) {
      //   Get.back();
      // }
    }
    widget.onNow.call();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return !widget.needForceUpdate;
      },
      child: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 46.w),
          padding: EdgeInsets.symmetric(
            horizontal: 12.w,
            vertical: 12.h,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                StrRes.upgradeFind,
                style: TextStyle(
                  color: const Color(0xFF333333),
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Text(
<<<<<<< HEAD:lib/src/widgets/upgrade_view.dart
                sprintf(StrRes.upgradeVersion,
                    [widget.updateVersion, widget.packageInfo.version]),
                style: PageStyle.ts_333333_14sp,
=======
                sprintf(StrRes.upgradeVersion, [
                  widget.upgradeInfo.buildVersion,
                  widget.packageInfo.version
                ]),
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFF333333),
                ),
>>>>>>> 20248c558d5e13fd7fc35a425db26ae62f1cc068:lib/widgets/upgrade_view.dart
              ),
              SizedBox(
                height: 10.h,
              ),
              Text(
                StrRes.upgradeDescription,
                style: TextStyle(
                  color: const Color(0xFF333333),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 4.h,
              ),
              Text(
<<<<<<< HEAD:lib/src/widgets/upgrade_view.dart
                widget.buildUpdateDescription ?? '',
                style: PageStyle.ts_333333_14sp,
=======
                widget.upgradeInfo.buildUpdateDescription ?? '',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFF333333),
                ),
>>>>>>> 20248c558d5e13fd7fc35a425db26ae62f1cc068:lib/widgets/upgrade_view.dart
              ),
              SizedBox(
                height: 10.h,
              ),
              if (!widget.needForceUpdate && !_showProgress)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildButton(
                      text: StrRes.upgradeIgnore,
                      onTap: widget.onIgnore ?? () => Get.back(),
                    ),
                    _buildButton(
                      text: StrRes.upgradeLater,
                      onTap: widget.onLater ?? () => Get.back(),
                    ),
                    _buildButton(
                      text: StrRes.upgradeNow,
                      onTap: _startDownload,
                    ),
                  ],
                ),
              if (widget.needForceUpdate && !_showProgress)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildButton(
                      text: StrRes.upgradeNow,
                      onTap: _startDownload,
                    )
                  ],
                ),
              // if (_showProgress)
              //   Container(
              //     height: 44.h,
              //     child: Center(
              //       child: LinearPercentIndicator(
              //         lineHeight: 12.h,
              //         percent: _progress,
              //         center: Text(
              //           "${(_progress * 100).toInt()}%",
              //           style: PageStyle.ts_FFFFFF_10sp,
              //         ),
              //         linearStrokeCap: LinearStrokeCap.roundAll,
              //         backgroundColor: Colors.grey.withOpacity(0.5),
              //         progressColor: Colors.blueAccent,
              //       ),
              //     ),
              //   ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton({required String text, Function()? onTap}) => Ink(
        height: 44.h,
        child: InkWell(
          onTap: onTap,
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(
              // vertical: 10.h,
              horizontal: 14.w,
            ),
            child: Text(
              text,
              style: TextStyle(
                color: const Color(0xFF1B72EC),
                fontSize: 16.sp,
              ),
            ),
          ),
        ),
      );
}
