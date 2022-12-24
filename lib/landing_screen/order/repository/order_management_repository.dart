import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:service365_admin_panel/config/firebase_table_name.dart';
import 'package:service365_admin_panel/landing_screen/order/helper/path_selector.dart';
import 'package:service365_admin_panel/landing_screen/order/model/admin_order_details_model.dart';
import 'package:service365_admin_panel/landing_screen/order/model/invoice_model.dart';
import 'package:service365_admin_panel/landing_screen/order/model/order_model.dart';
import 'package:service365_admin_panel/utility/document_picker.dart';

class OrderManagementRepository {
  final _firebaseFirestore = FirebaseFirestore.instance;

  Future<void> uploadInvoice({
    required PickedDocumentModel pickedInvoice,
    required OrderModel orderModel,
  }) async {
    final _ref = FirebaseStorage.instance
        .ref()
        .child('invoices')
        .child(pickedInvoice.selectedFile!.path);
    await _ref.putData(
      pickedInvoice.readAsBytes!,
      SettableMetadata(contentType: 'application/pdf'),
    );
    final _docsUrl = await _ref.getDownloadURL();
    final _invoiceModel = InvoiceModel(
      invoiceName: pickedInvoice.selectedFile!.path,
      invoiceUrl: _docsUrl,
      isInvoiceAvailable: true,
    );
    orderModel.invoice = _invoiceModel;
    //Update user order status
    await _firebaseFirestore
        .collection(FirebasePath.user)
        .doc(orderModel.customerId)
        .collection(FirebasePath.orders)
        .doc(orderModel.orderId)
        .update(
          orderModel.toMap(),
        );
    //Update top of the tree order status
    await _firebaseFirestore
        .collection(FirebasePath.adminPaidOrders)
        .doc(orderModel.orderId)
        .update(orderModel.toMap());
  }




  Future<void> changeBookingStatus({
    required OrderModel orderModel,
    required String oldBookingStatus,
  }) async {
    try {
      //Delete from old list
      await _firebaseFirestore
          .collection(PathSelector.pathSelecter(bookingStatus: oldBookingStatus))
          .doc(orderModel.orderId)
          .delete();

      //Update top of the tree order status
      await _firebaseFirestore
          .collection(PathSelector.pathSelecter(bookingStatus: orderModel.bookingStatus))
          .doc(orderModel.orderId)
          .set(orderModel.toMap());

      //Update user order status
      await _firebaseFirestore
          .collection(FirebasePath.user)
          .doc(orderModel.customerId)
          .collection(FirebasePath.orders)
          .doc(orderModel.orderId)
          .update(orderModel.toMap());

      final _dashboardAdminOrderDetailsDocs = _firebaseFirestore
          .collection(FirebasePath.dashboard)
          .doc(FirebasePath.adminOrderDetails);
      final _dashBoardOrderData = await _dashboardAdminOrderDetailsDocs.get();

      final _adminOrderDetails =
          AdminOrderDetails.fromMap(_dashBoardOrderData.data()!);

      //Update admin dash board order details:
      await _dashboardAdminOrderDetailsDocs.update(
        UpdateAdminPanelOrderDetails.updateAdminOrderDetails(
          adminOrderDetails: _adminOrderDetails,
          oldBookingStatus: oldBookingStatus,
          newSelectedBookingStatus: orderModel.bookingStatus,
        ).toMap(),
      );
      return;
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<OrderModel?>> streamPendingOrderLog() {
    try {
      return _firebaseFirestore
          .collection(FirebasePath.adminPendingOrders)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snaps) =>
              snaps.docs.map((doc) => OrderModel.fromMap(doc.data())).toList());
    } catch (error) {
      // print('Error getting stream of service ${error.toString()}');
      rethrow;
    }
  }

  Stream<List<OrderModel?>> streamPaidOrderLog() {
    try {
      return _firebaseFirestore
          .collection(FirebasePath.adminPaidOrders)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snaps) =>
              snaps.docs.map((doc) => OrderModel.fromMap(doc.data())).toList());
    } catch (error) {
      // print('Error getting stream of service ${error.toString()}');
      rethrow;
    }
  }

  Stream<List<OrderModel?>> streamOnHoldOrderLog() {
    try {
      return _firebaseFirestore
          .collection(FirebasePath.adminOnHoldOrders)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snaps) =>
              snaps.docs.map((doc) => OrderModel.fromMap(doc.data())).toList());
    } catch (error) {
      // print('Error getting stream of service ${error.toString()}');
      rethrow;
    }
  }

  Stream<List<OrderModel?>> streamCancelledOrderLog() {
    try {
      return _firebaseFirestore
          .collection(FirebasePath.adminCancelledOrders)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snaps) =>
              snaps.docs.map((doc) => OrderModel.fromMap(doc.data())).toList());
    } catch (error) {
      // print('Error getting stream of service ${error.toString()}');
      rethrow;
    }
  }

  Stream<List<OrderModel?>> streamRaisedBackupLog() {
    try {
      return _firebaseFirestore
          .collection(FirebasePath.adminRaisedBakupOrders)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snaps) =>
              snaps.docs.map((doc) => OrderModel.fromMap(doc.data())).toList());
    } catch (error) {
      // print('Error getting stream of service ${error.toString()}');
      rethrow;
    }
  }
}
