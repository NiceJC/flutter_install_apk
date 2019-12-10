import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_install_apk/flutter_install_apk.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await FlutterInstallApk.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on: $_platformVersion\n'),
        ),
      ),
    );
  }

  //检查版本
  _checkVersion(){
    PackageInfo.fromPlatform().then((info){
      String localVersion = info.version;

      //需要更新
      bool  needUpdate = UpdateUtil.compareVersion(localVersion, res.data.versionName)==-1;

      if(needUpdate){
        //需要强制更新
        bool  needForce =res.data.mandatoryVersionName==null?false: UpdateUtil.compareVersion(localVersion, res.data.mandatoryVersionName)==-1;

        if(needForce){
          UpdateUtil.showUpdateDialog(context, res.data.versionName, res.data.updateInfo, res.data.downloadUrl,true);
        }else{
          UpdateUtil.showUpdateDialog(context, res.data.versionName, res.data.updateInfo, res.data.downloadUrl,false);
        }

      }else{
        //当前是最新版本

      }

    });
  }
}
