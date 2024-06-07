import 'package:flutter/material.dart';
import 'package:apk_manager/core/utils.dart';

class PageLoader extends StatelessWidget {
  final bool loading;
  final String message;

  const PageLoader({
    Key? key, 
    required this.loading, 
    required this.message
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return loading ? Material(
      color: Colors.black.withOpacity(0.6),
      child: SizedBox(
        width: mqWidth(context, 100),
        height: mqHeigth(context, 100),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(
                color: Colors.white
              ),
              Container(height: 5),
              Text(message,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w600
                ),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    ) : Container();
  }
}
