import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:service365_admin_panel/utility/ui_color.dart';

class TextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final Iterable<String>? autofillHints;
  final String text;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final int? maxLength;
  final Widget? suffixIcon;
  final bool obscureText;
  final String? hintText;
  final String? Function(String?)? validator;
  const TextFieldWidget({
    Key? key,
    required this.controller,
    this.autofillHints,
    required this.text,
    required this.textInputAction,
    required this.keyboardType,
    this.maxLength,
    this.suffixIcon,
    this.obscureText = false,
    this.hintText,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final _deviceSize = MediaQuery.of(context).size;

    final _textFieldHintStyle = GoogleFonts.poppins(
        textStyle: TextStyle(
      color: UiColors.foregroundColor,
      fontWeight: FontWeight.w200,
      // fontSize: ResponsiveWidget.isMobile(context) ? 12 : 14,
      fontSize: 12.sp,
    ));

    final _textFieldContentStyle = GoogleFonts.poppins(
        textStyle: TextStyle(
      color: UiColors.foregroundColor,
      fontWeight: FontWeight.w500,
      // fontSize: ResponsiveWidget.isMobile(context) ? 12 : 14,
      fontSize: 12.sp,
    ));
    return TextFormField(
      key: ValueKey(text),
      autofillHints: autofillHints,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      textCapitalization: TextCapitalization.sentences,
      style: _textFieldContentStyle,
      controller: controller,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          // horizontal: _deviceSize.width *
          //     (ResponsiveWidget.isMobile(context) ? 0.04 : 0.02),
          vertical: 10.h,
          horizontal: 20.w,
        ),
        hintText: hintText,
        hintStyle: _textFieldHintStyle,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusColor: UiColors.themeColor,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: UiColors.themeColor, width: 2.0.w),
          borderRadius: BorderRadius.circular(10.r),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: controller.text.isEmpty
                ? UiColors.foregroundColor
                : UiColors.themeColor,
            width: 2.w,
          ),
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
      cursorColor: Colors.white,
      //it is used to hide the character during password entry.
      obscureText: obscureText,
      validator: validator,
      onSaved: (value) {
        controller.text = value!.trim();
      },
    );
  }
}
