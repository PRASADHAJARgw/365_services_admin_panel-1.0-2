import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:service365_admin_panel/constant/colors/base_screen_color.dart';
import 'package:service365_admin_panel/landing_screen/banner/logic/banner_image_picker/banner_image_picker_cubit.dart';
import 'package:service365_admin_panel/landing_screen/banner/logic/bannermanagement/bannermanagement_cubit.dart';
import 'package:service365_admin_panel/landing_screen/banner/model/advertisement_model.dart';
import 'package:service365_admin_panel/landing_screen/banner/widgets/add_adv_dialog.dart';
import 'package:service365_admin_panel/landing_screen/banner/widgets/add_discount_dialog.dart';
import 'package:service365_admin_panel/landing_screen/dashboard/widgets/header.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service365_admin_panel/tools/responsive_handler.dart';
import 'package:service365_admin_panel/utility/spinloading_indicator.dart';


class DiscountManagementWidget extends StatelessWidget {
  const DiscountManagementWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _deviceSize = MediaQuery.of(context).size;
    final discountManagerCubit =
        BlocProvider.of<BannerManagementCubit>(context);

    final discountTextFontStyle = GoogleFonts.poppins(
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
      mobile: Column(children: [
        SizedBox(width: _deviceSize.height * 0.01),
        DiscountManagement(
          bannerManagerCubit: discountManagerCubit,
          deviceSize: _deviceSize,
          discountTextFontStyle: discountTextFontStyle,
          diologHeadingTextFontStyle: _diologHeadingTextFontStyle,
          diologBodyTextFontStyle: _diologBodyTextFontStyle,
          diologActionTextFontStyle: _diologActionTextFontStyle,
        ),
        SizedBox(height: _deviceSize.height * 0.02),
        AdvWidget(
          bannerManagerCubit: discountManagerCubit,
          deviceSize: _deviceSize,
          discountTextFontStyle: discountTextFontStyle,
          diologHeadingTextFontStyle: _diologHeadingTextFontStyle,
          diologBodyTextFontStyle: _diologBodyTextFontStyle,
          diologActionTextFontStyle: _diologActionTextFontStyle,
        ),
      ]),
      desktop: Row(
        children: [
          SizedBox(width: _deviceSize.width * 0.01),
          DiscountManagement(
            bannerManagerCubit: discountManagerCubit,
            deviceSize: _deviceSize,
            discountTextFontStyle: discountTextFontStyle,
            diologHeadingTextFontStyle: _diologHeadingTextFontStyle,
            diologBodyTextFontStyle: _diologBodyTextFontStyle,
            diologActionTextFontStyle: _diologActionTextFontStyle,
          ),
          SizedBox(width: _deviceSize.width * 0.01),
          AdvWidget(
            bannerManagerCubit: discountManagerCubit,
            deviceSize: _deviceSize,
            discountTextFontStyle: discountTextFontStyle,
            diologHeadingTextFontStyle: _diologHeadingTextFontStyle,
            diologBodyTextFontStyle: _diologBodyTextFontStyle,
            diologActionTextFontStyle: _diologActionTextFontStyle,
          ),
        ],
      ),
    );
  }
}

class DiscountManagement extends StatelessWidget {
  const DiscountManagement({
    Key? key,
    required BannerManagementCubit bannerManagerCubit,
    required Size deviceSize,
    required TextStyle discountTextFontStyle,
    required TextStyle diologHeadingTextFontStyle,
    required TextStyle diologBodyTextFontStyle,
    required TextStyle diologActionTextFontStyle,
  })  : _bannerManagerCubit = bannerManagerCubit,
        _deviceSize = deviceSize,
        _discountTextFontStyle = discountTextFontStyle,
        _diologHeadingTextFontStyle = diologHeadingTextFontStyle,
        _diologBodyTextFontStyle = diologBodyTextFontStyle,
        _diologActionTextFontStyle = diologActionTextFontStyle,
        super(key: key);

  final BannerManagementCubit _bannerManagerCubit;
  final Size _deviceSize;
  final TextStyle _discountTextFontStyle;
  final TextStyle _diologHeadingTextFontStyle;
  final TextStyle _diologBodyTextFontStyle;
  final TextStyle _diologActionTextFontStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black45,
      width: 540.w,
      child: Column(
        children: [
          Header(
            title: 'DISCOUNT MANAGEMENT',
            buttonName: 'Add Discount',
            onPressed: () async {
              await BlocProvider.of<BannerImagePickerCubit>(context)
                  .resetImage();
              await showDialog(
                context: context,
                builder: (dialogContext) {
                  return StatefulBuilder(builder: (dialogContext, setState) {
                    return AlertDialog(
                      title: Text(
                        'Add Discount',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                        ),
                      ),
                      content: const AddDiscountDialogWidget(),
                    );
                  });
                },
              );
            },
          ),
          StreamBuilder<List<AdvertisementModel?>>(
            stream: _bannerManagerCubit.fetchDiscount(),
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
                final _logs = snapshot.data ?? [];

                if (_logs.isEmpty) {
                  return SizedBox(
                    height: 400.h,
                    width: 500.w,
                    child: Center(
                      child: Text(
                        'No discount available.',
                        style: TextStyle(
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                  );
                } else {
                  return SizedBox(
                    height: 400.h,
                    width: 500.w,
                    child: ListView.builder(
                        controller: ScrollController(),
                        itemCount: _logs.length,
                        itemBuilder: (context, index) {
                          return Column(children: [
                            const Divider(),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CachedNetworkImage(
                                      fit: BoxFit.fitWidth,
                                      height: 100.h,
                                      width: 100.w,
                                      imageUrl: _logs[index]?.imageUrl ?? '',
                                      progressIndicatorBuilder: (context, url,
                                              downloadProgress) =>
                                          Center(
                                            child: CircularProgressIndicator(
                                              value: downloadProgress.progress,
                                              valueColor:
                                                  const AlwaysStoppedAnimation<
                                                      Color>(Colors.grey),
                                            ),
                                          ),
                                      errorWidget: (context, url, error) {
                                        return const Icon(Icons.error);
                                      }),
                                  Text(
                                    _logs[index]?.name ?? 'N/A',
                                    style: _discountTextFontStyle,
                                  ),
                                  Wrap(
                                    children: [
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
                                                "You are about to delete the Discount ${_logs[index]?.name}!",
                                                style: _diologBodyTextFontStyle,
                                              ),
                                              actions: [
                                                TextButton(
                                                  style: TextButton.styleFrom(
                                                    primary: Colors.white,
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
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
                                                    Navigator.of(context).pop();
                                                    await BlocProvider.of<
                                                                BannerManagementCubit>(
                                                            context)
                                                        .deleteDiscount(
                                                      advertisementModel:
                                                          _logs[index]!,
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
        ],
      ),
    );
  }
}

class AdvWidget extends StatelessWidget {
  const AdvWidget({
    Key? key,
    required BannerManagementCubit bannerManagerCubit,
    required Size deviceSize,
    required TextStyle discountTextFontStyle,
    required TextStyle diologHeadingTextFontStyle,
    required TextStyle diologBodyTextFontStyle,
    required TextStyle diologActionTextFontStyle,
  })  : _bannerManagerCubit = bannerManagerCubit,
        _deviceSize = deviceSize,
        _discountTextFontStyle = discountTextFontStyle,
        _diologHeadingTextFontStyle = diologHeadingTextFontStyle,
        _diologBodyTextFontStyle = diologBodyTextFontStyle,
        _diologActionTextFontStyle = diologActionTextFontStyle,
        super(key: key);

  final BannerManagementCubit _bannerManagerCubit;
  final Size _deviceSize;
  final TextStyle _discountTextFontStyle;
  final TextStyle _diologHeadingTextFontStyle;
  final TextStyle _diologBodyTextFontStyle;
  final TextStyle _diologActionTextFontStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black45,
      width: 540.w,
      child: Column(
        children: [
          Header(
            title: 'ADVERTISEMENT MANAGEMENT',
            buttonName: 'Add Adv',
            onPressed: () async {
              await BlocProvider.of<BannerImagePickerCubit>(context)
                  .resetImage();
              await showDialog(
                context: context,
                builder: (dialogContext) {
                  return StatefulBuilder(builder: (dialogContext, setState) {
                    return AlertDialog(
                      title: Text(
                        'Add Advertisement',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                        ),
                      ),
                      content: const AddAdvDialogWidget(),
                    );
                  });
                },
              );
            },
          ),
          StreamBuilder<List<AdvertisementModel?>>(
            stream: _bannerManagerCubit.fetchAdv(),
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
                final _logs = snapshot.data ?? [];

                if (_logs.isEmpty) {
                  return SizedBox(
                    height: 400.h,
                    width: 500.w,
                    child: Center(
                      child: Text(
                        'No advertisement available.',
                        style: TextStyle(
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                  );
                } else {
                  return SizedBox(
                    height: 400.h,
                    width: 500.w,
                    child: ListView.builder(
                        controller: ScrollController(),
                        itemCount: _logs.length,
                        itemBuilder: (context, index) {
                          return Column(children: [
                            const Divider(),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CachedNetworkImage(
                                      fit: BoxFit.fitWidth,
                                      height: 100.h,
                                      width: 100.w,
                                      imageUrl: _logs[index]?.imageUrl ?? '',
                                      progressIndicatorBuilder: (context, url,
                                              downloadProgress) =>
                                          Center(
                                            child: CircularProgressIndicator(
                                              value: downloadProgress.progress,
                                              valueColor:
                                                  const AlwaysStoppedAnimation<
                                                      Color>(Colors.grey),
                                            ),
                                          ),
                                      errorWidget: (context, url, error) {
                                        return const Icon(Icons.error);
                                      }),
                                  Text(
                                    _logs[index]?.name ?? 'N/A',
                                    style: _discountTextFontStyle,
                                  ),
                                  Wrap(
                                    children: [
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
                                                "You are about to delete the adv ${_logs[index]?.name}!",
                                                style: _diologBodyTextFontStyle,
                                              ),
                                              actions: [
                                                TextButton(
                                                  style: TextButton.styleFrom(
                                                    primary: Colors.white,
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
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
                                                    Navigator.of(context).pop();
                                                    await BlocProvider.of<
                                                                BannerManagementCubit>(
                                                            context)
                                                        .deleteAdv(
                                                      advertisementModel:
                                                          _logs[index]!,
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
        ],
      ),
    );
  }
}
