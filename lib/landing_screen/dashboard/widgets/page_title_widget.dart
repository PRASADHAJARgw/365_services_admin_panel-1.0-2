import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:service365_admin_panel/constant/colors/base_screen_color.dart';

class PageTitleWidget extends StatelessWidget {
  final String title;
  const PageTitleWidget({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _pageTitleTextFontStyle = GoogleFonts.poppins(
        textStyle: TextStyle(
      color: BaseScreenColor.pageTitleTextfontColor,
      fontSize: 13.sp,
      fontWeight: FontWeight.w600,
    ));
    return Text(
      title,
      style: _pageTitleTextFontStyle,
    );
  }
}
