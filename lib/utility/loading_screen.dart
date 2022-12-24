import 'package:flutter/material.dart';
import 'package:service365_admin_panel/utility/spinloading_indicator.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final _deviceSize = MediaQuery.of(context).size;

    return const Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      body: Center(
        child: SpinLoadingIndicator(),
      ),
    );
  }
}
