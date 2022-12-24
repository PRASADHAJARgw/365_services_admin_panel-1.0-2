import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:service365_admin_panel/landing_screen/order/model/order_model.dart';
import 'package:service365_admin_panel/landing_screen/order/repository/order_management_repository.dart';

part 'fetchorder_state.dart';

class FetchorderCubit extends Cubit<FetchorderState> {
  FetchorderCubit() : super(FetchorderInitial());
  final _orderManagementRepository = OrderManagementRepository();
  Stream<List<OrderModel?>> fetchPendingOrder() {
    return _orderManagementRepository.streamPendingOrderLog();
  }

  Stream<List<OrderModel?>> fetchPaidOrder() {
    return _orderManagementRepository.streamPaidOrderLog();
  }

  Stream<List<OrderModel?>> fetchCancelledOrder() {
    return _orderManagementRepository.streamCancelledOrderLog();
  }

  Stream<List<OrderModel?>> fetchOnHoldOrder() {
    return _orderManagementRepository.streamOnHoldOrderLog();
  }
    Stream<List<OrderModel?>> fetchRaisedBackupOrder() {
    return _orderManagementRepository.streamRaisedBackupLog();
  }
}
