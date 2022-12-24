import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:service365_admin_panel/config/firebase_table_name.dart';
import 'package:service365_admin_panel/landing_screen/customer/model/user_model.dart';
import 'package:service365_admin_panel/landing_screen/order/model/order_model.dart';

class CustomerRepository {
  final _firebaseFirestore = FirebaseFirestore.instance;

  Stream<List<UserModel?>> streamTotalUserLog() {
    try {
      return _firebaseFirestore.collection(FirebasePath.user).snapshots().map(
          (snaps) =>
              snaps.docs.map((doc) => UserModel.fromMap(doc.data())).toList());
    } catch (error) {
      rethrow;
    }
  }

  Stream<List<OrderModel?>> streamUserOrdersLog({required String uid}) {
    try {
      return _firebaseFirestore
          .collection(FirebasePath.user)
          .doc(uid)
          .collection(FirebasePath.orders)
          .snapshots()
          .map((snaps) =>
              snaps.docs.map((doc) => OrderModel.fromMap(doc.data())).toList());
    } catch (error) {
      // print('Error getting stream of service ${error.toString()}');
      rethrow;
    }
  }
}
