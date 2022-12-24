import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:service365_admin_panel/constant/colors/base_screen_color.dart';
import 'package:service365_admin_panel/constant/const_name.dart';
import 'package:service365_admin_panel/landing_screen/order/logic/invoice_management/invoice_management_cubit.dart';
import 'package:service365_admin_panel/landing_screen/order/logic/order_management/ordermanagement_cubit.dart';
import 'package:service365_admin_panel/landing_screen/order/model/order_model.dart';
import 'package:service365_admin_panel/utility/booking_status_checker.dart';
import 'package:service365_admin_panel/utility/spinloading_indicator.dart';

class OrderDetailsCard extends StatelessWidget {
  final OrderModel orderModel;
  final int orderIndex;
  final bool allowChangeStatus;
  const OrderDetailsCard({
    Key? key,
    required this.orderModel,
    required this.orderIndex,
    this.allowChangeStatus = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _headingTextStyle = GoogleFonts.poppins(
        textStyle: TextStyle(
      color: BaseScreenColor.pageTitleTextfontColor,
      fontSize: 12.sp,
      fontWeight: FontWeight.w600,
    ));
    final _contentTextStyle = GoogleFonts.poppins(
        textStyle: TextStyle(
      color: BaseScreenColor.pageTitleTextfontColor,
      fontSize: 12.sp,
      fontWeight: FontWeight.w400,
    ));
    final _statusData =
        CheckBookingStatus().checkStatus(orderModel.bookingStatus);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 0.2.w),
          color: Colors.transparent,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Wrap(
                    children: [
                      Text(
                        'Booking Status : ',
                        style: _headingTextStyle,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.r),
                            color: _statusData.statusColor,
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            child: Text(
                              orderModel.bookingStatus.toUpperCase(),
                              style: _contentTextStyle,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (allowChangeStatus)
                    PopupMenuButton<String>(
                      iconSize: 16.sp,
                      tooltip: 'Change order status',
                      onSelected: (value) async {
                        final _oldBookingStatus = orderModel.bookingStatus;
                        orderModel.bookingStatus = value.toLowerCase();
                        await BlocProvider.of<OrdermanagementCubit>(context)
                            .changeBookingStatus(
                          context: context,
                          orderModel: orderModel,
                          oldBookingStatus: _oldBookingStatus,
                        );
                      },
                      itemBuilder: (BuildContext context) {
                        return {'Paid', 'Cancelled', 'OnHold', 'Pending'}
                            .map((String choice) {
                          return PopupMenuItem<String>(
                            value: choice,
                            child: Text(
                              choice,
                              style: _headingTextStyle,
                            ),
                          );
                        }).toList();
                      },
                    ),
                ],
              ),
              if (orderModel.bookingStatus.toUpperCase() == 'PAID')
                SizedBox(height: 5.h),
              if (orderModel.bookingStatus.toUpperCase() == 'PAID')
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      'Invoice : ',
                      style: _headingTextStyle,
                    ),
                    Text(
                      orderModel.invoice?.invoiceName ?? '',
                      style: _contentTextStyle,
                    ),
                    BlocBuilder<InvoiceManagementCubit, InvoiceManagementState>(
                      builder: (context, state) {
                        if (state is InvoicePicked &&
                            //Only allow the perticular box to update.
                            state.orderIndex == orderIndex) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 5.w,
                              vertical: 5.h,
                            ),
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Text(
                                  state.pickedInvoice.selectedFile!.path,
                                  style: _contentTextStyle,
                                ),
                                InvoiceActionButton(
                                  onPressed: () async {
                                    await BlocProvider.of<
                                            InvoiceManagementCubit>(context)
                                        .resetDocs();
                                  },
                                  buttonName: 'Cancel',
                                ),
                                InvoiceActionButton(
                                  onPressed: () async {
                                    await BlocProvider.of<
                                            InvoiceManagementCubit>(context)
                                        .uploadInvoice(
                                      context: context,
                                      pickedInvoice: state.pickedInvoice,
                                      orderModel: orderModel,
                                      orderIndex: orderIndex,
                                    );
                                  },
                                  buttonName: 'Upload',
                                ),
                              ],
                            ),
                          );
                        } else if (state is InvoiceUploading &&
                            //Only allow the perticular box to update.
                            state.orderIndex == orderIndex) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              height: 10.h,
                              width: 50.w,
                              child: const SpinLoadingIndicator(),
                            ),
                          );
                        } else {
                          return InvoiceActionButton(
                            onPressed: () async {
                              await BlocProvider.of<InvoiceManagementCubit>(
                                      context)
                                  .pickInvoice(
                                context: context,
                                orderIndex: orderIndex,
                              );
                            },
                            buttonName:
                                (orderModel.invoice!.isInvoiceAvailable!)
                                    ? 'Change Invoice'
                                    : 'Add Invoice',
                          );
                        }
                      },
                    ),
                  ],
                ),
              if (orderModel.bookingStatus == BookingStatus.raiseBackup)
                SizedBox(height: 5.h),
              if (orderModel.bookingStatus == BookingStatus.raiseBackup)
                const ContentHeading(heading: 'Raise Backup Details'),
              if (orderModel.bookingStatus == BookingStatus.raiseBackup)
                Wrap(
                  children: [
                    Text(
                      'Date: ',
                      style: _headingTextStyle,
                    ),
                    Text(
                      orderModel.raisedBackupModel?.selectedDate ?? 'N/A',
                      style: _contentTextStyle,
                    ),
                  ],
                ),
              if (orderModel.bookingStatus == BookingStatus.raiseBackup)
                Wrap(
                  children: [
                    Text(
                      'Description: ',
                      style: _headingTextStyle,
                    ),
                    Text(
                      orderModel.raisedBackupModel?.description ?? 'N/A',
                      style: _contentTextStyle,
                    ),
                  ],
                ),
              SizedBox(height: 5.h),
              const ContentHeading(heading: 'Customer Details'),
              Wrap(
                children: [
                  Text(
                    'Customer Name: ',
                    style: _headingTextStyle,
                  ),
                  Text(
                    orderModel.addressModel.name ?? 'N/A',
                    style: _contentTextStyle,
                  ),
                ],
              ),
              SizedBox(height: 5.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Phone: ',
                    style: _headingTextStyle,
                  ),
                  Text(
                    orderModel.addressModel.phoneNumber!,
                    style: _contentTextStyle,
                  ),
                ],
              ),
              SizedBox(height: 5.h),
              Wrap(
                children: [
                  Text(
                    'Address: ',
                    style: _headingTextStyle,
                  ),
                  Text(
                    "${orderModel.addressModel.address},${orderModel.addressModel.landmark},${orderModel.addressModel.city},${orderModel.addressModel.state},${orderModel.addressModel.pinCode}",
                    style: _contentTextStyle,
                  ),
                ],
              ),
              SizedBox(height: 5.h),
              const ContentHeading(heading: 'Booking Details'),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    'Booking for: ',
                    style: _headingTextStyle,
                  ),
                  Text(
                    orderModel.serviceModel.serviceName,
                    style: _contentTextStyle,
                  ),
                ],
              ),
              SizedBox(height: 5.h),
              Row(
                children: [
                  Expanded(
                    child: Wrap(
                      children: [
                        Text(
                          'Package Name: ',
                          style: _headingTextStyle,
                        ),
                        Text(
                          orderModel.packageDetails.packageName,
                          style: _contentTextStyle,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Wrap(
                      children: [
                        Text(
                          'Package Price: ',
                          style: _headingTextStyle,
                        ),
                        Text(
                          orderModel.packageDetails.packagePrice,
                          style: _contentTextStyle,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5.h),
              Row(
                children: [
                  Expanded(
                    child: Wrap(
                      children: [
                        Text(
                          'Start Date: ',
                          style: _headingTextStyle,
                        ),
                        Text(
                          DateFormat('MMM dd, EEEE')
                              .format(orderModel.startDate),
                          style: _contentTextStyle,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Wrap(
                      children: [
                        Text(
                          'End Date: ',
                          style: _headingTextStyle,
                        ),
                        Text(
                          DateFormat('MMM dd, EEEE').format(orderModel.endDate),
                          style: _contentTextStyle,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5.h),
              Row(
                children: [
                  Expanded(
                    child: Wrap(
                      children: [
                        Text(
                          'Service time: ',
                          style: _headingTextStyle,
                        ),
                        Text(
                          orderModel.selectedTime,
                          style: _contentTextStyle,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Wrap(
                      children: [
                        Text(
                          'Package type: ',
                          style: _headingTextStyle,
                        ),
                        Text(
                          orderModel.packageType,
                          style: _contentTextStyle,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ContentHeading extends StatelessWidget {
  final String heading;
  const ContentHeading({
    Key? key,
    required this.heading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _headingTextStyle = GoogleFonts.poppins(
        textStyle: TextStyle(
      color: BaseScreenColor.pageTitleTextfontColor,
      fontSize: 11.sp,
      fontWeight: FontWeight.w600,
    ));
    return Column(
      children: [
        const Divider(color: Colors.white),
        Text(heading, style: _headingTextStyle),
        const Divider(color: Colors.white),
      ],
    );
  }
}

class InvoiceActionButton extends StatelessWidget {
  final void Function()? onPressed;
  final String buttonName;
  const InvoiceActionButton({
    Key? key,
    required this.onPressed,
    required this.buttonName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _contentTextStyle = GoogleFonts.poppins(
        textStyle: TextStyle(
      color: BaseScreenColor.pageTitleTextfontColor,
      fontSize: 10.sp,
      fontWeight: FontWeight.w500,
    ));
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: ElevatedButton(
        child: Text(buttonName),
        style: ButtonStyle(
          padding: MaterialStateProperty.all(EdgeInsets.symmetric(
            horizontal: 10.w,
            vertical: 0.5.h,
          )),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.r),
            ),
          ),
          backgroundColor:
              MaterialStateProperty.all(BaseScreenColor.themeColor),
          foregroundColor:
              MaterialStateProperty.all(BaseScreenColor.buttonTextColor),
          textStyle: MaterialStateProperty.all(_contentTextStyle),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
