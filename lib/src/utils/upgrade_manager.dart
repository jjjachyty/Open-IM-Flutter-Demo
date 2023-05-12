import 'dart:io';

import 'package:app_installer/app_installer.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/common/apis.dart';
import 'package:openim_demo/src/common/config.dart';
import 'package:openim_demo/src/core/controller/app_controller.dart';
import 'package:openim_demo/src/models/upgrade_info.dart';
import 'package:openim_demo/src/widgets/im_widget.dart';
import 'package:openim_demo/src/widgets/loading_view.dart';
import 'package:openim_demo/src/widgets/upgrade_view.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rxdart/rxdart.dart';
import 'package:url_launcher/url_launcher.dart';

import 'data_persistence.dart';
import 'http_util.dart';
import 'im_util.dart';

class UpgradeManger {
  PackageInfo? packageInfo;
  var isShowUpgradeDialog = false;
  var isNowIgnoreUpdate = false;
  final subject = PublishSubject<double>();

  // UpgradeManger() {
  //   Get.lazyPut(() => AppController());
  // }

  void closeSubject() {
    subject.close();
  }

  String getLastVersion() {
    return Platform.isAndroid
        ? Config.clientConfigMap["android_version"]
        : Config.clientConfigMap["ios_version"];
  }

  String? getUpdateDescription() {
    return Platform.isAndroid
        ? Config.clientConfigMap["android_update_description"]
        : Config.clientConfigMap["ios_update_description"];
  }

  void ignoreUpdate() {
    DataPersistence.putIgnoreVersion(getLastVersion());
    Get.back();
  }

  void laterUpdate() {
    isNowIgnoreUpdate = true;
    Get.back();
  }

  getAppInfo() async {
    if (packageInfo == null) {
      packageInfo = await PackageInfo.fromPlatform();
    }
  }

  void nowUpdate() async {
    if (Platform.isAndroid) {
      PermissionUtil.storage(() async {
        var path = await IMUtil.createTempFile(
          dir: 'apk',
          fileName: '${packageInfo!.appName}.apk',
        );
        HttpUtil.download(
          Config.clientConfigMap["android_url"],
          cachePath: path,
          onProgress: (int count, int total) {
            subject.add(count / total);
            if (count == total) {
              AppInstaller.installApk(path);
            }
          },
        );
      });
    } else {
      if (await canLaunch(Config.clientConfigMap["ios_url"])) {
        launch(Config.clientConfigMap["ios_url"]);
      }
    }
  }

  void checkUpdate() async {
    if (!canUpdate) {
      IMWidget.showToast('已是最新版本');
      return;
    }
    Get.dialog(UpgradeViewV2(
      needForceUpdate: true,
      updateVersion: getLastVersion(),
      packageInfo: packageInfo!,
      onNow: nowUpdate,
      buildUpdateDescription: getUpdateDescription(),
      subject: subject,
    ));
  }

  /// 自动检测更新
  autoCheckVersionUpgrade() async {
    if (!Platform.isAndroid) return;
    if (isShowUpgradeDialog || isNowIgnoreUpdate) return;
    await getAppInfo();
    String lastVersion = Config.clientConfigMap['android_version'];

    String? ignore = DataPersistence.getIgnoreVersion();
    if (ignore == lastVersion) {
      isNowIgnoreUpdate = true;
      return;
    }
    if (!canUpdate) return;
    isShowUpgradeDialog = true;
    Get.dialog(UpgradeViewV2(
      needForceUpdate: true,
      updateVersion: getLastVersion(),
      packageInfo: packageInfo!,
      buildUpdateDescription: getUpdateDescription(),
      onLater: laterUpdate,
      onIgnore: ignoreUpdate,
      onNow: nowUpdate,
      subject: subject,
    )).whenComplete(() => isShowUpgradeDialog = false);
  }

  bool get canUpdate =>
      IMUtil.compareVersion(
        packageInfo!.version,
        getLastVersion(),
      ) <
      0;
}
