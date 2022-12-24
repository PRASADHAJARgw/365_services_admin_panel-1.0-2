import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:service365_admin_panel/landing_screen/customer/model/user_model.dart';
import 'package:service365_admin_panel/landing_screen/customer/repository/customer_repository.dart';
import 'package:service365_admin_panel/landing_screen/order/model/order_model.dart';

part 'fetchcustomerdata_state.dart';

class FetchcustomerdataCubit extends Cubit<FetchcustomerdataState> {
  FetchcustomerdataCubit() : super(FetchcustomerdataInitial());
  final _customerRepository = CustomerRepository();
  Stream<List<UserModel?>> fetchCustomers() {
    return _customerRepository.streamTotalUserLog();
  }

  Stream<List<OrderModel?>> fetchCustomerOrdersLog({required String uid}) {
    return _customerRepository.streamUserOrdersLog(uid: uid);
  }
}
