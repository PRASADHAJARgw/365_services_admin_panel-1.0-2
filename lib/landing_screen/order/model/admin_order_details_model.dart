class AdminOrderDetails {
  int? totalOrder;
  int? pendingOrder;
  int? paidOrder;
  int? onholdOrder;
  int? cancelledOrder;
  int? raisedBackupOrder;

  AdminOrderDetails({
    this.totalOrder,
    this.pendingOrder,
    this.paidOrder,
    this.onholdOrder,
    this.cancelledOrder,
    this.raisedBackupOrder,
  });

  Map<String, dynamic> toMap() {
    return {
      'totalOrder': totalOrder,
      'pendingOrder': pendingOrder,
      'paidOrder': paidOrder,
      'onholdOrder': onholdOrder,
      'cancelledOrder': cancelledOrder,
      'raisedBackupOrder': raisedBackupOrder,
    };
  }

  factory AdminOrderDetails.fromMap(Map<String, dynamic> map) {
    return AdminOrderDetails(
      totalOrder: map['totalOrder']?.toInt(),
      pendingOrder: map['pendingOrder']?.toInt(),
      paidOrder: map['paidOrder']?.toInt(),
      onholdOrder: map['onholdOrder']?.toInt(),
      cancelledOrder: map['cancelledOrder']?.toInt(),
      raisedBackupOrder: map['raisedBackupOrder']?.toInt(),
    );
  }
}
