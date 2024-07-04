import 'package:apk_manager/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';

class AppVersionLabel extends StatefulWidget {
  const AppVersionLabel({super.key});

  @override
  State<AppVersionLabel> createState() => _AppVersionLabelState();
}

class _AppVersionLabelState extends State<AppVersionLabel> {
  final shorebirdCodePush = ShorebirdCodePush();
  String versionLabel = "";
  String versionNumber = "0";
  String? patchVersion = "-";
  
  @override
  void initState() {
    super.initState();
    loadVersion();
  }

  Future<void> loadVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    versionLabel = packageInfo.version;
    versionNumber = packageInfo.buildNumber;
    final patchNumber = await shorebirdCodePush.currentPatchNumber();
    if(patchNumber == null){
      patchVersion = "";
    }else{
      patchVersion = "-patch$patchNumber";
    }
    if(mounted){
      setState(() {});
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        right: mqWidth(context, 5)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            "v$versionLabel+$versionNumber$patchVersion",
            style: const TextStyle(
              color: Colors.white
            )
          ),
        ],
      ),
    );
  }
}