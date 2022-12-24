import 'package:flutter/material.dart';
import 'package:service365_admin_panel/constant/colors/bookingcolor.dart';
import 'package:service365_admin_panel/constant/const_name.dart';

class CheckBookingStatus {
  PaymentStatusCheckModel checkStatus(
    String bookingStatus,
  ) {
    switch (bookingStatus) {
      case BookingStatus.pending:
        return PaymentStatusCheckModel(
          statusName: "Pending",
          statusColor: BookingScreenColor.paymentPendingColor,
        );

      case BookingStatus.cancelled:
        return PaymentStatusCheckModel(
          statusName: "Cancelled",
          statusColor: BookingScreenColor.paymentCancelledColor,
        );
      case BookingStatus.onHold:
        return PaymentStatusCheckModel(
          statusName: "OnHold",
          statusColor: BookingScreenColor.paymentOnHoldColor,
        );
      case BookingStatus.paid:
        return PaymentStatusCheckModel(
          statusName: "Paid",
          statusColor: BookingScreenColor.paymentPaidColor,
        );

      default:
        return PaymentStatusCheckModel(
          statusName: "Error",
          statusColor: BookingScreenColor.paymentErrorColor,
        );
    }
  }
}

class PaymentStatusCheckModel {
  final String statusName;
  final Color statusColor;
  PaymentStatusCheckModel({
    required this.statusName,
    required this.statusColor,
  });
}
