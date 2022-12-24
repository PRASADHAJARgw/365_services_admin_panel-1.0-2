import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:service365_admin_panel/constant/colors/base_screen_color.dart';
import 'package:service365_admin_panel/landing_screen/customer/logic/fetch_customer_data/fetchcustomerdata_cubit.dart';
import 'package:service365_admin_panel/landing_screen/customer/model/user_model.dart';
import 'package:service365_admin_panel/landing_screen/customer/widget/view_order_dialog.dart';
import 'package:service365_admin_panel/utility/spinloading_indicator.dart';

class CustomerManagementWidget extends StatelessWidget {
  const CustomerManagementWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _headingTextStyle = GoogleFonts.poppins(
        textStyle: TextStyle(
      color: BaseScreenColor.pageTitleTextfontColor,
      fontSize: 12.sp,
      fontWeight: FontWeight.w400,
    ));
    final _contentTextStyle = GoogleFonts.poppins(
        textStyle: TextStyle(
      color: BaseScreenColor.pageTitleTextfontColor,
      fontSize: 12.sp,
      fontWeight: FontWeight.w600,
    ));
    final _textStyle = GoogleFonts.poppins(
        textStyle: TextStyle(
      color: BaseScreenColor.pageTitleTextfontColor,
      fontSize: 14.sp,
      fontWeight: FontWeight.w600,
    ));
    final _themeTextStyle = GoogleFonts.poppins(
        textStyle: TextStyle(
      color: BaseScreenColor.themeColor,
      fontSize: 12.sp,
      fontWeight: FontWeight.w600,
    ));
    return StreamBuilder<List<UserModel?>>(
        stream:
            BlocProvider.of<FetchcustomerdataCubit>(context).fetchCustomers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox(
              width: 200.w,
              height: 200.h,
              child: const Center(
                child: SpinLoadingIndicator(),
              ),
            );
          } else {
            final _log = snapshot.data ?? [];
            if (_log.isEmpty) {
              return SizedBox(
                width: 200.w,
                height: 200.h,
                child: Center(
                  child: Text(
                    'No user available!',
                    style: _textStyle,
                  ),
                ),
              );
            } else {
              return Center(
                child: Container(
                  alignment: Alignment.center,
                  width: 450.w,
                  child: ListView.builder(
                    shrinkWrap: true,
                    controller: ScrollController(),
                    itemCount: _log.length,
                    itemBuilder: (context, index) => Padding(
                      padding: EdgeInsets.symmetric(vertical: 4.h),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 5.h,
                          horizontal: 5.w,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.white, width: 0.2.w),
                            color: Colors.black,
                          ),
                          child: Column(
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 6.h),
                                CircleAvatar(
                                  backgroundColor: BaseScreenColor.themeColor,
                                  radius: 32,
                                  child: CircleAvatar(
                                    radius: 30,
                                    // backgroundColor:
                                    //     UserProfileScreenColor.listtileColor,
                                    foregroundImage:
                                        _log[index]!.profileImageUrl == null
                                            ? null
                                            : CachedNetworkImageProvider(
                                                _log[index]!.profileImageUrl!,
                                              ),
                                    backgroundImage: const AssetImage(
                                      'empty_profile_picture.jpg',
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5.h),
                                Wrap(
                                  alignment: WrapAlignment.center,
                                  children: [
                                    Text(
                                      'Registered customer name : ',
                                      style: _headingTextStyle,
                                    ),
                                    Text(
                                      _log[index]!.name ?? 'N/A',
                                      style: _contentTextStyle,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5.h),
                                Wrap(
                                  alignment: WrapAlignment.center,
                                  children: [
                                    Text(
                                      'Phone number : ',
                                      style: _headingTextStyle,
                                    ),
                                    Text(
                                      _log[index]!.phone,
                                      style: _contentTextStyle,
                                    ),
                                  ],
                                ),
                                TextButton(
                                  onPressed: () async {
                                    await showDialog(
                                      context: context,
                                      builder: (dialogContext) {
                                        return StatefulBuilder(
                                            builder: (dialogContext, setState) {
                                          return AlertDialog(
                                            title: Text(
                                              'Orders',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14.sp,
                                              ),
                                            ),
                                            content: ViewOrderDialogWidget(
                                              uid: _log[index]!.uid,
                                            ),
                                          );
                                        });
                                      },
                                    );
                                  },
                                  child: Text(
                                    'View order',
                                    style: _themeTextStyle,
                                  ),
                                ),
                              ]),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }
          }
        });
  }
}
