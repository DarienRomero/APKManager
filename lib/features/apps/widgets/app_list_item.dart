import 'package:apk_manager/core/launcher_utils.dart';
import 'package:apk_manager/core/utils.dart';
import 'package:apk_manager/features/apps/models/app_model.dart';
import 'package:apk_manager/features/apps/models/app_state_enum.dart';
import 'package:apk_manager/features/common/widgets/custom_button.dart';
import 'package:apk_manager/features/common/widgets/general_image.dart';
import 'package:apk_manager/features/common/widgets/v_spacing.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/material.dart';

class AppListItem extends StatefulWidget {
  final AppModel appModel;
  const AppListItem({
    super.key,
    required this.appModel
  });

  @override
  State<AppListItem> createState() => _AppListItemState();
}

class _AppListItemState extends State<AppListItem> {
  bool loadingState = true;
  AppState appState = AppState.not_installed;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
     readAppState(widget.appModel.packageName);
    });
  }

  Future<void> readAppState(String packageName) async {
    try{
      final installed = await LaunchApp.isAppInstalled(
        androidPackageName: widget.appModel.packageName,
      );
      if(installed == null){
        appState = AppState.not_installed;
      }else if(installed){
        appState = AppState.installed;
      }
    }catch(_){
      appState = AppState.not_installed;
    }finally{
      loadingState = false;
      if(mounted){
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: mqWidth(context, 95),
      margin: EdgeInsets.only(
        bottom: mqHeigth(context, 2)
      ),
      child: Row(
        children: [
          GeneralImage(
            width: mqWidth(context, 15),
            height: mqWidth(context, 15),
            url: widget.appModel.logo,
            fromLocal: false,
            borderRadius: 10,
            fit: BoxFit.cover
          ),
          Container(
            width: mqWidth(context, 50),
            padding: EdgeInsets.only(
              left: mqWidth(context, 3)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.appModel.name, style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500
                )),
                const VSpacing(1),
                Text("Versión: ${widget.appModel.lastVersionString} (${widget.appModel.lastVersionNumber})", style: const TextStyle(
                  color: Colors.black54
                ))
              ],
            ),
          ),
          CustomButton(
            widthPer: 30,
            heigth: 40,
            loading: loadingState,
            onPressed: () async {
              if(appState == AppState.not_installed){
                LauncherUtils.openUrl(context, widget.appModel.lastVersionLink);
              }else if (appState == AppState.installed){
                await LaunchApp.openApp(
                  androidPackageName: widget.appModel.packageName,
                  openStore: false
                );
              }else if (appState == AppState.new_version_available){
                LauncherUtils.openUrl(context, widget.appModel.lastVersionLink);
              }
            }, 
            label: appState.displayTitle, 
            color: Colors.blue,
          )
        ],
      ),
    );
  }
}