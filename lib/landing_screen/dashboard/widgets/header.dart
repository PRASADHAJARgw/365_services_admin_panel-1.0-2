import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:service365_admin_panel/constant/colors/base_screen_color.dart';
import 'package:service365_admin_panel/landing_screen/dashboard/widgets/page_title_widget.dart';

class Header extends StatelessWidget {
  final String title;
  final String? buttonName;
  final void Function()? onPressed;
  final Widget? action;
  const Header({
    Key? key,
    required this.title,
    this.buttonName,
    this.onPressed,
    this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _addServiceTextFontStyle = GoogleFonts.poppins(
        textStyle: TextStyle(
      color: BaseScreenColor.pageTitleTextfontColor,
      fontSize: 12.sp,
      fontWeight: FontWeight.w600,
    ));
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 40.w,
        vertical: 10.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          PageTitleWidget(title: title),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              buttonName == null
                  ? const SizedBox.shrink()
                  : OutlinedButton(
                      child: Text(
                        buttonName!,
                        style: _addServiceTextFontStyle,
                      ),
                      onPressed: onPressed,
                    ),
              action ?? const SizedBox.shrink(),
            ],
          ),
        ],
      ),
    );
  }
}
