import 'package:flutter/material.dart';
import 'package:task_manager_app/utils/color_palette.dart';

class CustomTextField extends StatelessWidget {
  final String hint;
  final TextEditingController? controller;
  final TextInputType inputType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final bool enabled;
  // final Color fillColor;
  // final Color hintColor;
  final int? maxLength;
  final Function onChange;

  const CustomTextField(
      {super.key,
      required this.hint,
      this.controller,
      required this.inputType,
      this.prefixIcon,
      this.suffixIcon,
      this.obscureText = false,
      this.enabled = true,
      // this.fillColor = kWhiteColor,
      // this.hintColor = kGrey1,
      this.maxLength,
      required this.onChange});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextFormField(
      onChanged: (value) {
        onChange(value);
      },
      validator: (val) => val!.isEmpty ? 'required' : null,
      keyboardType: inputType,
      obscureText: obscureText,
      maxLength: maxLength,
      maxLines: inputType == TextInputType.multiline ? 3 : 1,
      controller: controller,
      enabled: enabled,
      decoration: InputDecoration(
        counterText: "",
        // fillColor: fillColor,
        filled: true,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
        hintText: hint,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        hintStyle: theme.textTheme.bodySmall?.copyWith(
          // color: hintColor,
          fontWeight: FontWeight.w300,
        ),
        // TextStyle(
        //   fontSize: textMedium,
        //   fontWeight: FontWeight.w300,
        //   color: hintColor,
        // ),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        errorStyle: theme.textTheme.bodySmall?.copyWith(
          color: kRed,
        ),
        // const TextStyle(
        //   fontSize: textMedium,
        //   fontWeight: FontWeight.normal,
        //   color: kRed,
        // ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          borderSide: BorderSide(width: 1, color: kPrimaryColor),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          borderSide: BorderSide(width: 0,),
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
