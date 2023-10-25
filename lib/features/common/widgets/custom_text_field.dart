import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:apk_manager/core/utils.dart';

class CustomTextField extends StatelessWidget {
  final bool obscureText;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final String errorMessage;
  final TextEditingController? controller;
  final Function()? onTap;
  final TextInputFormatter? formater;
  final GlobalKey<FormState>? formKey;
  final FocusNode? focusNode;
  final TextAlign textAlign;
  final double widthPer;
  final String label;
  final bool autofocus;
  final bool paswordVisible;
  final TextStyle? style;
  final Function()? onSuffixPressed;
  final Widget? suffixIcon;

  const CustomTextField({
    this.obscureText = false,
    this.onChanged,
    this.validator,
    this.keyboardType,
    Key? key, 
    this.errorMessage = "",
    this.controller,
    this.onTap,
    this.formater,
    this.formKey,
    this.focusNode,
    this.textAlign = TextAlign.start,
    this.widthPer = 95,
    this.autofocus = false,
    required this.label,
    this.paswordVisible = false,
    this.style,
    this.onSuffixPressed,
    this.suffixIcon
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: mqWidth(context, widthPer),
      child: TextFormField(
        autofocus: autofocus,
        key: formKey,
        onTap: onTap,
        focusNode: focusNode,
        controller: controller,
        obscureText: obscureText,
        onChanged: onChanged,
        validator: validator,
        keyboardType: keyboardType,
        inputFormatters: formater != null ? [formater!] : null,
        autocorrect: false,
        textAlign: textAlign,
        decoration: InputDecoration(
          label: Text(label),
          contentPadding: EdgeInsets.symmetric(
            horizontal: mqWidth(context, 3),
          ),
          suffixIcon: suffixIcon ?? (obscureText ? (paswordVisible ? IconButton(
            onPressed: onSuffixPressed,
            icon: const Icon(Icons.visibility_off_rounded)
          ): IconButton(
            onPressed: onSuffixPressed,
            icon: const Icon(Icons.visibility_off_rounded)
          )) : null)
        ),
      ),
    );
  }
}