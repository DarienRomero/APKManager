import 'package:apk_manager/core/launcher_utils.dart';
import 'package:apk_manager/core/utils.dart';
import 'package:apk_manager/features/apps/models/app_model.dart';
import 'package:apk_manager/features/common/widgets/custom_button.dart';
import 'package:apk_manager/features/common/widgets/general_image.dart';
import 'package:apk_manager/features/common/widgets/v_spacing.dart';
import 'package:flutter/material.dart';

class AppListItem extends StatelessWidget {
  final AppModel appModel;
  const AppListItem({
    super.key,
    required this.appModel
  });

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
            url: appModel.logo,
            fromLocal: false,
            borderRadius: 10,
            fit: BoxFit.cover
          ),
          Container(
            width: mqWidth(context, 60),
            padding: EdgeInsets.only(
              left: mqWidth(context, 3)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(appModel.name, style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500
                )),
                const VSpacing(1),
                Text("Versión: ${appModel.lastVersionString} (${appModel.lastVersionNumber})", style: const TextStyle(
                  color: Colors.black54
                ))
              ],
            ),
          ),
          CustomButton(
            widthPer: 20,
            heigth: 40,
            onPressed: (){
              LauncherUtils.openUrl(context, appModel.lastVersionLink);
            }, 
            label: "ABRIR", 
            color: Colors.blue,
          )
        ],
      ),
    );
  }
}