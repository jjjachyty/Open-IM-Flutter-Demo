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
  late Map<String, dynamic> appVersion;
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
    return appVersion["version"];
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
          appVersion['fileURL'],
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
      if (await canLaunch(appVersion['fileURL'])) {
        launch(appVersion['fileURL']);
      }
    }
  }

  void checkUpdate() async {
    if (!canUpdate) {
      IMWidget.showToast('已是最新版本');
      return;
    }
    Get.dialog(UpgradeViewV2(
      needForceUpdate: appVersion['forceUpdate'],
      updateVersion: getLastVersion(),
      packageInfo: packageInfo!,
      onNow: nowUpdate,
      buildUpdateDescription: appVersion['updateLog'],
      subject: subject,
    ));
  }

  /// 自动检测更新
  autoCheckVersionUpgrade() async {
    if (!Platform.isAndroid) return;
    if (isShowUpgradeDialog || isNowIgnoreUpdate) return;
    await getAppInfo();
    appVersion =
        await Apis.getAppversion(packageInfo!.version) as Map<String, dynamic>;
    String lastVersion = appVersion['version'];

    String? ignore = DataPersistence.getIgnoreVersion();
    if (ignore == lastVersion) {
      isNowIgnoreUpdate = true;
      return;
    }
    if (!canUpdate) return;
    isShowUpgradeDialog = true;
    Get.dialog(UpgradeViewV2(
      needForceUpdate: appVersion['forceUpdate'],
      updateVersion: getLastVersion(),
      packageInfo: packageInfo!,
      buildUpdateDescription: appVersion['updateLog'],
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
