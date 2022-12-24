import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:service365_admin_panel/constant/colors/base_screen_color.dart';
import 'package:service365_admin_panel/landing_screen/banner/model/advertisement_model.dart';
import 'package:service365_admin_panel/landing_screen/dashboard/widgets/header.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service365_admin_panel/landing_screen/section/logic/section_image_management/section_image_management_cubit.dart';
import 'package:service365_admin_panel/landing_screen/section/logic/section_image_picker/section_imagepicker_cubit.dart';
import 'package:service365_admin_panel/landing_screen/section/logic/section_management/section_management_cubit.dart';
import 'package:service365_admin_panel/landing_screen/section/model/section_image_model.dart';
import 'package:service365_admin_panel/landing_screen/section/widgets/add_image_dialog.dart';
import 'package:service365_admin_panel/landing_screen/section/widgets/add_section_dialog.dart';
import 'package:service365_admin_panel/utility/spinloading_indicator.dart';

class SectionManagementWidget extends StatelessWidget {
  const SectionManagementWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final _deviceSize = MediaQuery.of(context).size;
    final _sectionManagerCubit =
        BlocProvider.of<SectionManagementCubit>(context);

    final _discountTextFontStyle = GoogleFonts.poppins(
        textStyle: TextStyle(
      color: BaseScreenColor.pageTitleTextfontColor,
      fontSize: 12.sp,
      fontWeight: FontWeight.w600,
    ));
    final _diologBodyTextFontStyle = GoogleFonts.poppins(
        textStyle: TextStyle(
      color: BaseScreenColor.pageTitleTextfontColor,
      fontSize: 14.sp,
      fontWeight: FontWeight.w600,
    ));
    final _diologHeadingTextFontStyle = GoogleFonts.poppins(
        textStyle: TextStyle(
      color: BaseScreenColor.pageTitleTextfontColor,
      fontSize: 15.sp,
      fontWeight: FontWeight.w600,
    ));
    final _diologActionTextFontStyle = GoogleFonts.poppins(
        textStyle: TextStyle(
      color: BaseScreenColor.pageTitleTextfontColor,
      fontSize: 12.sp,
      fontWeight: FontWeight.w600,
    ));
    return Column(
      children: [
        SizedBox(height: 10.h),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            primary: Colors.white,
          ),
          onPressed: () async {
            await showDialog(
              context: context,
              builder: (dialogContext) {
                return StatefulBuilder(builder: (dialogContext, setState) {
                  return AlertDialog(
                    title: Text(
                      'Add Section',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                      ),
                    ),
                    content: const AddSectionDialogWidget(),
                  );
                });
              },
            );
          },
          child: Text(
            'Add section',
            style: _diologActionTextFontStyle,
          ),
        ),
        SizedBox(height: 10.h),
        StreamBuilder<List<AdvertisementModel?>>(
          stream: _sectionManagerCubit.fetchSections(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SizedBox(
                height: 50.h,
                width: 50.w,
                child: const Center(
                  child: SpinLoadingIndicator(),
                ),
              );
            } else {
              final _sectionLogs = snapshot.data ?? [];
              if (_sectionLogs.isEmpty) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    child: Text(
                      'No section available',
                      style: TextStyle(
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                );
              } else {
                return SectionBuilder(
                  sectionLogs: _sectionLogs,
                  diologHeadingTextFontStyle: _diologHeadingTextFontStyle,
                  diologBodyTextFontStyle: _diologBodyTextFontStyle,
                  diologActionTextFontStyle: _diologActionTextFontStyle,
                  discountTextFontStyle: _discountTextFontStyle,
                );
              }
            }
          },
        ),
      ],
    );
  }
}

class SectionBuilder extends StatelessWidget {
  const SectionBuilder({
    Key? key,
    required List<AdvertisementModel?> sectionLogs,
    required TextStyle diologHeadingTextFontStyle,
    required TextStyle diologBodyTextFontStyle,
    required TextStyle diologActionTextFontStyle,
    required TextStyle discountTextFontStyle,
  })  : _sectionLogs = sectionLogs,
        _diologHeadingTextFontStyle = diologHeadingTextFontStyle,
        _diologBodyTextFontStyle = diologBodyTextFontStyle,
        _diologActionTextFontStyle = diologActionTextFontStyle,
        _discountTextFontStyle = discountTextFontStyle,
        super(key: key);

  final List<AdvertisementModel?> _sectionLogs;
  final TextStyle _diologHeadingTextFontStyle;
  final TextStyle _diologBodyTextFontStyle;
  final TextStyle _diologActionTextFontStyle;
  final TextStyle _discountTextFontStyle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 450.w,
      child: ListView.builder(
          shrinkWrap: true,
          controller: ScrollController(),
          itemCount: _sectionLogs.length,
          itemBuilder: (context, sectionIndex) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  color: Colors.black45,
                  height: 380.h,
                  child: Column(
                    children: [
                      Header(
                        title: _sectionLogs[sectionIndex]!.name,
                        action: StreamBuilder<List<SectionImageModel?>>(
                          stream: BlocProvider.of<SectionImageManagementCubit>(
                                  context)
                              .fetchSectionImages(
                                  sectionDocId:
                                      _sectionLogs[sectionIndex]!.id!),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: SpinLoadingIndicator(),
                              );
                            } else {
                              if (snapshot.data!.isEmpty) {
                                return IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: Text(
                                          "Are you sure!",
                                          style: _diologHeadingTextFontStyle,
                                        ),
                                        content: Text(
                                          "You are about to delete the section ${_sectionLogs[sectionIndex]?.name}!",
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
                                              style: _diologActionTextFontStyle,
                                            ),
                                          ),
                                          TextButton(
                                            style: TextButton.styleFrom(
                                              primary: Colors.white,
                                            ),
                                            onPressed: () async {
                                              Navigator.of(context).pop();
                                              await BlocProvider.of<
                                                          SectionManagementCubit>(
                                                      context)
                                                  .deleteSection(
                                                advertisementModel:
                                                    _sectionLogs[sectionIndex]!,
                                                context: context,
                                              );
                                            },
                                            child: Text(
                                              'Yes',
                                              style: _diologActionTextFontStyle,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                    size: 18.sp,
                                  ),
                                );
                              } else {
                                return const SizedBox.shrink();
                              }
                            }
                          },
                        ),
                        buttonName: 'Add Image',
                        onPressed: () async {
                          await BlocProvider.of<SectionImagePickerCubit>(
                                  context)
                              .resetImage();
                          await showDialog(
                            context: context,
                            builder: (dialogContext) {
                              return StatefulBuilder(
                                  builder: (dialogContext, setState) {
                                return AlertDialog(
                                  title: Text(
                                    'Add Post',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                  content: AddImageDialogWidget(
                                    advertisementModel:
                                        _sectionLogs[sectionIndex]!,
                                  ),
                                );
                              });
                            },
                          );
                        },
                      ),
                      SectionImageBuilder(
                        sectionLog: _sectionLogs[sectionIndex]!,
                        discountTextFontStyle: _discountTextFontStyle,
                        diologHeadingTextFontStyle: _diologHeadingTextFontStyle,
                        diologBodyTextFontStyle: _diologBodyTextFontStyle,
                        diologActionTextFontStyle: _diologActionTextFontStyle,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}

class SectionImageBuilder extends StatelessWidget {
  const SectionImageBuilder({
    Key? key,
    required AdvertisementModel sectionLog,
    required TextStyle discountTextFontStyle,
    required TextStyle diologHeadingTextFontStyle,
    required TextStyle diologBodyTextFontStyle,
    required TextStyle diologActionTextFontStyle,
  })  : _sectionLog = sectionLog,
        _discountTextFontStyle = discountTextFontStyle,
        _diologHeadingTextFontStyle = diologHeadingTextFontStyle,
        _diologBodyTextFontStyle = diologBodyTextFontStyle,
        _diologActionTextFontStyle = diologActionTextFontStyle,
        super(key: key);

  final AdvertisementModel _sectionLog;
  final TextStyle _discountTextFontStyle;
  final TextStyle _diologHeadingTextFontStyle;
  final TextStyle _diologBodyTextFontStyle;
  final TextStyle _diologActionTextFontStyle;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<SectionImageModel?>>(
        stream: BlocProvider.of<SectionImageManagementCubit>(context)
            .fetchSectionImages(sectionDocId: _sectionLog.id!),
        builder: (context, imageSnapshot) {
          if (imageSnapshot.connectionState == ConnectionState.waiting) {
            return const Expanded(
              child: Center(
                child: SpinLoadingIndicator(),
              ),
            );
          } else {
            final _sectionImageLogs = imageSnapshot.data ?? [];
            if (_sectionImageLogs.isEmpty) {
              return Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    'No image available.',
                    style: TextStyle(
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              );
            } else {
              return Expanded(
                child: ListView.builder(
                    controller: ScrollController(),
                    itemCount: _sectionImageLogs.length,
                    itemBuilder: (context, sectionImageIndex) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 50.w),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CachedNetworkImage(
                                  fit: BoxFit.fitWidth,
                                  height: 100.h,
                                  width: 100.w,
                                  imageUrl: _sectionImageLogs[sectionImageIndex]
                                          ?.imageUrl ??
                                      '',
                                  progressIndicatorBuilder:
                                      (context, url, downloadProgress) =>
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
                                _sectionImageLogs[sectionImageIndex]?.name ??
                                    'N/A',
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
                                            style: _diologHeadingTextFontStyle,
                                          ),
                                          content: Text(
                                            "You are about to delete the image ${_sectionImageLogs[sectionImageIndex]?.name}!",
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
                                                            SectionImageManagementCubit>(
                                                        context)
                                                    .deleteSectionImage(
                                                  sectionImageModel:
                                                      _sectionImageLogs[
                                                          sectionImageIndex]!,
                                                  advertisementModel:
                                                      _sectionLog,
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
                                    icon: Icon(
                                      Icons.delete,
                                      size: 20.sp,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ]),
                      );
                    }),
              );
            }
          }
        });
  }
}
