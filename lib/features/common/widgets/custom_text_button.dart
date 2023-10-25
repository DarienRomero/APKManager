import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final String label;
  final Function() onPressed;
  final TextStyle? textStyle;
  const CustomTextButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.textStyle
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(label, style: textStyle),
    );
  }
}