import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:service365_admin_panel/constant/colors/base_screen_color.dart';

class SpinLoadingIndicator extends StatelessWidget {
  final Color? color;
  const SpinLoadingIndicator({
    Key? key,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SpinKitThreeBounce(
      color: color ?? BaseScreenColor.themeColor,
      size: 25,
    );
  }
}
