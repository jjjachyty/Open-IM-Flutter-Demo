import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

import 'core/controller/im_controller.dart';
import 'core/controller/permission_controller.dart';
import 'core/controller/push_controller.dart';
import 'routes/app_pages.dart';
import 'widgets/app_view.dart';

class ChatApp extends StatelessWidget {
  const ChatApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppView(
      builder: (locale, builder) => GetMaterialApp(
        debugShowCheckedModeBanner: true,
        enableLog: true,
        builder: builder,
        theme: ThemeData.light(),
        themeMode: ThemeMode.light,
        darkTheme: ThemeData.dark(),
        logWriterCallback: Logger.print,
        translations: TranslationService(),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          // DefaultCupertinoLocalizations.delegate,
        ],
        fallbackLocale: TranslationService.fallbackLocale,
        locale: locale,
        localeResolutionCallback: (locale, list) {
          Get.locale ??= locale;
<<<<<<< HEAD:lib/src/app.dart
=======
<<<<<<< HEAD:lib/src/app.dart
          return null;
=======
          return locale;
>>>>>>> 20248c558d5e13fd7fc35a425db26ae62f1cc068:lib/app.dart
>>>>>>> ed9233a1b555021c01446d5b388e0dd3d71a600d:lib/app.dart
        },
        supportedLocales: const [Locale('zh', 'CN'), Locale('en', 'US')],
        getPages: AppPages.routes,
        initialBinding: InitBinding(),
        initialRoute: AppRoutes.splash,
      ),
    );
  }
}

class InitBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<PermissionController>(PermissionController());
    Get.put<IMController>(IMController());
    Get.put<PushController>(PushController());
    Get.put<CacheController>(CacheController());
    Get.put<DownloadController>(DownloadController());
    // Get.lazyPut(() => JPushController());
    // Get.lazyPut(() => CallController());
    // Get.lazyPut(() => IMController());
    // Get.lazyPut(() => PermissionController());
  }
}
