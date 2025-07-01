import 'package:flutter/material.dart';
import 'package:task_manager_app/utils/color_palette.dart';

class CustomTextField extends StatelessWidget {
  final String hint;
  final TextEditingController? controller;
  final TextInputType? inputType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final bool enabled;
  final int? maxLength;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final int? maxLines;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final FocusNode? focusNode;

  const CustomTextField({
    super.key,
    required this.hint,
    this.controller,
    this.inputType,
    this.textInputAction,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.enabled = true,
    this.maxLength,
    this.validator,
    this.maxLines = 1,
    this.onChanged,
    this.focusNode,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextFormField(
      focusNode: focusNode,
      validator: validator,
      onFieldSubmitted: onFieldSubmitted,
      onChanged: onChanged,
      keyboardType: inputType,
      textInputAction: textInputAction,
      obscureText: obscureText,
      maxLength: maxLength,
      maxLines: maxLines,
      controller: controller,
      enabled: enabled,
      decoration: InputDecoration(
        filled: true,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
        hintText: hint,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        hintStyle: theme.textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w300,
        ),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        errorStyle: theme.textTheme.bodySmall?.copyWith(
          color: kRed,
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          borderSide: BorderSide(width: 1, color: kPrimaryColor),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          borderSide: BorderSide(
            width: 0,
          ),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          borderSide: BorderSide(width: 0, color: kGrey1),
        ),
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide(width: 0, color: kGrey1)),
        errorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide(width: 1, color: kRed)),
        focusedErrorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide(width: 1, color: kGrey1)),
        focusColor: kWhiteColor,
        hoverColor: kWhiteColor,
      ),
      cursorColor: kPrimaryColor,
      style: theme.textTheme.bodySmall,
    );
  }
}
