part of 'dashboardmanagement_bloc.dart';

abstract class DashboardmanagementState extends Equatable {
  const DashboardmanagementState();

  @override
  List<Object> get props => [];
}

class ShowDashboard extends DashboardmanagementState {}

class ShowAgentManagement extends DashboardmanagementState {}

class ShowOrderManagement extends DashboardmanagementState {}

class ShowServiceManagement extends DashboardmanagementState {}

class ShowCustomerManagement extends DashboardmanagementState {}

class ShowBannerManagement extends DashboardmanagementState {}

class ShowDocumentManagement extends DashboardmanagementState {}

class ShowSectionManagement extends DashboardmanagementState {}
