import 'package:service365_admin_panel/constant/const_name.dart';
import 'package:service365_admin_panel/landing_screen/customer/model/address_model.dart';
import 'package:service365_admin_panel/landing_screen/order/model/invoice_model.dart';
import 'package:service365_admin_panel/landing_screen/order/model/package_data_model.dart';
import 'package:service365_admin_panel/landing_screen/order/model/raise_backup_model.dart';
import 'package:service365_admin_panel/landing_screen/service_management/model/service_model.dart';

class OrderModel {
  String? orderId;
  String? bookingId;
  InvoiceModel? invoice;
  DateTime? createdAt;
  final String customerId;
  final String packageType;
  final PackageDetailsModel packageDetails;
  final DateTime startDate;
  final DateTime endDate;
  final String selectedTime;
  final AddressModel addressModel;
  final ServiceModel serviceModel;
  final RaisedBackupModel? raisedBackupModel;
  String bookingStatus;

  OrderModel({
    this.orderId,
    this.bookingId,
    this.invoice,
    this.createdAt,
    required this.customerId,
    required this.packageType,
    required this.packageDetails,
    required this.startDate,
    required this.endDate,
    required this.selectedTime,
    required this.addressModel,
    required this.serviceModel,
    this.raisedBackupModel,
    this.bookingStatus = BookingStatus.pending,
  });

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'bookingId': bookingId,
      'invoice': invoice?.toMap(),
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'customerId': customerId,
      'packageType': packageType,
      'packageDetails': packageDetails.toMap(),
      'startDate': startDate.millisecondsSinceEpoch,
      'endDate': endDate.millisecondsSinceEpoch,
      'selectedTime': selectedTime,
      'addressModel': addressModel.toMap(),
      'serviceModel': serviceModel.toMap(),
      'raisedBackupModel': raisedBackupModel?.toMap(),
      'bookingStatus': bookingStatus,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      orderId: map['orderId'],
      bookingId: map['bookingId'] ?? '',
      customerId: map['customerId'] ?? '',
      packageType: map['packageType'] ?? '',
      invoice: InvoiceModel.fromMap(map['invoice']),
      packageDetails: PackageDetailsModel.fromMap(map['packageDetails']),
      startDate: DateTime.fromMillisecondsSinceEpoch(map['startDate']),
      endDate: DateTime.fromMillisecondsSinceEpoch(map['endDate']),
      createdAt: map['createdAt'] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      selectedTime: map['selectedTime'],
      addressModel: AddressModel.fromMap(map['addressModel']),
      serviceModel: ServiceModel.fromMap(map['serviceModel']),
      raisedBackupModel: map['raisedBackupModel'] == null
          ? null
          : RaisedBackupModel.fromMap(map['raisedBackupModel']),
      bookingStatus: map['bookingStatus'],
    );
  }
}
