import 'package:flutter/material.dart';

class ScaffoldWrapper extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget? body;
  final Widget? floatingActionButton;
  final Color? backgroundColor;
  final Widget? drawer;
  final Widget? bottomNavigationBar;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final FloatingActionButtonAnimator? floatingActionButtonAnimator;
  final Future<bool> Function()? onWillPop;
  final Key? scaffoldKey;
  final bool? resizeToAvoidBottomInset;
  final Function(bool)? onDrawerChanged;

  const ScaffoldWrapper({
    Key? key, 
    this.appBar,
    this.body,
    this.floatingActionButton,
    this.backgroundColor,
    this.drawer,
    this.bottomNavigationBar,
    this.floatingActionButtonLocation,
    this.floatingActionButtonAnimator,
    this.onWillPop,
    this.scaffoldKey,
    this.resizeToAvoidBottomInset,
    this.onDrawerChanged
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bounded = MediaQuery.of(context).textScaleFactor.clamp(1.0, 1.2);
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: bounded),
      child: WillPopScope(
        onWillPop: onWillPop,
        child: Scaffold(
          onDrawerChanged: onDrawerChanged,
          extendBody: true,
          resizeToAvoidBottomInset: resizeToAvoidBottomInset,
          key: scaffoldKey,
          drawer: drawer,
          appBar: appBar,
          body: body,
          backgroundColor: backgroundColor,
          floatingActionButton: floatingActionButton,
          bottomNavigationBar: bottomNavigationBar,
          floatingActionButtonLocation: floatingActionButtonLocation,
          floatingActionButtonAnimator: floatingActionButtonAnimator,
        ),
      ),
    );
  }
}
