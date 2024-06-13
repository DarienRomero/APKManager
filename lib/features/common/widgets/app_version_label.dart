import 'package:apk_manager/core/config.dart';
import 'package:apk_manager/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

class AppVersionLabel extends StatefulWidget {
  const AppVersionLabel({Key? key}) : super(key: key);

  @override
  State<AppVersionLabel> createState() => _AppVersionLabelState();
}

class _AppVersionLabelState extends State<AppVersionLabel> {
  String version = "";
  
  @override
  void initState() {
    super.initState();
    loadVersion();
  }

  Future<void> loadVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;
    if(mounted){
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        right: mqWidth(context, 8)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            "V $version + $patchVersion",
            style: const TextStyle(
              color: Colors.black54
            )
          ),
        ],
      ),
    );
  }
}