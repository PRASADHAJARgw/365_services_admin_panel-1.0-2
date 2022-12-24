import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'dashboardmanagement_event.dart';
part 'dashboardmanagement_state.dart';

class DashboardmanagementBloc
    extends Bloc<DashboardmanagementEvent, DashboardmanagementState> {
  DashboardmanagementBloc() : super(ShowDashboard()) {
    on<DashboardmanagementEvent>((event, emit) {
      switch (event.runtimeType) {
        case OpenAgentManagement:
          emit(ShowAgentManagement());
          return;
        case OpenOrderManagement:
          emit(ShowOrderManagement());
          return;
        case OpenServiceManagement:
          emit(ShowServiceManagement());
          return;
        case OpenCustomerManagement:
          emit(ShowCustomerManagement());
          return;
        case OpenBannerManagement:
          emit(ShowBannerManagement());
          return;
        case OpenDocumentManagement:
          emit(ShowDocumentManagement());
          return;
        case OpenSectionManagement:
          emit(ShowSectionManagement());
          return;
        default:
          emit(ShowDashboard());
          return;
      }
    });
  }
}
