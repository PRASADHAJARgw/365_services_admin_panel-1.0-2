import 'package:flutter/material.dart';

class ResponsiveWidget extends StatelessWidget {
  final Widget mobile;
  final Widget desktop;
  final Widget? tablet;
  const ResponsiveWidget({
    Key? key,
    required this.mobile,
    required this.desktop,
    this.tablet,
  }) : super(key: key);

  static const int _mobileWidth = 600;
  static const int _tabletWidth = 1200;

  // This isMobile, isTablet, isDesktop helep us later
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < _mobileWidth;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width < _tabletWidth &&
      MediaQuery.of(context).size.width >= _mobileWidth;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= _tabletWidth;

  @override
  Widget build(BuildContext context) {
    final _deviceSize = MediaQuery.of(context).size;
    // If our width is more than 1100 then we consider it a desktop
    if (_deviceSize.width >= _tabletWidth) {
      return desktop;
    } else if (_deviceSize.width >= _tabletWidth && tablet != null) {
      return tablet!;
    }
    // Or less then that we called it mobile
    else {
      return mobile;
    }
  }
}
