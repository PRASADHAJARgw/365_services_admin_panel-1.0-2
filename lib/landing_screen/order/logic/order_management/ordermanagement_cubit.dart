import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:service365_admin_panel/landing_screen/order/model/order_model.dart';
import 'package:service365_admin_panel/landing_screen/order/repository/order_management_repository.dart';
import 'package:service365_admin_panel/utility/show_snak_bar.dart';
part 'ordermanagement_state.dart';

class OrdermanagementCubit extends Cubit<OrdermanagementState> {
  OrdermanagementCubit() : super(OrdermanagementInitial());
  final _orderManagementRepository = OrderManagementRepository();
  Future<void> changeBookingStatus({
    required BuildContext context,
    required OrderModel orderModel,
    required String oldBookingStatus,
  }) async {
    try {
      await _orderManagementRepository.changeBookingStatus(
        orderModel: orderModel,
        oldBookingStatus: oldBookingStatus,
      );
      ShowSnackBar.showSnackBar(
        context,
        'Order status changed to ${orderModel.bookingStatus}',
      );
      return;
    } catch (e) {
      ShowSnackBar.showSnackBar(
        context,
        'Unable to change order status',
      );
      return;
    }
  }
}
