import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/pages/mine/share/share_logic.dart';
import 'package:openim_demo/src/res/strings.dart';
import 'package:openim_demo/src/res/styles.dart';
import 'package:openim_demo/src/widgets/avatar_view.dart';
import 'package:openim_demo/src/widgets/im_widget.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ShareAppPage extends StatelessWidget {
  final logic = Get.find<ShareAppLogic>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        // appBar: AppBar(
        //   leading: IconButton(
        //       onPressed: () {
        //         Navigator.pop(context);
        //       },
        //       icon: Icon(
        //         Icons.arrow_back,
        //         color: Colors.black,
        //       )),
        //   backgroundColor: Colors.white,
        //   elevation: 0,
        // ),
        backgroundColor: PageStyle.c_F8F8F8,
        body: Container(
          alignment: Alignment.topCenter,
          child: Stack(
            children: [
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 30.w),
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      image: DecorationImage(
                          image: AssetImage("assets/images/share_bg.jpg"),
                          fit: BoxFit.fill))),
              AppBar(
                backgroundColor: Colors.transparent,
              ),
              Positioned(
                bottom: 50.h,
                right: 50.w,
                child: Container(
                  height: 250.h,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          AvatarView(
                            size: 58.h,
                            url: logic.imLogic.userInfo.value.faceURL,
                          ),
                          SizedBox(
                            width: 13.w,
                          ),
                          // Text(
                          //   logic.imLogic.userInfo.value.getShowName(),
                          //   style: PageStyle.ts_000000_14sp,
                          // )
                          Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color(0xFFFEB2B2),
                                  Color(0xFF5496E4),
                                ],
                              ),
                            ),
                            child: QrImage(
                              data: logic.buildQRContent(),
                              size: 176.h,
                              backgroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text.rich(TextSpan(children: [
                            TextSpan(
                              text: '${StrRes.myInvitation}',
                              style: PageStyle.ts_999999_18sp,
                            ),
                            TextSpan(
                              text: '${logic.getInvitationCode()}',
                              style: PageStyle.ts_171A1D_17sp,
                            )
                          ])),
                          IconButton(
                              onPressed: () {
                                Clipboard.setData(ClipboardData(
                                    text: logic.getInvitationCode()));
                                IMWidget.showToast("success");
                              },
                              icon: Icon(
                                Icons.copy,
                                color: Colors.white,
                                size: 14,
                              ))
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
