import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:jointheway/shared/colors.dart';
import 'package:jointheway/shared/text_styles.dart';

class FormInput extends StatelessWidget {
  final int? maxLine;
  final int? maxLength;
  final Color? counterColor;
  final Color? errorColor;
  final Color? color;
  final String? hintText;
  final bool? obscureText;
  final Color? borderColor;
  final double? circularRadius;
  final Color? focusBorderColor;
  final IconData? prefixIcon;
  final double? vertical;
  final Widget? suffix;
  final IconData? suffixIcon;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;

  const FormInput({
    this.color,
    this.hintText,
    this.obscureText,
    this.borderColor,
    this.focusBorderColor,
    this.prefixIcon,
    this.suffix,
    this.onChanged,
    this.validator,
    this.circularRadius,
    this.suffixIcon,
    this.controller,
    this.vertical,
    this.maxLine,
    this.maxLength,
    this.counterColor,
    this.errorColor,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        cursorColor: color ?? AppColors.primaryDarker,
        obscureText: obscureText != null ? obscureText! : false,
        controller: controller,
        obscuringCharacter: '∘',
        maxLines: maxLine ?? 1,
        maxLength: maxLength ?? null,
        style:
            TextStyles.bodyB2.copyWith(color: color ?? AppColors.primaryDarker),
        decoration: InputDecoration(
            counterStyle: TextStyles.hint1
                .copyWith(color: counterColor ?? color ?? AppColors.primary),
            filled: true,
            counterText: "",
            hintMaxLines: maxLine ?? 1,
            fillColor: AppColors.neutralWhite,
            hintText: hintText,
            errorStyle: TextStyles.hint1
                .copyWith(color: errorColor ?? AppColors.statusError),
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, color: color ?? AppColors.primary)
                : null,
            suffixIcon: suffixIcon != null
                ? Icon(suffixIcon, color: color ?? AppColors.primary)
                : null,
            hintStyle:
                TextStyles.bodyB2.copyWith(color: AppColors.neutralGrey500),
            contentPadding:
                EdgeInsets.symmetric(vertical: vertical ?? 10, horizontal: 15),
            enabledBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.all(Radius.circular(circularRadius ?? 15)),
                borderSide: BorderSide(
                    color: borderColor ?? AppColors.primaryLighter, width: 2)),
            focusedBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.all(Radius.circular(circularRadius ?? 15)),
                borderSide: BorderSide(
                    color: focusBorderColor ?? AppColors.primary, width: 2)),
            errorBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.all(Radius.circular(circularRadius ?? 15)),
                borderSide: borderColor != null
                    ? BorderSide(
                        color: borderColor ?? Colors.transparent,
                        width: 2,
                      )
                    : BorderSide(
                        color: Colors.transparent,
                        width: 0,
                      )),
            focusedErrorBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.all(Radius.circular(circularRadius ?? 15)),
                borderSide: BorderSide(
                    color: focusBorderColor ?? AppColors.primaryDarker,
                    width: 2)),
            suffix: suffix ?? null),
        onChanged: onChanged,
        validator: validator);
  }
}

class MyTextInput extends StatelessWidget {
  final Color? color;
  final TextEditingController? controller;
  final int? line;
  final String hintText;
  final Color? borderColor;
  final Color? focusBorderColor;
  final double? circularRadius;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final String? suffixText;
  final bool? readOnly;
  final Function()? onTap;
  final Function(String)? onChanged;

  const MyTextInput({
    this.color,
    required this.hintText,
    this.borderColor,
    this.prefixIcon,
    this.suffixIcon,
    this.suffixText,
    this.onChanged,
    this.focusBorderColor,
    this.line,
    this.controller,
    this.circularRadius,
    this.readOnly,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: readOnly ?? false,
      onTap: onTap,
      controller: controller,
      maxLines: line ?? null,
      cursorColor: color ?? AppColors.primaryDarker,
      onChanged: onChanged,
      style:
          TextStyles.bodyB2.copyWith(color: color ?? AppColors.primaryDarker),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          filled: true,
          fillColor: AppColors.neutralWhite,
          hintText: hintText,
          hintStyle:
              TextStyles.bodyB2.copyWith(color: AppColors.neutralGrey500),
          suffixIcon: suffixIcon != null
              ? Icon(suffixIcon, color: color ?? AppColors.primary)
              : null,
          prefixIcon: prefixIcon != null
              ? Icon(prefixIcon, color: color ?? AppColors.primary)
              : null,
          enabledBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.all(Radius.circular(circularRadius ?? 15)),
              borderSide: BorderSide(
                  color: borderColor ?? AppColors.primaryLighter, width: 2)),
          focusedBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.all(Radius.circular(circularRadius ?? 15)),
              borderSide: BorderSide(
                  color: focusBorderColor ?? AppColors.primary, width: 2))),
    );
  }
}
