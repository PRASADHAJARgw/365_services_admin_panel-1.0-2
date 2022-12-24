import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service365_admin_panel/landing_screen/customer/widget/customer_management_widget.dart';
import 'package:service365_admin_panel/landing_screen/dashboard/logic/dash_board_management/dashboardmanagement_bloc.dart';
import 'package:service365_admin_panel/landing_screen/dashboard/widgets/dashboard_management_widget.dart';
import 'package:service365_admin_panel/landing_screen/dashboard/widgets/side_menu.dart';
import 'package:service365_admin_panel/landing_screen/banner/widgets/banner_management_widget.dart';
import 'package:service365_admin_panel/landing_screen/document/widgets/document_management_widget.dart';
import 'package:service365_admin_panel/landing_screen/order/widgets/order_management_widget.dart';
import 'package:service365_admin_panel/landing_screen/section/widgets/section_management_widget.dart';
import 'package:service365_admin_panel/landing_screen/service_management/widgets/service_management_widget.dart';
import 'package:service365_admin_panel/tools/responsive_handler.dart';

class DashBoardScreen extends StatelessWidget {
  static const routeName = '/Dashboard';

  const DashBoardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        drawer: const Drawer(
          child: SideMenu(),
        ),
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (ResponsiveWidget.isDesktop(context))
              const Expanded(
                child: Drawer(
                  child: SideMenu(),
                ),
              ),
            Expanded(
              flex: 5,
              child: ListView(controller: ScrollController(), children: [
                if (!ResponsiveWidget.isDesktop(context))
                  Container(
                    color: Colors.grey.shade800,
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      color: Colors.white,
                      icon: const Icon(Icons.menu),
                      onPressed: () => _scaffoldKey.currentState!.openDrawer(),
                    ),
                  ),
                BlocBuilder<DashboardmanagementBloc, DashboardmanagementState>(
                  builder: (context, state) {
                    // if (state is ShowAgentManagement) {
                    //   return const OrderManagementWidget(),
                    // } else
                    if (state is ShowOrderManagement) {
                      return const OrderManagementWidget();
                    } else if (state is ShowServiceManagement) {
                      return const ServiceManagementWidget();
                    } else if (state is ShowBannerManagement) {
                      return const DiscountManagementWidget();
                    } else if (state is ShowSectionManagement) {
                      return const SectionManagementWidget();
                    } else if (state is ShowCustomerManagement) {
                      return const CustomerManagementWidget();
                    } else if (state is ShowDocumentManagement) {
                      return const DocumentManagementWidget();
                    } else {
                      return const DashBoardManagementWidget();
                    }
                  },
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
