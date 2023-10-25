import 'package:apk_manager/core/utils.dart';
import 'package:apk_manager/features/apps/providers/apps_provider.dart';
import 'package:apk_manager/features/apps/widgets/app_list_item.dart';
import 'package:apk_manager/features/common/widgets/empty_view.dart';
import 'package:apk_manager/features/common/widgets/error_view.dart';
import 'package:apk_manager/features/common/widgets/loading_view.dart';
import 'package:flutter/material.dart';

class AppListView extends StatelessWidget {
  final AppsProvider appsProvider;
  const AppListView({
    super.key,
    required this.appsProvider
  });

  @override
  Widget build(BuildContext context) {
    return appsProvider.appsLoading ? const LoadingView(heigth: 60) :
      appsProvider.appsError ? const ErrorView(heigth: 60) :
      appsProvider.apps.isEmpty ? const EmptyView(heigth: 60) :
      SizedBox(
        height: mqHeigth(context, 60),
        child: ListView.separated(
          itemCount: appsProvider.apps.length,
          itemBuilder: (context, index) {
            final item = appsProvider.apps[index];
            return AppListItem(
              appModel: item,
            );
          }, 
          separatorBuilder: (context, index) {
            return const Divider(
              color: Colors.black54,
            );
          }, 
        ),
      );
  }
}