part of 'dashboardmanagement_bloc.dart';

abstract class DashboardmanagementEvent extends Equatable {
  const DashboardmanagementEvent();

  @override
  List<Object> get props => [];
}

class OpenDashBoard extends DashboardmanagementEvent {}

class OpenAgentManagement extends DashboardmanagementEvent {}

class OpenOrderManagement extends DashboardmanagementEvent {}

class OpenServiceManagement extends DashboardmanagementEvent {}

class OpenCustomerManagement extends DashboardmanagementEvent {}

class OpenDocumentManagement extends DashboardmanagementEvent {}

class OpenBannerManagement extends DashboardmanagementEvent {}

class OpenSectionManagement extends DashboardmanagementEvent {}
