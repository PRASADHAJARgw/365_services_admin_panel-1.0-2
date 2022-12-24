import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service365_admin_panel/authentication/widget/auth_card.dart';
import 'package:service365_admin_panel/utility/ui_color.dart';

class AuthScreen extends StatelessWidget {
  static const routeName = '/Authentication';
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: _deviceSize.width,
        color: UiColors.backgroundColor,
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: SizedBox(
                    width: 350.w,
                    child: const AuthCard(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
