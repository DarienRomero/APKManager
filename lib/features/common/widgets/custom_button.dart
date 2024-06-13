import 'package:apk_manager/features/common/widgets/h_spacing.dart';
import 'package:flutter/material.dart';
import 'package:apk_manager/core/utils.dart';

class CustomButton extends StatelessWidget {
  final FontWeight fontWeight;
  final VoidCallback? onPressed;
  final String label;
  final double widthPer;
  final Color color;
  final double heigth;
  final double borderRadius;
  final bool disabled;
  final Widget? leading;
  final double fontSize;
  final bool loading;
  final Color labelColor;

  const CustomButton({
    Key? key, 
    this.fontWeight = FontWeight.bold,
    required this.onPressed,
    required this.label,
    this.widthPer = 95,
    required this.color,
    this.heigth = 50,
    this.borderRadius = 7,
    this.disabled = false,
    this.leading,
    this.fontSize = 20,
    this.loading = false, 
    this.labelColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: mqWidth(context, widthPer),
      height: heigth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: MaterialButton(
        elevation: 1,
        color: !disabled ? color : const Color(0xffeff4f5),
        minWidth: mqWidth(context, widthPer),
        height: heigth,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius)
        ),
        padding: EdgeInsets.zero,
        onPressed: () {
          if (disabled) return;
          if (onPressed != null) {
            onPressed!();
          }
        },
        child: Center(
          child: loading ? CircularProgressIndicator(color: Colors.white) : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if(leading != null) Row(
                children: [
                  leading!,
                  HSpacing(2),
                  Text(label, style: TextStyle(color: labelColor, fontSize: 16))
                ],
              ) else
              Container(
                width: mqWidth(context, widthPer),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(label, style: TextStyle(color: labelColor, fontSize: 16))
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}
