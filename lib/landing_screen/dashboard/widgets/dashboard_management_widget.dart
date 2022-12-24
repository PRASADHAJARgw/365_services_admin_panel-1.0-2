import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service365_admin_panel/landing_screen/dashboard/logic/fetch_dashboard_data/fetchdashboarddata_cubit.dart';
import 'package:service365_admin_panel/landing_screen/dashboard/widgets/box_widget.dart';
import 'package:service365_admin_panel/landing_screen/dashboard/widgets/order_analytics_chart.dart';
import 'package:service365_admin_panel/tools/responsive_handler.dart';
import 'package:service365_admin_panel/utility/spinloading_indicator.dart';

class DashBoardManagementWidget extends StatelessWidget {
  const DashBoardManagementWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      mobile: Column(children: const [
        TotalUserCounter(),
        OrderAnalyticsChart(),
      ]),
      desktop: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(height: 40.h),
          const TotalUserCounter(),
          SizedBox(height: 20.h),
          const OrderAnalyticsChart(),
        ],
      ),
    );
  }
}

class TotalUserCounter extends StatelessWidget {
  const TotalUserCounter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String?>(
      stream: BlocProvider.of<FetchdashboarddataCubit>(context)
          .fetchTotalUserNumber(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            width: 200.w,
            height: 200.h,
            child: const Center(
              child: SpinLoadingIndicator(),
            ),
          );
        } else {
          final _log = snapshot.data ?? '0';
          if (_log.isEmpty) {
            return const BoxWidget(
              heading: 'Total Customers:',
              content: '0',
            );
          } else {
            return BoxWidget(
              heading: 'Total Customers:',
              content: _log,
            );
          }
        }
      },
    );
  }
}
