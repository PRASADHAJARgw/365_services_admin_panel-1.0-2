import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:service365_admin_panel/constant/colors/base_screen_color.dart';
import 'package:service365_admin_panel/landing_screen/dashboard/logic/fetch_dashboard_data/fetchdashboarddata_cubit.dart';
import 'package:service365_admin_panel/landing_screen/dashboard/widgets/box_widget.dart';
import 'package:service365_admin_panel/utility/spinloading_indicator.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:service365_admin_panel/landing_screen/order/model/admin_order_details_model.dart';
import 'package:service365_admin_panel/landing_screen/dashboard/model/chart_model.dart';

class OrderAnalyticsChart extends StatefulWidget {
  const OrderAnalyticsChart({Key? key}) : super(key: key);

  @override
  State<OrderAnalyticsChart> createState() => _OrderAnalyticsChartState();
}

class _OrderAnalyticsChartState extends State<OrderAnalyticsChart> {
  late TooltipBehavior _tooltip;
  @override
  void initState() {
    _tooltip = TooltipBehavior(enable: true, format: 'point.x : point.y');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _textStyle = GoogleFonts.poppins(
        textStyle: TextStyle(
      color: BaseScreenColor.pageTitleTextfontColor,
      fontSize: 15.sp,
      fontWeight: FontWeight.w600,
    ));
    return StreamBuilder<AdminOrderDetails?>(
        stream: BlocProvider.of<FetchdashboarddataCubit>(context)
            .fetchTotalOrderDetails(),
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
            final _log = snapshot.data;
            if (_log == null || _log.totalOrder == 0) {
              return Text(
                'No orders found for analytics',
                style: _textStyle,
              );
            } else {
              return SizedBox(
                width: 600.w,
                height: 500.h,
                child: Column(
                  children: [
                    Expanded(
                      child: SfCircularChart(
                        title: ChartTitle(
                          text: 'Orders Analytics',
                          textStyle: _textStyle,
                        ),
                        legend: Legend(
                          isVisible: true,
                          overflowMode: LegendItemOverflowMode.wrap,
                        ),
                        series: <PieSeries<ChartSampleData, String>>[
                          PieSeries<ChartSampleData, String>(
                            radius: '80%',
                            explode: true,
                            explodeOffset: '10%',
                            dataSource: <ChartSampleData>[
                              ChartSampleData(
                                x: 'Pending Orders',
                                y: _log.pendingOrder,
                                text: 'Pending Orders\n${_log.pendingOrder}',
                              ),
                              ChartSampleData(
                                x: 'Paid Orders',
                                y: _log.paidOrder,
                                text: 'Paid Orders\n${_log.paidOrder}',
                              ),
                              ChartSampleData(
                                x: 'On Hold Orders',
                                y: _log.onholdOrder,
                                text: 'On Hold Orders\n${_log.onholdOrder}',
                              ),
                              ChartSampleData(
                                x: 'Cancelled Orders',
                                y: _log.cancelledOrder,
                                text: 'Cancelled Orders\n${_log.cancelledOrder}',
                              ),
                              ChartSampleData(
                                x: 'Raised Backup Orders',
                                y: _log.raisedBackupOrder,
                                text:
                                    'Raised Backup Orders\n${_log.raisedBackupOrder}',
                              ),
                            ],
                            xValueMapper: (ChartSampleData data, _) =>
                                data.x as String,
                            yValueMapper: (ChartSampleData data, _) => data.y,
                            dataLabelMapper: (ChartSampleData data, _) =>
                                data.text,
                            dataLabelSettings:
                                const DataLabelSettings(isVisible: true),
                          )
                        ],
                        tooltipBehavior: _tooltip,
                      ),
                    ),
                    BoxWidget(
                      heading: 'Total orders:',
                      content: _log.totalOrder.toString(),
                    )
                  ],
                ),
              );
            }
          }
        });
  }
}
