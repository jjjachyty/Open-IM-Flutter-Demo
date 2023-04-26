import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/res/images.dart';
import 'package:openim_demo/src/res/strings.dart';
import 'package:openim_demo/src/res/styles.dart';
import 'package:openim_demo/src/widgets/button.dart';
import 'package:openim_demo/src/widgets/code_input_box.dart';
import 'package:openim_demo/src/widgets/debounce_button.dart';
import 'package:openim_demo/src/widgets/pwd_input_box.dart';
import 'package:openim_demo/src/widgets/touch_close_keyboard.dart';

import '../../widgets/phone_input_box.dart';
import 'login_logic.dart';

class LoginPage extends StatelessWidget {
  final logic = Get.find<LoginLogic>();

  @override
  Widget build(BuildContext context) {
    return TouchCloseSoftKeyboard(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(ImageRes.ic_loginBg),
                fit: BoxFit.cover,
              ),
            ),
            height: 1.sh,
            child: Stack(
              children: [
                Positioned(
                  top: 136.h,
                  left: 40.w,
                  child: GestureDetector(
                    onDoubleTap: () => logic.toServerConfig(),
                    behavior: HitTestBehavior.translucent,
                    child: Text(
                      StrRes.welcomeUse,
                      style: TextStyle(color: Colors.white, fontSize: 32.sp),
                    ),
                  ),
                ),
                Center(
                  child: Container(
                      width: 0.8.sw,
                      height: 0.4.sh,
                      child: Column(children: [
                        Obx(() => PhoneInputBox(
                              controller: logic.emailCtrl,
                              labelStyle: PageStyle.ts_171A1D_14sp,
                              hintStyle: PageStyle.ts_171A1D0_opacity40p_17sp,
                              textStyle: PageStyle.ts_171A1D_17sp,
                              codeStyle: PageStyle.ts_171A1D_17sp,
                              arrowColor: PageStyle.c_FFFFFF,
                              clearBtnColor: PageStyle.c_FFFFFF,
                              code: logic.areaCode.value,
                              onAreaCode: () => logic.openCountryCodePicker(),
                              showClearBtn: logic.showAccountClearBtn.value,
                              inputWay: InputWay.email,
                            )),
                        Obx(() => logic.isPasswordLogin
                            ? PwdInputBox(
                                controller: logic.pwdCtrl,
                                labelStyle: PageStyle.ts_171A1D_14sp,
                                hintStyle: PageStyle.ts_171A1D0_opacity40p_17sp,
                                textStyle: PageStyle.ts_171A1D_17sp,
                                showClearBtn: logic.showPwdClearBtn.value,
                                obscureText: logic.obscureText.value,
                                onClickEyesBtn: () => logic.toggleEye(),
                                clearBtnColor: PageStyle.c_000000_opacity40p,
                                eyesBtnColor: PageStyle.c_FFFFFF,
                              )
                            : CodeInputBox(
                                controller: logic.codeCtrl,
                                labelStyle: PageStyle.ts_171A1D_14sp,
                                hintStyle: PageStyle.ts_171A1D0_opacity40p_17sp,
                                textStyle: PageStyle.ts_171A1D_17sp,
                                onClickCodeBtn: logic.getVerificationCode,
                              )),
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: GestureDetector(
                            onTap: logic.switchLoginType,
                            behavior: HitTestBehavior.translucent,
                            child: Obx(() => Text(
                                  logic.isPasswordLogin
                                      ? StrRes.useSMSLogin
                                      : StrRes.usePwdLogin,
                                  style: PageStyle.ts_0089FF_12sp,
                                )),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        DebounceButton(
                          onTap: () async => await logic.login(),
                          // your tap handler moved here
                          builder: (context, onTap) {
                            return Obx(() => Button(
                                  enabled: logic.enabledLoginButton.value,
                                  text: StrRes.login,
                                  onTap: onTap,
                                ));
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            GestureDetector(
                              onTap: () => logic.forgetPassword(),
                              behavior: HitTestBehavior.translucent,
                              child: Text(
                                StrRes.forgetPwd,
                                style: PageStyle.ts_0089FF_12sp,
                              ),
                            ),
                            Container(
                              width: 1.w,
                              height: 15.h,
                              color: Color.fromARGB(255, 251, 253, 255),
                              margin: EdgeInsets.symmetric(horizontal: 12.w),
                            ),
                            GestureDetector(
                              onTap: () => logic.register(),
                              behavior: HitTestBehavior.translucent,
                              child: Obx(() => Text(
                                    logic.index.value == 0
                                        ? StrRes.phoneRegister
                                        : StrRes.emailRegister,
                                    style: PageStyle.ts_0089FF_12sp,
                                  )),
                            ),
                          ],
                        ),
                      ])),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
