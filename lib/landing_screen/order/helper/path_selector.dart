import 'package:service365_admin_panel/config/firebase_table_name.dart';
import 'package:service365_admin_panel/constant/const_name.dart';
import 'package:service365_admin_panel/landing_screen/order/model/admin_order_details_model.dart';

class PathSelector {
  static String pathSelecter({required String bookingStatus}) {
    late String _path;
    switch (bookingStatus) {
      case BookingStatus.paid:
        _path = FirebasePath.adminPaidOrders;
        break;
      case BookingStatus.cancelled:
        _path = FirebasePath.adminCancelledOrders;
        break;
      case BookingStatus.onHold:
        _path = FirebasePath.adminOnHoldOrders;
        break;
      case BookingStatus.raiseBackup:
        _path = FirebasePath.adminRaisedBakupOrders;
        break;
      default:
        _path = FirebasePath.adminPendingOrders;
    }
    return _path;
  }
}

class UpdateAdminPanelOrderDetails {
  static AdminOrderDetails updateAdminOrderDetails({
    required AdminOrderDetails adminOrderDetails,
    required String oldBookingStatus,
    required String newSelectedBookingStatus,
  }) {
    //Decrease order number from old status field
    switch (oldBookingStatus) {
      case BookingStatus.pending:
        adminOrderDetails.pendingOrder = adminOrderDetails.pendingOrder! - 1;
        break;
      case BookingStatus.onHold:
        adminOrderDetails.onholdOrder = adminOrderDetails.onholdOrder! - 1;
        break;
      case BookingStatus.paid:
        adminOrderDetails.paidOrder = adminOrderDetails.paidOrder! - 1;
        break;
      case BookingStatus.raiseBackup:
        adminOrderDetails.raisedBackupOrder =
            adminOrderDetails.raisedBackupOrder! - 1;
        break;
      default:
        adminOrderDetails.cancelledOrder =
            adminOrderDetails.cancelledOrder! - 1;
    }

    //Increase order number from newly selected status field
    switch (newSelectedBookingStatus) {
      case BookingStatus.pending:
        adminOrderDetails.pendingOrder = adminOrderDetails.pendingOrder! + 1;
        break;
      case BookingStatus.onHold:
        adminOrderDetails.onholdOrder = adminOrderDetails.onholdOrder! + 1;
        break;
      case BookingStatus.paid:
        adminOrderDetails.paidOrder = adminOrderDetails.paidOrder! + 1;
        break;
      case BookingStatus.raiseBackup:
        adminOrderDetails.raisedBackupOrder =
            adminOrderDetails.raisedBackupOrder! + 1;
        break;
      default:
        adminOrderDetails.cancelledOrder =
            adminOrderDetails.cancelledOrder! + 1;
    }
    return adminOrderDetails;
  }
}
