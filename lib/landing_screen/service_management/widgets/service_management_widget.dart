import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:service365_admin_panel/constant/colors/base_screen_color.dart';
import 'package:service365_admin_panel/landing_screen/dashboard/widgets/header.dart';
import 'package:service365_admin_panel/landing_screen/service_management/logic/city_manager/city_manager_cubit.dart';
import 'package:service365_admin_panel/landing_screen/service_management/logic/pick_service_image/pick_service_image_cubit.dart';
import 'package:service365_admin_panel/landing_screen/service_management/logic/service_manager/service_cubit.dart';
import 'package:service365_admin_panel/landing_screen/service_management/model/city_model.dart';
import 'package:service365_admin_panel/landing_screen/service_management/model/service_model.dart';
import 'package:service365_admin_panel/landing_screen/service_management/widgets/add_city_dialog.dart';
import 'package:service365_admin_panel/landing_screen/service_management/widgets/add_service_dialog.dart';
import 'package:service365_admin_panel/tools/responsive_handler.dart';
import 'package:service365_admin_panel/utility/spinloading_indicator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ServiceManagementWidget extends StatelessWidget {
  const ServiceManagementWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _deviceSize = MediaQuery.of(context).size;
    final _serviceTextFontStyle = GoogleFonts.poppins(
        textStyle: TextStyle(
      color: BaseScreenColor.pageTitleTextfontColor,
      // fontSize: ((ResponsiveWidget.isDesktop(context) ? 12 : 10)),
      fontSize: 12.sp,
      fontWeight: FontWeight.w600,
    ));
    final _diologBodyTextFontStyle = GoogleFonts.poppins(
        textStyle: TextStyle(
      color: BaseScreenColor.pageTitleTextfontColor,
      // fontSize: ((ResponsiveWidget.isDesktop(context) ? 12 : 10)),
      fontSize: 14.sp,
      fontWeight: FontWeight.w600,
    ));
    final _diologHeadingTextFontStyle = GoogleFonts.poppins(
        textStyle: TextStyle(
      color: BaseScreenColor.pageTitleTextfontColor,
      // fontSize: ((ResponsiveWidget.isDesktop(context) ? 12 : 10)),
      fontSize: 15.sp,
      fontWeight: FontWeight.w600,
    ));
    final _diologActionTextFontStyle = GoogleFonts.poppins(
        textStyle: TextStyle(
      color: BaseScreenColor.pageTitleTextfontColor,
      // fontSize: ((ResponsiveWidget.isDesktop(context) ? 12 : 10)),
      fontSize: 12.sp,
      fontWeight: FontWeight.w600,
    ));
    return ResponsiveWidget(
      mobile: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            SizedBox(width: _deviceSize.height * 0.01),
            ServiceManagement(
              deviceSize: _deviceSize,
              serviceTextFontStyle: _serviceTextFontStyle,
              diologHeadingTextFontStyle: _diologHeadingTextFontStyle,
              diologBodyTextFontStyle: _diologBodyTextFontStyle,
              diologActionTextFontStyle: _diologActionTextFontStyle,
            ),
            SizedBox(height: _deviceSize.height * 0.02),
            CityManagement(
              deviceSize: _deviceSize,
              serviceTextFontStyle: _serviceTextFontStyle,
              diologHeadingTextFontStyle: _diologHeadingTextFontStyle,
              diologBodyTextFontStyle: _diologBodyTextFontStyle,
              diologActionTextFontStyle: _diologActionTextFontStyle,
            ),
          ],
        ),
      ),
      desktop: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            SizedBox(width: _deviceSize.width * 0.01),
            ServiceManagement(
              deviceSize: _deviceSize,
              serviceTextFontStyle: _serviceTextFontStyle,
              diologHeadingTextFontStyle: _diologHeadingTextFontStyle,
              diologBodyTextFontStyle: _diologBodyTextFontStyle,
              diologActionTextFontStyle: _diologActionTextFontStyle,
            ),
            SizedBox(width: _deviceSize.width * 0.01),
            CityManagement(
              deviceSize: _deviceSize,
              serviceTextFontStyle: _serviceTextFontStyle,
              diologHeadingTextFontStyle: _diologHeadingTextFontStyle,
              diologBodyTextFontStyle: _diologBodyTextFontStyle,
              diologActionTextFontStyle: _diologActionTextFontStyle,
            ),
          ],
        ),
      ),
    );
  }
}

class CityManagement extends StatelessWidget {
  const CityManagement({
    Key? key,
    required Size deviceSize,
    required TextStyle serviceTextFontStyle,
    required TextStyle diologHeadingTextFontStyle,
    required TextStyle diologBodyTextFontStyle,
    required TextStyle diologActionTextFontStyle,
  })  : _deviceSize = deviceSize,
        _serviceTextFontStyle = serviceTextFontStyle,
        _diologHeadingTextFontStyle = diologHeadingTextFontStyle,
        _diologBodyTextFontStyle = diologBodyTextFontStyle,
        _diologActionTextFontStyle = diologActionTextFontStyle,
        super(key: key);

  final Size _deviceSize;
  final TextStyle _serviceTextFontStyle;
  final TextStyle _diologHeadingTextFontStyle;
  final TextStyle _diologBodyTextFontStyle;
  final TextStyle _diologActionTextFontStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black45,
      // width: _deviceSize.width *
      //     (ResponsiveWidget.isDesktop(context)
      //         ? 0.4
      //         : (ResponsiveWidget.isTablet(context) ? 0.6 : 1)),
      width: 540.w,
      child: Column(
        children: [
          Header(
            title: 'CITY MANAGEMENT',
            buttonName: 'Add City',
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (dialogContext) {
                  return StatefulBuilder(builder: (dialogContext, setState) {
                    return AlertDialog(
                      title: Text(
                        'Add City',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                        ),
                      ),
                      content: const AddCityDialogWidget(),
                    );
                  });
                },
              );
            },
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: _deviceSize.width * 0.05),
            child: StreamBuilder<List<CityModel?>>(
              stream: BlocProvider.of<CityManagerCubit>(context)
                  .fetchCity(context: context),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox(
                    height: _deviceSize.height * 0.6,
                    width: _deviceSize.width *
                        (ResponsiveWidget.isDesktop(context) ? 0.3 : 0.6),
                    child: const Center(
                      child: SpinLoadingIndicator(),
                    ),
                  );
                } else {
                  final logs = snapshot.data ?? [];
                  //print(logs);
                  if (logs.isEmpty) {
                    return SizedBox(
                      // height: _deviceSize.height * 0.6,
                      // width: _deviceSize.width *
                      //     (ResponsiveWidget.isDesktop(context) ? 0.3 : 0.6),
                      height: 400.h,
                      width: 150.w,
                      child: Center(
                        child: Text(
                          'No city available',
                          style: TextStyle(
                            fontSize: 12.sp,
                          ),
                        ),
                      ),
                    );
                  } else {
                    return SizedBox(
                      // height: _deviceSize.height * 0.6,
                      // width: _deviceSize.width *
                      //     (ResponsiveWidget.isDesktop(context) ? 0.3 : 0.8),
                      height: 400.h,
                      width: 500.w,
                      child: ListView.builder(
                          controller: ScrollController(),
                          itemCount: logs.length,
                          itemBuilder: (context, index) {
                            return Column(children: [
                              const Divider(),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      logs[index]?.cityName ?? 'N/A',
                                      style: _serviceTextFontStyle,
                                    ),
                                    Wrap(
                                      children: [
                                        IconButton(
                                          onPressed: () async {
                                            await showDialog(
                                              context: context,
                                              builder: (dialogContext) {
                                                return StatefulBuilder(builder:
                                                    (dialogContext, setState) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                      'Edit City',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    content:
                                                        AddCityDialogWidget(
                                                      cityModel: logs[index],
                                                    ),
                                                  );
                                                });
                                              },
                                            );
                                          },
                                          icon: const Icon(
                                            Icons.edit,
                                            size: 20,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (ctx) => AlertDialog(
                                                title: Text(
                                                  "Are you sure!",
                                                  style:
                                                      _diologHeadingTextFontStyle,
                                                ),
                                                content: Text(
                                                  "You are about to delete the city ${logs[index]?.cityName}!",
                                                  style:
                                                      _diologBodyTextFontStyle,
                                                ),
                                                actions: [
                                                  TextButton(
                                                    style: TextButton.styleFrom(
                                                      primary: Colors.white,
                                                    ),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Text(
                                                      'No',
                                                      style:
                                                          _diologActionTextFontStyle,
                                                    ),
                                                  ),
                                                  TextButton(
                                                    style: TextButton.styleFrom(
                                                      primary: Colors.white,
                                                    ),
                                                    onPressed: () async {
                                                      Navigator.of(context)
                                                          .pop();
                                                      await BlocProvider.of<
                                                                  CityManagerCubit>(
                                                              context)
                                                          .deleteCity(
                                                        cityModel: logs[index]!,
                                                        context: context,
                                                      );
                                                    },
                                                    child: Text(
                                                      'Yes',
                                                      style:
                                                          _diologActionTextFontStyle,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                          icon: const Icon(
                                            Icons.delete,
                                            size: 22,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ]),
                              const Divider(),
                            ]);
                          }),
                    );
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ServiceManagement extends StatelessWidget {
  const ServiceManagement({
    Key? key,
    required Size deviceSize,
    required TextStyle serviceTextFontStyle,
    required TextStyle diologHeadingTextFontStyle,
    required TextStyle diologBodyTextFontStyle,
    required TextStyle diologActionTextFontStyle,
  })  : _deviceSize = deviceSize,
        _serviceTextFontStyle = serviceTextFontStyle,
        _diologHeadingTextFontStyle = diologHeadingTextFontStyle,
        _diologBodyTextFontStyle = diologBodyTextFontStyle,
        _diologActionTextFontStyle = diologActionTextFontStyle,
        super(key: key);

  final Size _deviceSize;
  final TextStyle _serviceTextFontStyle;
  final TextStyle _diologHeadingTextFontStyle;
  final TextStyle _diologBodyTextFontStyle;
  final TextStyle _diologActionTextFontStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black45,
      // width: _deviceSize.width *
      //     (ResponsiveWidget.isDesktop(context)
      //         ? 0.4
      //         : (ResponsiveWidget.isTablet(context) ? 0.6 : 1)),
      width: 540.w,
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Header(
            title: 'SERVICE MANAGEMENT',
            buttonName: 'Add Service',
            onPressed: () async {
              await BlocProvider.of<PickServiceImageCubit>(context)
                  .resetImage();
              await showDialog(
                context: context,
                builder: (dialogContext) {
                  return StatefulBuilder(builder: (dialogContext, setState) {
                    return AlertDialog(
                      title: Text(
                        'Add Service',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.sp,
                        ),
                      ),
                      content: const AddServiceDialogWidget(),
                    );
                  });
                },
              );
            },
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: _deviceSize.width * 0.05),
            child: StreamBuilder<List<ServiceModel?>>(
                stream: BlocProvider.of<ServiceCubit>(context)
                    .fetchService(context: context),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox(
                      height: _deviceSize.height * 0.6,
                      width: _deviceSize.width *
                          (ResponsiveWidget.isDesktop(context) ? 0.3 : 0.6),
                      child: const Center(
                        child: SpinLoadingIndicator(),
                      ),
                    );
                  } else {
                    final logs = snapshot.data ?? [];
                    //print(logs);
                    if (logs.isEmpty) {
                      return SizedBox(
                        // height: _deviceSize.height * 0.6,
                        // width: _deviceSize.width *
                        //     (ResponsiveWidget.isDesktop(context) ? 0.3 : 0.6),
                        height: 400.h,
                        width: 150.w,
                        child: Center(
                          child: Text(
                            'No service available',
                            style: TextStyle(
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                      );
                    }

                    return SizedBox(
                      // height: _deviceSize.height * 0.6,
                      // width: _deviceSize.width *
                      //     (ResponsiveWidget.isDesktop(context) ? 0.3 : 0.8),
                      height: 400.h,
                      width: 500.w,
                      child: ListView.builder(
                          controller: ScrollController(),
                          itemCount: logs.length,
                          itemBuilder: (context, index) {
                            return Column(children: [
                              const Divider(),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      logs[index]?.serviceName ?? 'N/A',
                                      style: _serviceTextFontStyle,
                                    ),
                                    Wrap(
                                      children: [
                                        IconButton(
                                          onPressed: () async {
                                            await BlocProvider.of<
                                                        PickServiceImageCubit>(
                                                    context)
                                                .resetImage();
                                            await showDialog(
                                              context: context,
                                              builder: (dialogContext) {
                                                return StatefulBuilder(builder:
                                                    (dialogContext, setState) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                      'Edit Service',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    content:
                                                        AddServiceDialogWidget(
                                                      service: logs[index],
                                                    ),
                                                  );
                                                });
                                              },
                                            );
                                          },
                                          icon: const Icon(
                                            Icons.edit,
                                            size: 20,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (ctx) => AlertDialog(
                                                title: Text(
                                                  "Are you sure!",
                                                  style:
                                                      _diologHeadingTextFontStyle,
                                                ),
                                                content: Text(
                                                  "You are about to delete the service ${logs[index]?.serviceName}!",
                                                  style:
                                                      _diologBodyTextFontStyle,
                                                ),
                                                actions: [
                                                  TextButton(
                                                    style: TextButton.styleFrom(
                                                      primary: Colors.white,
                                                    ),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Text(
                                                      'No',
                                                      style:
                                                          _diologActionTextFontStyle,
                                                    ),
                                                  ),
                                                  TextButton(
                                                    style: TextButton.styleFrom(
                                                      primary: Colors.white,
                                                    ),
                                                    onPressed: () async {
                                                      Navigator.of(context)
                                                          .pop();
                                                      await BlocProvider.of<
                                                                  ServiceCubit>(
                                                              context)
                                                          .deleteService(
                                                        service: logs[index]!,
                                                        context: context,
                                                      );
                                                    },
                                                    child: Text(
                                                      'Yes',
                                                      style:
                                                          _diologActionTextFontStyle,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                          icon: const Icon(
                                            Icons.delete,
                                            size: 22,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ]),
                              const Divider(),
                            ]);
                          }),
                    );
                  }
                }),
          )
        ],
      ),
    );
  }
}