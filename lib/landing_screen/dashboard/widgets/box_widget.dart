import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:service365_admin_panel/constant/colors/base_screen_color.dart';

class BoxWidget extends StatelessWidget {
  final String heading;
  final String content;
  const BoxWidget({
    Key? key,
    required this.heading,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _headerTextFontStyle = GoogleFonts.poppins(
        textStyle: TextStyle(
      color: BaseScreenColor.pageTitleTextfontColor,
      fontSize: 18.sp,
      fontWeight: FontWeight.w400,
    ));
    final _contentTextFontStyle = GoogleFonts.poppins(
        textStyle: TextStyle(
      color: BaseScreenColor.pageTitleTextfontColor,
      fontSize: 25.sp,
      fontWeight: FontWeight.w600,
    ));
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 10.w,
        vertical: 10.h,
      ),
      child: Container(
        alignment: Alignment.center,
        // decoration: BoxDecoration(
        //   border: Border.all(
        //     color: Colors.white54,
        //   ),
        // ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(heading, style: _headerTextFontStyle),
          SizedBox(width: 10.w),
          Text(content, style: _contentTextFontStyle),
        ]),
      ),
    );
  }
}
