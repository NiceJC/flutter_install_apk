import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:install_apk_plugin/install_apk_plugin.dart';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:yihezo/interfaces/callback_interface.dart';
import 'package:yihezo/pub_views/alert_show.dart';
import 'package:yihezo/pub_views/dialog_view.dart';
import 'package:yihezo/utils/dio_manager.dart';

class UpdateUtil {

  //比较两个String版本号 （类似1.0.1这样的）
  static int compareVersion(String localVersion, String serverVersion) {
    if (localVersion == serverVersion) {
      return 0;
    }
    List<String> version1Array = localVersion.split(".");
    List<String> version2Array = serverVersion.split(".");
    int index = 0;
    // 获取最小长度值
    int minLen = min(version1Array.length, version2Array.length);
    int diff = 0;
    // 循环判断每位的大小
    while (index < minLen &&
        (diff = int.parse(version1Array[index]) -
            int.parse(version2Array[index])) ==
            0) {
      index++;
    }
    if (diff == 0) {
      // 如果位数不一致，比较多余位数
      for (int i = index; i < version1Array.length; i++) {
        if (int.parse(version1Array[i]) > 0) {
          return 1;
        }
      }

      for (int i = index; i < version2Array.length; i++) {
        if (int.parse(version2Array[i]) > 0) {
          return -1;
        }
      }
      return 0;
    } else {
      return diff > 0 ? 1 : -1;
    }
  }

  static void showUpdateDialog(BuildContext context, String versionName,
      String content, String url, bool forceUpdate) {
    bool isDownloading = false;
    double progress = 0;
    if(url==null||url.length==0){
      AlertShow.toast(context,msg: "下载链接已失效");
      return;
    }

    if (forceUpdate) {
      ///强制更新
      DialogUtil.showForceDialogView(
          context,
          "版本$versionName/n $content",
          ClickCallback(() {
            ///升级
            if (url != null && url.contains('.apk')) {
              _getLocalPath().then((appDir) {
                if (appDir == null) {
                  return;
                }

                String path = appDir.path + versionName + ".apk";
                DioManager().download(url, path, (received, total) {
                  progress = received / total;
                  if (progress == 1) {
                    InstallApkPlugin.installApk(path);
                  } else {
                    isDownloading = true;
                  }
                });
              });
            }
          }, () {}));
    } else {
      ///非强制更新
      DialogUtil.showDialogView(
          context,
          "版本$versionName/n $content",
          ClickCallback(() {
            ///升级
            if (url != null && url.contains('.apk')) {
              _getLocalPath().then((appDir) {
                if (appDir == null) {
                  return;
                }

                String path = appDir.path + versionName + ".apk";
                DioManager().download(url, path, (received, total) {
                  progress = received / total;
                  if (progress == 1) {
                    InstallApkPlugin.installApk(path);
                  } else {
                    isDownloading = true;
                  }
                });
              });
            }
          }, () {

          }));
    }
  }

  static _getLocalPath() async {
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);
    if (permission != PermissionStatus.granted) {
      Map<PermissionGroup, PermissionStatus> permissions =
      await PermissionHandler()
          .requestPermissions([PermissionGroup.storage]);
      if (permissions[PermissionGroup.storage] != PermissionStatus.granted) {
        return null;
      }
    }

    Directory appDir;
    if (Platform.isIOS) {
      appDir = await getApplicationDocumentsDirectory();
    } else {
      appDir = await getExternalStorageDirectory();
    }
    String appDocPath = appDir.path + "/opengit_flutter";
    Directory appPath = Directory(appDocPath);
    await appPath.create(recursive: true);
    return appPath;
  }
}
