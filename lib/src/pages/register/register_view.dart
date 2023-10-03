import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/res/images.dart';
import 'package:openim_demo/src/res/strings.dart';
import 'package:openim_demo/src/res/styles.dart';
import 'package:openim_demo/src/widgets/button.dart';
import 'package:openim_demo/src/widgets/name_input_box.dart';
import 'package:openim_demo/src/widgets/phone_input_box.dart';
import 'package:openim_demo/src/widgets/touch_close_keyboard.dart';

import 'register_logic.dart';

class RegisterPage extends StatelessWidget {
  final logic = Get.find<RegisterLogic>();

  @override
  Widget build(BuildContext context) {
    return TouchCloseSoftKeyboard(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(ImageRes.ic_loginBg),
                  fit: BoxFit.cover,
                ),
              ),
              height: 1.sh,
              width: 1.sw,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                    ),
                    SizedBox(height: 44.h),
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 32.w),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Obx(() => PhoneInputBox(
                                    controller: logic.controller,
                                    labelStyle: PageStyle.ts_171A1D_14sp,
                                    hintStyle:
                                        PageStyle.ts_171A1D0_opacity40p_17sp,
                                    textStyle: PageStyle.ts_171A1D_17sp,
                                    codeStyle: PageStyle.ts_171A1D_17sp,
                                    arrowColor: PageStyle.c_FFFFFF,
                                    clearBtnColor: PageStyle.c_FFFFFF,
                                    code: logic.areaCode.value,
                                    onAreaCode: () =>
                                        logic.openCountryCodePicker(),
                                    showClearBtn: logic.showClearBtn.value,
                                    inputWay: logic.isPhoneRegister
                                        ? InputWay.phone
                                        : InputWay.email,
                                  )),
                              28.verticalSpace,
                              NameInputBox(
                                topLabel: StrRes.invitationCode,
                                topLabelStyle: PageStyle.ts_000000_14sp,
                                textStyle: PageStyle.ts_171A1D_17sp,
                                hintText:
                                    '${StrRes.plsInputInvitationCode}${logic.needInvitationCodeRegister ? '' : StrRes.optional}',
                                hintStyle: PageStyle.ts_171A1D0_opacity40p_17sp,
                                controller: logic.invitationCodeCtrl,
                              ),
                              116.verticalSpace,
                              Button(
                                onTap: () => logic.nextStep(),
                                text: StrRes.nowRegister,
                              )
                            ]))
                    // Obx(() => ProtocolView(
                    //       isChecked: logic.agreedProtocol.value,
                    //       radioStyle: RadioStyle.BLUE,
                    //       onTap: () => logic.toggleProtocol(),
                    //       margin: EdgeInsets.only(top: 19.h),
                    //       style1: PageStyle.ts_000000_12sp,
                    //       style2: PageStyle.ts_1D6BED_12sp,
                    //     )),
                  ])),
        ),
      ),
    );
  }
}
