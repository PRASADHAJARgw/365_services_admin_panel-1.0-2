import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service365_admin_panel/authentication/logic/authentication/authentication_bloc.dart';
import 'package:service365_admin_panel/constant/colors/base_screen_color.dart';
import 'package:service365_admin_panel/landing_screen/dashboard/logic/dash_board_management/dashboardmanagement_bloc.dart';
import 'package:service365_admin_panel/tools/responsive_handler.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  State<SideMenu> createState() => _SideMenuState();
}

DashboardmanagementState _state = ShowDashboard();

class _SideMenuState extends State<SideMenu> {
  @override
  Widget build(BuildContext context) {
    final _deviceSize = MediaQuery.of(context).size;
    return Drawer(
      child: BlocListener<DashboardmanagementBloc, DashboardmanagementState>(
        listener: (context, state) {
          setState(() {
            _state = state;
          });
        },
        child: ListView(
          children: [
            DrawerHeader(
              child: InkWell(
                onTap: () {
                  //If the drawer open on mobile or tablet, then close the drawer onTap()
                  if (!ResponsiveWidget.isDesktop(context)) {
                    Navigator.of(context).pop();
                  }
                  BlocProvider.of<DashboardmanagementBloc>(context)
                      .add(OpenDashBoard());
                },
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Dashboard',
                    style: TextStyle(fontSize: 18.sp),
                  ),
                ),
              ),
            ),
            SizedBox(height: _deviceSize.height * 0.04),
            // DrawerListTile(
            //   title: "Agent Management",
            //   icon: Icons.person,
            //   onTap: () {
            //     BlocProvider.of<DashboardmanagementBloc>(context)
            //         .add(OpenAgentManagement());
            //   },
            // ),
            DrawerListTile(
              selected: _state.toString().contains('ShowOrderManagement'),
              title: "Order Management",
              icon: Icons.room_service_sharp,
              onTap: () {
                BlocProvider.of<DashboardmanagementBloc>(context)
                    .add(OpenOrderManagement());
              },
            ),
            DrawerListTile(
              selected: _state.toString().contains('ShowServiceManagement'),
              title: "Service Management",
              icon: Icons.home_repair_service,
              onTap: () {
                BlocProvider.of<DashboardmanagementBloc>(context)
                    .add(OpenServiceManagement());
              },
            ),
            DrawerListTile(
              selected: _state.toString().contains('ShowBannerManagement'),
              title: "Banner Management",
              icon: Icons.photo_album_outlined,
              onTap: () {
                BlocProvider.of<DashboardmanagementBloc>(context)
                    .add(OpenBannerManagement());
              },
            ),
            DrawerListTile(
              selected: _state.toString().contains('ShowSectionManagement'),
              title: "Section Management",
              icon: Icons.photo_album_outlined,
              onTap: () {
                BlocProvider.of<DashboardmanagementBloc>(context)
                    .add(OpenSectionManagement());
              },
            ),
            DrawerListTile(
              selected: _state.toString().contains('ShowCustomerManagement'),
              title: "Customer Management",
              icon: Icons.supervisor_account_outlined,
              onTap: () {
                BlocProvider.of<DashboardmanagementBloc>(context)
                    .add(OpenCustomerManagement());
              },
            ),
            DrawerListTile(
              selected: _state.toString().contains('ShowDocumentManagement'),
              title: "Document Management",
              icon: Icons.dashboard_customize,
              onTap: () {
                BlocProvider.of<DashboardmanagementBloc>(context)
                    .add(OpenDocumentManagement());
              },
            ),
            Column(children: [
              DrawerListTile(
                title: "Logout",
                icon: Icons.logout_sharp,
                onTap: () {
                  BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
                },
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.w),
                child: Text(
                  FirebaseAuth.instance.currentUser != null
                      ? '(${FirebaseAuth.instance.currentUser!.email})'
                      : '',
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 10,
                  ),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final bool selected;
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.icon,
    required this.onTap,
    this.selected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      selected: selected,
      selectedTileColor: BaseScreenColor.themeColor,
      // selectedTileColor: Colors.pink,
      onTap: () {
        //If the drawer open on mobile or tablet, then close the drawer onTap()
        if (!ResponsiveWidget.isDesktop(context)) {
          Navigator.of(context).pop();
        }
        onTap();
      },
      horizontalTitleGap: 0.0,
      leading: Icon(
        icon,
        color: selected ? Colors.black : Colors.white54,
        size: 15.sp,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: selected ? Colors.black : Colors.white54,
          fontSize: 13.sp,
        ),
      ),
    );
  }
}
