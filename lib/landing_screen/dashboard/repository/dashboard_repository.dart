import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:service365_admin_panel/config/firebase_table_name.dart';
import 'package:service365_admin_panel/landing_screen/order/model/admin_order_details_model.dart';

class DashBoardRepository {
  final _firebaseFirestore = FirebaseFirestore.instance;

  Stream<AdminOrderDetails?> streamAdminOrderDetailsLog() {
    try {
      return //Update admin dash board order details:
          _firebaseFirestore
              .collection(FirebasePath.dashboard)
              .doc(FirebasePath.adminOrderDetails)
              .snapshots()
              .map(
                (snaps) => AdminOrderDetails.fromMap(snaps.data()!),
              );
    } catch (error) {
      // print('Error getting stream of ORDER DETAILS ${error.toString()}');
      rethrow;
    }
  }

  Stream<String?> streamTotalUserNumberLog() {
    try {
      return //Update admin dash board order details:
          _firebaseFirestore
              .collection(FirebasePath.dashboard)
              .doc(FirebasePath.totalUser)
              .snapshots()
              .map((snaps) => snaps.data()?[FirebasePath.totalUser] ?? '0');
    } catch (error) {
      // print('Error getting stream of Total User ${error.toString()}');
      rethrow;
    }
  }
}
