import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:service365_admin_panel/landing_screen/dashboard/repository/dashboard_repository.dart';
import 'package:service365_admin_panel/landing_screen/order/model/admin_order_details_model.dart';
part 'fetchdashboarddata_state.dart';

class FetchdashboarddataCubit extends Cubit<FetchdashboarddataState> {
  FetchdashboarddataCubit() : super(FetchdashboarddataInitial());

  final _dashBoardRepository = DashBoardRepository();
  Stream<String?> fetchTotalUserNumber() {
    return _dashBoardRepository.streamTotalUserNumberLog();
  }

  Stream<AdminOrderDetails?> fetchTotalOrderDetails() {
    return _dashBoardRepository.streamAdminOrderDetailsLog();
  }
}
